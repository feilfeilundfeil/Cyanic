//
//  AnyViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/23/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.Observable

/**
 Type Erased wrapper for a BaseViewModel instance.
*/
public final class AnyViewModel {

    /**
     Initializer.
     Keeps the underlying viewModel instance in memory as an Any type.
     - Parameters:
        - viewModel: The BaseViewModel instance to be type erased.
    */
    public init<ConcreteState: State, ConcreteViewModel: BaseViewModel<ConcreteState>>(_ viewModel: ConcreteViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.state.map({ (state: ConcreteState) -> Any in state as Any })
    }

    /**
     The underlying BaseViewModel as an Any type
    */
    public let viewModel: Any

    /**
     The BaseViewModel's State as an Observable<Any>
    */
    public let state: Observable<Any>

}
