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

/**
 The base class for custom Composite ViewModels to subclass. It contains the basic functionality necessary for reading / mutating State and
 it emits a new State value whenever the state of one of its ViewModels changes. It is important to not directly 
*/
open class BaseCompositeTwoViewModelType<
    FirstState, FirstViewModel: BaseViewModel<FirstState>,
    SecondState, SecondViewModel: BaseViewModel<SecondState>,
    CompositeState: CompositeTwoStateType
>: ViewModelType where
    CompositeState.FirstState == FirstState,
    CompositeState.SecondState == SecondState {

    public init(first: FirstViewModel, second: SecondViewModel, initialState: CompositeState) {
        self.first = first
        self.second = second
        self.state = BehaviorRelay<CompositeState>(value: initialState)

        Observable.combineLatest(first.state, second.state)
            .map { (firstState: FirstState, secondState: SecondState) -> CompositeState in
                return self.currentState.copy { (mutableState: inout CompositeState) -> Void in
                    mutableState.firstState = firstState
                    mutableState.secondState = secondState
                }
            }
//            .debug(String(describing: type(of: self)), trimOutput: false)
            .bind(to: self.state)
            .disposed(by: self.disposeBag)
    }

    public let first: FirstViewModel
    public let second: SecondViewModel
    public let state: BehaviorRelay<CompositeState>
    public let disposeBag: DisposeBag = DisposeBag()

}

//open class BaseThreeCompositeViewModelType<
//    FirstState, FirstViewModel: BaseViewModel<FirstState>,
//    SecondState, SecondViewModel: BaseViewModel<SecondState>,
//    ThirdState, ThirdViewModel: BaseViewModel<ThirdState>,
//    CompositeState: CompositeThreeStateType
//>: ViewModelType where
//    CompositeState.FirstState == FirstState,
//    CompositeState.SecondState == SecondState,
//    CompositeState.ThirdState == ThirdState {
//
//    public init(first: FirstViewModel, second: SecondViewModel, third: ThirdViewModel, initialState: CompositeState) {
//        self.first = first
//        self.second = second
//        self.third = third
//        self.state = BehaviorRelay<CompositeState>(value: initialState)
//
//        Observable.combineLatest(first.state, second.state, third.state)
//            .map { (firstState: FirstState, secondState: SecondState, thirdState: ThirdState) -> CompositeState in
//                return self.currentState.copy { (mutableState: inout CompositeState) -> Void in
//                    mutableState.firstState = firstState
//                    mutableState.secondState = secondState
//                    mutableState.thirdState = thirdState
//                }
//            }
//            .bind(to: self.state)
//            .disposed(by: self.disposeBag)
//    }
//
//    public let first: FirstViewModel
//    public let second: SecondViewModel
//    public let third: ThirdViewModel
//    public let state: BehaviorRelay<CompositeState>
//    public let disposeBag: DisposeBag = DisposeBag()
//}
