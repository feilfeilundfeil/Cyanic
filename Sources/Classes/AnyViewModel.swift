//
//  AnyViewModel.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/23/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import RxSwift

/**
 Type-erased wrapper for a ViewModel instance.
*/
public final class AnyViewModel {

    /**
     Initializer.
     Keeps the underlying viewModel instance in memory as an Any type.
     - Parameters:
        - viewModel: The BaseViewModel instance to be type erased.
    */
    public init<ConcreteState: State, ConcreteViewModel: ViewModel<ConcreteState>>(_ viewModel: ConcreteViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.state.map({ (state: ConcreteState) -> Any in state as Any })
        self.isDebugMode = viewModel.isDebugMode
    }

    /**
     The underlying ViewModel as an Any type
    */
    public let viewModel: Any

    /**
     The ViewModel's State as an Observable<Any>
    */
    public let state: Observable<Any>

    /**
     The debug mode of the underlying ViewModel instance
    */
    public let isDebugMode: Bool

}
