//
//  BaseViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 The base class for custom ViewModels to subclass. It contains the basic functionality necessary for reading / mutating State. A ViewModel handles
 the business logic necessary to render the screen it is responsible for. ViewModels own state and its state can be observed.
*/
open class BaseViewModel<StateType: State>: AbstractViewModel<StateType> {

    /**
     Used to mutate the current State object of the ViewModelType.
     Runs the block given twice to make sure the same State is produced. Otherwise throws a fatalError.
     When run successfully, it emits a value to BaseComponentsVC that tells it to rebuild its ComponentsArray.
     - Parameters:
     - block: The closure that contains mutating logic on the State object.
     */
    public func setState(block: (inout StateType) -> Void) {
        let firstState: StateType = self.currentState.copy(with: block)
        let secondState: StateType = self.currentState.copy(with: block)

        guard firstState == secondState else {
            fatalError("Executing your block twice produced different states. This must not happen!")
        }

        self.state.accept(firstState)

    }

}

public extension BaseViewModel where StateType: ExpandableState {

    /**
     Calls the setState method where it updates (mutates) the ExpandableState's expandableDict with the given id as a key
     - Parameters:
     - id: The unique identifier of the ExpandableComponent.
     - isExpanded: The new state of the ExpandableComponent.
    */
    func setExpandableState(id: String, isExpanded: Bool) {
        self.setState { (state: inout StateType) -> Void in
            state.expandableDict[id] = isExpanded
        }
    }
}
