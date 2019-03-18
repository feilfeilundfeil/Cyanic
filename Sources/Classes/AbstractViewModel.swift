//
//  ViewModelType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/4/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxSwift.DisposeBag
import class RxSwift.Observable

/**
 ViewModelType is a protocol adopted by the BaseViewModel classes. It provides the essential functionality for ViewModel and State interaction.
*/
open class AbstractViewModel<StateType: State>: ViewModelType {

    /**
     Initializer for the ViewModel.
     When instantiating the ViewModel, it is important to pass an initial State object which should represent the initial State of the current
     view / screen of the app.
     - Parameters:
        - initialState: The starting State of the ViewModel.
    */
    public init(initialState: StateType, isDebugMode: Bool = false) {
        self.stateStore = StateStore<StateType>(initialState: initialState)
        self.isDebugMode = isDebugMode
    }

    deinit {
        print("\(self) was deallocated")
    }

    /**
     The InternalStateStore that manages the State of the ViewModel
    */
    internal let stateStore: StateStore<StateType>

    /**
     Indicates whether debugging functionality will be used.
    */
    internal let isDebugMode: Bool

    /**
     The DisposeBag used to clean up any Rx related subscriptions related to the ViewModel instance.
    */
    public let disposeBag: DisposeBag = DisposeBag()

}

internal extension AbstractViewModel {

    internal var state: Observable<StateType> {
        return self.stateStore.state
    }

    /**
     Accessor for the current State of the AbstractViewModel.
    */
    internal var currentState: StateType {
        return self.stateStore.currentState
    }

}

internal protocol ViewModelType {}
