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
public protocol ViewModelType {

    associatedtype StateType: State

    /**
     The BehaviorRelay that emits values of StateType. It is not meant to be accessed directly, please use
     setState(block:) to mutate StateType.
    */
    var state: BehaviorRelay<StateType> { get }

    /**
     The DisposeBag used to clean up any Rx related subscriptions related to the ViewModel instance.
    */
    var disposeBag: DisposeBag { get }

}

public extension ViewModelType {

    /**
     Accessor for the current State of the ViewModelType.
    */
    var currentState: StateType {
        return self.state.value
    }

    /**
     Used to mutate the current State object of the ViewModelType.
     Runs the block given twice to make sure the same State is produced. Otherwise throws a fatalError.
     When run successfully, it emits a value to BaseComponentsVC that tells it to rebuild its ComponentsArray.
     - parameters:
     - block: The closure that contains mutating logic on the State object.
     */
    func setState(block: (inout StateType) -> Void) {
        let firstState: StateType = self.currentState.copy(with: block)
        let secondState: StateType = self.currentState.copy(with: block)

        guard firstState == secondState else {
            fatalError("Executing your block twice produced different states. This must not happen!")
        }

        self.state.accept(firstState)

    }

}

public extension ViewModelType where StateType: ExpandableState {

    /**
     Calls the setState method where it updates (mutates) the ExpandableState's expandableDict with the given id as a key
     - parameters:
     - id: The unique identifier of the ExpandableComponent.
     - isExpanded: The new state of the ExpandableComponent.
     */
    func setExpandableState(id: String, isExpanded: Bool) {
        self.setState { (state: inout StateType) -> Void in
            state.expandableDict[id] = isExpanded
        }
    }
}
