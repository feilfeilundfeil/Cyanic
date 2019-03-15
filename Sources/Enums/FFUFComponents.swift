//
//  FFUFComponents.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation

/**
 Enum where global functions associated with the FFUFComponents framework are implemented.
*/
public enum FFUFComponents {

    /**
     Synchronously access the state of the viewModel instance.
     - parameters:
        - viewModel: The ViewModel instance whose State will be accessed.
        - block: The logic executed with the current State of the ViewModel.
    */
    public static func withState<ConcreteState: State>(of viewModel: BaseViewModel<ConcreteState>, block: (ConcreteState) -> Void) {
        block(viewModel.currentState)
    }

    /**
     Synchronously access the state of two ViewModel instances.
     - parameters:
        - viewModel1: The first ViewModel instance whose State will be accessed.
        - viewModel2: The second ViewModel instance whose State will be accessed.
        - block: The logic executed with the current States of the ViewModels.
    */
    public static func withState<ConcreteState1: State, ConcreteState2: State>(
        viewModel1: BaseViewModel<ConcreteState1>,
        viewModel2: BaseViewModel<ConcreteState2>,
        block: (ConcreteState1, ConcreteState2) -> Void
    ) {
        block(viewModel1.currentState, viewModel2.currentState)
    }

    /**
     Synchronously access the state of three ViewModel instances.
     - parameters:
        - viewModel1: The first ViewModel instance whose State will be accessed.
        - viewModel2: The second ViewModel instance whose State will be accessed.
        - viewModel3: The third ViewModel instance whose State will be accessed.
        - block: The logic executed with the current States of the ViewModels.
    */
    public static func withState<ConcreteState1: State, ConcreteState2: State, ConcreteState3: State>(
        viewModel1: BaseViewModel<ConcreteState1>,
        viewModel2: BaseViewModel<ConcreteState2>,
        viewModel3: BaseViewModel<ConcreteState3>,
        block: (ConcreteState1, ConcreteState2, ConcreteState3) -> Void
    ) {
        block(viewModel1.currentState, viewModel2.currentState, viewModel3.currentState)
    }

}
