//
//  BaseViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxSwift.DisposeBag
import class RxSwift.Observable
import struct RxSwift.AnyObserver

/**
 The base class for custom ViewModels to subclass. It contains the basic functionality necessary for reading / mutating State. A ViewModel handles
 the business logic necessary to render the screen it is responsible for. ViewModels own state and its state can be observed.
*/
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

    public let state: BehaviorRelay<S>

    public let disposeBag: DisposeBag = DisposeBag()

}

public extension BaseViewModel where S: ExpandableState {

    /**
     Calls the setState method where it updates (mutates) the ExpandableState's expandableDict with the given id as a key
     - parameters:
        - id: The unique identifier of the ExpandableComponent.
        - isExpanded: The new state of the ExpandableComponent.
    */
    final func setExpandableState(id: String, isExpanded: Bool) {
        self.setState { (state: inout S) -> Void in
            state.expandableDict[id] = isExpanded
        }
    }
}

public class BaseCompositeTwoViewModelType<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>>: ViewModelType {

    public init(first: FirstViewModel, second: SecondViewModel) {
        self.first = first
        self.second = second
        self.state = BehaviorRelay<CompositeTwoState<FirstState, SecondState>>(
            value: CompositeTwoState(firstState: first.currentState, secondState: second.currentState)
        )

        Observable.combineLatest(first.state, second.state)
            .map { CompositeTwoState<FirstState, SecondState>(firstState: $0, secondState: $1) }
            .bind(to: self.state)
            .disposed(by: self.disposeBag)
    }

    public let first: FirstViewModel
    public let second: SecondViewModel
    public let state: BehaviorRelay<CompositeTwoState<FirstState, SecondState>>
    public let disposeBag: DisposeBag = DisposeBag()
}

public class BaseThreeCompositeViewModelType<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>,
    ThirdState: State, ThirdViewModel: BaseViewModel<ThirdState>>: ViewModelType {

    public init(first: FirstViewModel, second: SecondViewModel, third: ThirdViewModel) {
        self.first = first
        self.second = second
        self.third = third
        self.state = BehaviorRelay<CompositeThreeState<FirstState, SecondState, ThirdState>>(
            value: CompositeThreeState(
                firstState: first.currentState,
                secondState: second.currentState,
                thirdState: third.currentState
            )
        )

        Observable.combineLatest(first.state, second.state, third.state)
            .map { CompositeThreeState<FirstState, SecondState, ThirdState>(firstState: $0, secondState: $1, thirdState: $2) }
            .bind(to: self.state)
            .disposed(by: self.disposeBag)
    }

    public let first: FirstViewModel
    public let second: SecondViewModel
    public let third: ThirdViewModel
    public let state: BehaviorRelay<CompositeThreeState<FirstState, SecondState, ThirdState>>
    public let disposeBag: DisposeBag = DisposeBag()
}
