//
//  AnyViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/23/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.Observable

public final class AnyViewModel {

    public init<S: State, V: BaseViewModel<S>>(_ viewModel: V) {
        self.viewModel = viewModel
        self.state = viewModel.state.map { $0 as Any }
    }

    public let viewModel: Any
    public let state: Observable<Any>

}
