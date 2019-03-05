//
//  BaseViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxSwift.DisposeBag

open class BaseViewModel<S: State>: ViewModelType {

    /**
     Initializer for the ViewModel.
     When instantiating the ViewModel, it is important to pass an initial State object which should represent the initial State of the current
     view / screen of the app.
     - parameters:
        - initialState: The starting State of the ViewModel.
    */
    public init(initialState: S) {
        self.state = BehaviorRelay<S>(value: initialState)
    }

    internal let state: BehaviorRelay<S>

    /**
     The DisposeBag used to clean up any Rx related subscriptions related to the ViewModel instance.
    */
    public let disposeBag: DisposeBag = DisposeBag()

    /**
     Returns the current State of the ViewModel
    */
    public var currentState: S {
        return self.state.value
    }

    /**
     Used to mutate the current State object of the ViewModel.
     Runs the block given twice to make sure the same State is produced. Otherwise throws a fatalError.
     When run successfully, it emits a notification to BaseComponentsVC that tells it to rebuild its ComponentsArray.
     - parameters:
        - block: The closure that contains mutating logic on the State object.
    */
    public final func setState(block: (inout S) -> Void) {
        let firstState: S = self.currentState.copy(with: block)
        let secondState: S = self.currentState.copy(with: block)

        guard firstState == secondState else {
            fatalError("Executing your block twice produced different states. This must not happen!")
        }

        self.state.accept(firstState)

    }

}

open class BaseExpandableViewModel<S: ExpandableState>: BaseViewModel<S> {

    public final func setExpandableState(id: String, isExpanded: Bool) {
        self.setState { (state: inout S) -> Void in
            state.expandableDict[id] = isExpanded
        }
    }

}
