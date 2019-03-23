//
//  FFUFComponents.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 Synchronously access the state of the viewModel instance.
 - parameters:
    - viewModel: The ViewModel instance whose State will be accessed.
    - block: The logic executed with the current State of the ViewModel.
*/
public func withState<ConcreteState: State>(of viewModel: BaseViewModel<ConcreteState>, block: (ConcreteState) -> Void) {
    block(viewModel.currentState)
}

/**
 Synchronously access the state of two ViewModel instances.
 - parameters:
    - viewModel1: The first ViewModel instance whose State will be accessed.
    - viewModel2: The second ViewModel instance whose State will be accessed.
    - block: The logic executed with the current States of the ViewModels.
*/
public func withState<ConcreteState1: State, ConcreteState2: State>(
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
public func withState<ConcreteState1: State, ConcreteState2: State, ConcreteState3: State>(
    viewModel1: BaseViewModel<ConcreteState1>,
    viewModel2: BaseViewModel<ConcreteState2>,
    viewModel3: BaseViewModel<ConcreteState3>,
    block: (ConcreteState1, ConcreteState2, ConcreteState3) -> Void
) {
    block(viewModel1.currentState, viewModel2.currentState, viewModel3.currentState)
}

/**
 Synchronously access the state of four ViewModel instances.
 - parameters:
    - viewModel1: The first ViewModel instance whose State will be accessed.
    - viewModel2: The second ViewModel instance whose State will be accessed.
    - viewModel3: The third ViewModel instance whose State will be accessed.
    - viewModel4: The fourth ViewModel instance whose State will be accessed.
    - block: The logic executed with the current States of the ViewModels.
 */
public func withState<
    ConcreteState1: State,
    ConcreteState2: State,
    ConcreteState3: State,
    ConcreteState4: State
>(
    viewModel1: BaseViewModel<ConcreteState1>,
    viewModel2: BaseViewModel<ConcreteState2>,
    viewModel3: BaseViewModel<ConcreteState3>,
    viewModel4: BaseViewModel<ConcreteState4>,
    block: (ConcreteState1, ConcreteState2, ConcreteState3, ConcreteState4) -> Void
) {
    block(viewModel1.currentState, viewModel2.currentState, viewModel3.currentState, viewModel4.currentState)
}

/**
 Synchronously access the state of five ViewModel instances.
 - parameters:
    - viewModel1: The first ViewModel instance whose State will be accessed.
    - viewModel2: The second ViewModel instance whose State will be accessed.
    - viewModel3: The third ViewModel instance whose State will be accessed.
    - viewModel4: The fourth ViewModel instance whose State will be accessed.
    - viewModel5: The fifth ViewModel instance whose State will be accessed.
    - block: The logic executed with the current States of the ViewModels.
 */
public func withState< // swiftlint:disable:this function_parameter_count
    ConcreteState1: State,
    ConcreteState2: State,
    ConcreteState3: State,
    ConcreteState4: State,
    ConcreteState5: State
>(
    viewModel1: BaseViewModel<ConcreteState1>,
    viewModel2: BaseViewModel<ConcreteState2>,
    viewModel3: BaseViewModel<ConcreteState3>,
    viewModel4: BaseViewModel<ConcreteState4>,
    viewModel5: BaseViewModel<ConcreteState5>,
    block: (ConcreteState1, ConcreteState2, ConcreteState3, ConcreteState4, ConcreteState5) -> Void
) {
    block(
        viewModel1.currentState,
        viewModel2.currentState,
        viewModel3.currentState,
        viewModel4.currentState,
        viewModel5.currentState
    )
}
