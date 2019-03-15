//
//  StateStore.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal class InternalStateStore<ConcreteState: State> {

    /**
     Initializer.
     - parameters:
        - initialState: The initial value of StateType.
    */
    internal init(initialState: ConcreteState) {
        self.relay = BehaviorRelay<ConcreteState>(value: initialState)
        self.executionQueue
            .observeOn(self.scheduler)
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
    private let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.userInitiated)

    /**
     The BehaviorRelay that encapsulates State.
    */
    internal let relay: BehaviorRelay<ConcreteState>

    /**
     The BehaviorRelay that is responsible for resolving the get and set closures on State.
    */
    private let executionQueue: BehaviorRelay<Void> = BehaviorRelay<Void>(value: ())

    /**
     The get and set closures on State.
    */
    private var closureQueue: ClosureQueue<ConcreteState> = ClosureQueue<ConcreteState>()

    /**
     The DisposeBag for Rx related subcriptions
    */
    private let disposeBag: DisposeBag = DisposeBag()

    /**
     Resolves all pending set calls then resolves all pending get calls.
    */
    private func resolveClosureQueue() {
        self.resolveSetQueue()
        guard let getBlock = self.closureQueue.fetchGetCallback() else { return }
        getBlock(self.currentState  )
        self.resolveClosureQueue()
    }

    /**
     Resolves all set callbacks and emits a new State value.
    */
    private func resolveSetQueue() {
        let reducers: [(inout ConcreteState) -> Void] = self.closureQueue.dequeueAllSetCallBacks()
        guard !reducers.isEmpty else { return }
        let newState: ConcreteState = reducers
            .reduce(into: self.currentState) { (state: inout ConcreteState, block: (inout ConcreteState) -> Void) -> Void in
                block(&state)
            }
        guard newState != self.currentState else { return }
        self.relay.accept(newState)
    }

    // MARK: StateStore Protocol
    /**
     The current value of the State.
    */
    internal var currentState: ConcreteState { return self.relay.value }

    /**
     The Observable encapsulating the StateType.
    */
    internal var state: Observable<ConcreteState> { return self.relay.asObservable() }

    /**
     Adds the block to the queue then resolves all pending StateType related closures.
     - parameters:
     - block: The closure to get the latest value of the StateType.
    */
    internal func getState(block: @escaping (ConcreteState) -> Void) {
        self.closureQueue.add(get: block)
        self.executionQueue.accept(())
    }

    /**
     Adds the block to the queue then resolves all pending StateType related closures.
     - parameters:
     - block: The closure to set/mutate the StateType.
    */
    internal func setState(reducer: @escaping (inout ConcreteState) -> Void) {
        self.closureQueue.add(set: reducer)
        self.executionQueue.accept(())
    }

}

fileprivate struct ClosureQueue<T> { // swiftlint:disable:this private_over_fileprivate

    /**
     The pending getState callbacks.
    */
    var getQueue: [(T) -> Void] = []

    /**
     The pending setState callbacks.
    */
    var setQueue: [(inout T) -> Void] = []

    /**
     Adds a get callback to the getQueue.
     - Parameters:
        - block: The callback to be added
        - state: The current value of the StateType.
    */
    mutating func add(get block: @escaping (_ state: T) -> Void) {
        self.getQueue.append(block)
    }

    /**
     Adds a set callback to the setQueue.
     - Parameters:
        - block: The callback to be added
    */
    mutating func add(set block: @escaping (inout T) -> Void) {
        self.setQueue.append(block)
    }

    /**
     Gets the first get callback if there is one and removes that callback from the getQueue.
     - Returns:
        an optional get callback
    */
    mutating func fetchGetCallback() -> ((T) -> Void)? {
        guard !self.getQueue.isEmpty else { return nil }
        return self.getQueue.removeFirst()
    }

    /**
     Gets all the set callbacks currently in the setQueue and clears the setQueue
     - Returns:
        all the set callbacks currently in the setQueue
    */
    mutating func dequeueAllSetCallBacks() -> [(inout T) -> Void] {
        guard !self.setQueue.isEmpty else { return [] }
        let callbacks: [(inout T) -> Void] = self.setQueue
        self.setQueue = []
        return callbacks
    }

}
