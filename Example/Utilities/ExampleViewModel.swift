//
//  ExampleViewModel.swift
//  Example
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

public class ExampleViewModel<ConcreteState: State>: ViewModel<ConcreteState> {

    public init(initialState: ConcreteState) {
        super.init(initialState: initialState, isDebugMode: true)
    }

}
