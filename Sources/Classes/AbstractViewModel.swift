//
//  ViewModelType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/4/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxSwift.DisposeBag

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
    public init(initialState: StateType) {
        self.state = BehaviorRelay<StateType>(value: initialState)
    }

    deinit {
        print("\(self) was deallocated")
    }

    /**
     The BehaviorRelay that emits values of StateType. It is not meant to be accessed directly, please use
     setState(block:) to mutate StateType.
    */
    internal var state: BehaviorRelay<StateType>

    /**
     The DisposeBag used to clean up any Rx related subscriptions related to the ViewModel instance.
    */
    public let disposeBag: DisposeBag = DisposeBag()

}

public extension AbstractViewModel {

    /**
     Accessor for the current State of the AbstractViewModel.
    */
    var currentState: StateType {
        return self.state.value
    }

}

internal protocol ViewModelType {}
