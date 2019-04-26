//
//  StateStore.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

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
        self.executionRelay
            .observeOn(self.scheduler)
            .subscribeOn(self.scheduler)
            .debug("Execution Relay", trimOutput: false)
            .bind(
                onNext: { [weak self] () -> Void in
                    self?.resolveClosureQueue()
                }
            )
            .disposed(by: self.disposeBag)
    }

    /**
     The scheduler where all pending closures related to State are resolved.
    */
    private let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(
        qos: DispatchQoS.default,
        internalSerialQueueName: "\(UUID().uuidString)"
    )

    /**
     The BehaviorRelay that encapsulates State.
    */
    internal let stateRelay: BehaviorRelay<ConcreteState>

    /**
     The PublishRelay that is responsible for resolving the withState and setState closures on State.
    */
    private let executionRelay: PublishRelay<Void> = PublishRelay<Void>()

    /**
     The ClosureQueue instance that manages the setState and withState queues.
    */
    private var closureQueue: ClosureQueue<ConcreteState> = ClosureQueue<ConcreteState>()

    /**
     The DisposeBag for Rx related subcriptions
    */
    private let disposeBag: DisposeBag = DisposeBag()

    /**
     Resolves all pending setState closures then resolves all pending withState closures.
    */
    private func resolveClosureQueue() {
        self.resolveSetStateQueue()
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
        self.closureQueue.add(block: block)
        self.executionRelay.accept(())
    }

    /**
     Adds the reducer to the setStateQueue and makes the executionRelay emit a new value.
     - Parameters:
        - reducer: The closure to set/mutate the StateType.
    */
    internal func setState(with reducer: @escaping (inout ConcreteState) -> Void) {
        self.closureQueue.add(reducer: reducer)
        self.executionRelay.accept(())
    }

}

/**
 The ClosureQueue is a helper struct that manages the withState and setState calls from the viewModel
 by storing each callback in a withState array or setState array.
*/
fileprivate struct ClosureQueue<State> { // swiftlint:disable:this private_over_fileprivate

    /**
     The pending withState closures.
    */
    var withStateQueue: [(State) -> Void] = []

    /**
     The pending setState closures.
    */
    var setStateQueue: [(inout State) -> Void] = []

    /**
     Adds a withState closure to the withStateQueue.
     - Parameters:
        - block: The withState closure to be added.
        - state: The current value of the State.
    */
    mutating func add(block: @escaping (_ state: State) -> Void) {
        self.withStateQueue.append(block)
    }

    /**
     Adds a setState closure to the setStateQueue.
     - Parameters:
        - reducer: The setState closure to be added.
        - mutableState: The State to be mutated.
    */
    mutating func add(reducer: @escaping (_ mutableState: inout State) -> Void) {
        self.setStateQueue.append(reducer)
    }

    /**
     Gets the first withState closure if there is one and removes that callback from the withStateQueue.
     - Returns:
        An optional withState closure
    */
    mutating func dequeueFirstWithStateCallback() -> ((State) -> Void)? {
        guard !self.withStateQueue.isEmpty else { return nil }
        return self.withStateQueue.removeFirst()
    }

    /**
     Gets all the set callbacks currently in the setQueue and clears the setStateQueue.
     - Returns:
        All the setState closures currently in the setStateQueue.
    */
    mutating func dequeueAllSetStateClosures() -> [(inout State) -> Void] {
        guard !self.setStateQueue.isEmpty else { return [] }
        let callbacks: [(inout State) -> Void] = self.setStateQueue
        self.setStateQueue = []
        return callbacks
    }

}
