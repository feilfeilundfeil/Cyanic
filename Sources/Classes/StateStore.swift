//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import Foundation
import RxCocoa
import RxSwift
import os

internal let CyanicStateStorelLog: OSLog = OSLog(subsystem: Constants.bundleIdentifier, category: "StateStore")

/**
 StateStore manages the State of the ViewModel instance. It ensures that all setState calls are
 resolved before withState calls are executed.
*/
internal class StateStore<ConcreteState: State> {

    /**
     Initializer.
     - Parameters:
        - initialState: The initial value of StateType.
    */
    internal init(initialState: ConcreteState) {
        self.stateRelay = BehaviorRelay<ConcreteState>(value: initialState)

        let id: String = UUID().uuidString
        let queue: DispatchQueue = DispatchQueue(label: id, qos: DispatchQoS.userInitiated)
        self.scheduler = SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: "\(id) internal")

        self.executionRelay
            .observeOn(self.scheduler)
            .debounce(RxTimeInterval.milliseconds(1), scheduler: self.scheduler)
            .bind(
                onNext: { [weak self] () -> Void in
                    self?.resolveClosureQueue()
                }
            )
            .disposed(by: self.disposeBag)
    }

    deinit {
        logDeallocation(of: self, log: CyanicStateStorelLog)
    }

    /**
     The scheduler where all pending closures related to State are resolved.
    */
    private let scheduler: SerialDispatchQueueScheduler

    /**
     The BehaviorRelay that encapsulates State.
    */
    internal let stateRelay: BehaviorRelay<ConcreteState>

    /**
     The PublishRelay that is responsible for resolving the withState and setState closures on State.
    */
    private let executionRelay: PublishRelay<Void> = PublishRelay<Void>()

    /**
     The NSRecursiveLock instance used to add getState and setState closures to the ClosureQueue and emit an executionRelay element in
     a serial manner.
    */
    private let lock: NSRecursiveLock = NSRecursiveLock()

    /**
     The ClosureQueue instance that manages the setState and withState queues.
    */
    private let closureQueue: ClosureQueue<ConcreteState> = ClosureQueue<ConcreteState>()

    /**
     The DisposeBag for Rx related subcriptions
    */
    private let disposeBag: DisposeBag = DisposeBag()

    /**
     Resolves all pending setState closures then resolves all pending withState closures.
    */
    private func resolveClosureQueue() {
        self.resolveSetStateQueue()

        // When unit testing, stress testing around 2_310 withState calls will cause a crash due to
        // a bad access crash when removeFirst() is called.
        // The only alternative is to resolve all withState blocks after all the current setState calls are resolved.
        guard let getBlock = self.closureQueue.dequeueFirstWithStateCallback() else { return }
        getBlock(self.currentState)
        self.resolveClosureQueue()
    }

    /**
     Resolves all setState closures and emits a new State value.
    */
    private func resolveSetStateQueue() {
        let reducers: [(inout ConcreteState) -> Void] = self.closureQueue.dequeueAllSetStateClosures()
        guard !reducers.isEmpty
            else { return }
        let newState: ConcreteState = reducers
            .reduce(into: self.currentState) { (state: inout ConcreteState, block: (inout ConcreteState) -> Void) -> Void in
                block(&state)
            }

        guard newState != self.currentState
            else { return }
        self.stateRelay.accept(newState)
    }

    /**
     The current value of the State.
    */
    internal var currentState: ConcreteState { return self.stateRelay.value }

    /**
     The Observable encapsulating the State.
    */
    internal var state: Observable<ConcreteState> { return self.stateRelay.asObservable() }

    /**
     Adds the block to the withStateQueue and makes the executionRelay emit a new value.
     - Parameters:
        - block: The closure executed on the latest value of the StateType.
        - currentState: The current value of the State.
    */
    internal func getState(with block: @escaping (_ currentState: ConcreteState) -> Void) {
        self.lock.lock(); defer { self.lock.unlock() }
        self.closureQueue.add(block: block)
        self.executionRelay.accept(())
    }

    /**
     Adds the reducer to the setStateQueue and makes the executionRelay emit a new value.
     - Parameters:
        - reducer: The closure to set/mutate the StateType.
    */
    internal func setState(with reducer: @escaping (inout ConcreteState) -> Void) {
        self.lock.lock(); defer { self.lock.unlock() }
        self.closureQueue.add(reducer: reducer)
        self.executionRelay.accept(())
    }

}

/**
 The ClosureQueue is a helper class that manages the withState and setState calls from the viewModel
 by storing each callback in a withState array or setState array.
*/
fileprivate class ClosureQueue<State> { // swiftlint:disable:this private_over_fileprivate

    deinit {
        logDeallocation(of: self, log: CyanicStateStorelLog)
    }

    /**
     The pending withState closures.
    */
    var withStateQueue: [(State) -> Void] = []

    /**
     The pending setState closures.
    */
    var setStateQueue: [(inout State) -> Void] = []

    /**
     The NSRecursiveLock instance used to add closures to their respective queues in a serial manner.
    */
    private let lock: NSRecursiveLock = NSRecursiveLock()

    /**
     Adds a withState closure to the withStateQueue.
     - Parameters:
        - block: The withState closure to be added.
        - state: The current value of the State.
    */
    func add(block: @escaping (_ state: State) -> Void) {
        self.lock.lock(); defer { self.lock.unlock() }
        self.withStateQueue.append(block)
    }

    /**
     Adds a setState closure to the setStateQueue.
     - Parameters:
        - reducer: The setState closure to be added.
        - mutableState: The State to be mutated.
    */
    func add(reducer: @escaping (_ mutableState: inout State) -> Void) {
        self.lock.lock(); defer { self.lock.unlock() }
        self.setStateQueue.append(reducer)
    }

    /**
     Gets the first withState closure if there is one and removes that callback from the withStateQueue.
     - Returns:
        An optional withState closure
    */
    func dequeueFirstWithStateCallback() -> ((State) -> Void)? {
        self.lock.lock(); defer { self.lock.unlock() }
        guard !self.withStateQueue.isEmpty else { return nil }
        return self.withStateQueue.removeFirst()
    }

    /**
     Gets all the set callbacks currently in the setQueue and clears the setStateQueue.
     - Returns:
        All the setState closures currently in the setStateQueue.
    */
    func dequeueAllSetStateClosures() -> [(inout State) -> Void] {
        self.lock.lock(); defer { self.lock.unlock() }
        guard !self.setStateQueue.isEmpty else { return [] }
        let callbacks: [(inout State) -> Void] = self.setStateQueue
        self.setStateQueue = []
        return callbacks
    }

}
