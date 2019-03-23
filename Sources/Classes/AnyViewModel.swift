//
//  AnyViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/23/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.Observable

/**
 Type Erased wrapper for BaseViewModels
*/
public final class AnyViewModel {

    public init<S: State, V: BaseViewModel<S>>(_ viewModel: V) {
        self.viewModel = viewModel
        self.state = viewModel.state.map { $0 as Any }
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
