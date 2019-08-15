//
//  Cyanic
//  Created by Julio Miguel Alorro on 15.03.19.
//  Licensed under the MIT license. See LICENSE file
//

/**
 Synchronously access the state of the viewModel instance.
 - parameters:
    - viewModel: The ViewModel instance whose State will be accessed.
    - block: The logic executed with the current State of the ViewModel.
 - returns:
    Returns the result of the block.
*/
public func withState<ConcreteState: State, R>(of viewModel: ViewModel<ConcreteState>, block: (ConcreteState) -> R) -> R {
    return block(viewModel.currentState)
}

/**
 Synchronously access the state of two ViewModel instances.
 - parameters:
    - viewModel1: The first ViewModel instance whose State will be accessed.
    - viewModel2: The second ViewModel instance whose State will be accessed.
    - block: The logic executed with the current States of the ViewModels.
 - returns:
    Returns the result of the block.
*/
public func withState<ConcreteState1: State, ConcreteState2: State, R>(
    viewModel1: ViewModel<ConcreteState1>,
    viewModel2: ViewModel<ConcreteState2>,
    block: (ConcreteState1, ConcreteState2) -> R
) -> R {
    return block(viewModel1.currentState, viewModel2.currentState)
}

/**
 Synchronously access the state of three ViewModel instances.
 - parameters:
    - viewModel1: The first ViewModel instance whose State will be accessed.
    - viewModel2: The second ViewModel instance whose State will be accessed.
    - viewModel3: The third ViewModel instance whose State will be accessed.
    - block: The logic executed with the current States of the ViewModels.
 - returns:
    Returns the result of the block.
*/
public func withState<ConcreteState1: State, ConcreteState2: State, ConcreteState3: State, R>(
    viewModel1: ViewModel<ConcreteState1>,
    viewModel2: ViewModel<ConcreteState2>,
    viewModel3: ViewModel<ConcreteState3>,
    block: (ConcreteState1, ConcreteState2, ConcreteState3) -> R
) -> R {
    return block(viewModel1.currentState, viewModel2.currentState, viewModel3.currentState)
}

/**
 Synchronously access the state of four ViewModel instances.
 - parameters:
    - viewModel1: The first ViewModel instance whose State will be accessed.
    - viewModel2: The second ViewModel instance whose State will be accessed.
    - viewModel3: The third ViewModel instance whose State will be accessed.
    - viewModel4: The fourth ViewModel instance whose State will be accessed.
    - block: The logic executed with the current States of the ViewModels.
 - returns:
    Returns the result of the block.
*/
public func withState<
    ConcreteState1: State,
    ConcreteState2: State,
    ConcreteState3: State,
    ConcreteState4: State,
    R
>(
    viewModel1: ViewModel<ConcreteState1>,
    viewModel2: ViewModel<ConcreteState2>,
    viewModel3: ViewModel<ConcreteState3>,
    viewModel4: ViewModel<ConcreteState4>,
    block: (ConcreteState1, ConcreteState2, ConcreteState3, ConcreteState4) -> R
) -> R {
    return block(viewModel1.currentState, viewModel2.currentState, viewModel3.currentState, viewModel4.currentState)
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
 - returns:
    Returns the result of the block.
*/
public func withState< // swiftlint:disable:this function_parameter_count
    ConcreteState1: State,
    ConcreteState2: State,
    ConcreteState3: State,
    ConcreteState4: State,
    ConcreteState5: State,
    R
>(
    viewModel1: ViewModel<ConcreteState1>,
    viewModel2: ViewModel<ConcreteState2>,
    viewModel3: ViewModel<ConcreteState3>,
    viewModel4: ViewModel<ConcreteState4>,
    viewModel5: ViewModel<ConcreteState5>,
    block: (ConcreteState1, ConcreteState2, ConcreteState3, ConcreteState4, ConcreteState5) -> R
) -> R {
    return block(
        viewModel1.currentState,
        viewModel2.currentState,
        viewModel3.currentState,
        viewModel4.currentState,
        viewModel5.currentState
    )
}
