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
import class RxSwift.SerialDispatchQueueScheduler
import struct Dispatch.DispatchQoS

/**
 The base class for custom ViewModels to subclass. It contains the basic functionality necessary for reading / mutating State. A ViewModel handles
 the business logic necessary to render the screen it is responsible for. ViewModels own state and its state can be observed.
*/
open class BaseViewModel<StateType: State>: ViewModelType<StateType> {

    /**
     Used to mutate the current State object of the ViewModelType.
     Runs the block given twice to make sure the same State is produced. Otherwise throws a fatalError.
     When run successfully, it emits a value to BaseComponentsVC that tells it to rebuild its ComponentsArray.
     - parameters:
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

/**
 The base class for custom Composite ViewModels to subclass. CompositeViewModels function like containers for the underlying ViewModels.
 This class should not mutate its child ViewModels
*/
open class BaseCompositeTwoViewModelType<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>
>: ViewModelType<CompositeTwoStateType<FirstState, SecondState>> {

    public typealias CompositeState = CompositeTwoStateType<FirstState, SecondState>

    public init(first: FirstViewModel, second: SecondViewModel) {
        self.first = first
        self.second = second
        super.init(initialState: CompositeState(firstState: first.currentState, secondState: second.currentState))

        Observable.combineLatest(first.state, second.state)
            .debounce(0.15, scheduler: self.scheduler)
            .map { [weak self] (firstState: FirstState, secondState: SecondState) -> CompositeState? in
                guard let s = self else { return nil }
                return s.currentState.copy { (mutableState: inout CompositeState) -> Void in
                    mutableState.firstState = firstState
                    mutableState.secondState = secondState
                }
            }
            .filter { $0 != nil }
            .map { $0! } // Filter out nil values swiftlint:disable:this force_unwrapping
//            .debug(String(describing: type(of: self)), trimOutput: false)
            .bind(to: self.state)
            .disposed(by: self.disposeBag)
    }

    public let first: FirstViewModel
    public let second: SecondViewModel
    private let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.userInitiated)

}

open class BaseThreeCompositeViewModelType<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>,
    ThirdState: State, ThirdViewModel: BaseViewModel<ThirdState>
>: ViewModelType<CompositeThreeStateType<FirstState, SecondState, ThirdState>> {

    public typealias CompositeState = CompositeThreeStateType<FirstState, SecondState, ThirdState>

    public init(first: FirstViewModel, second: SecondViewModel, third: ThirdViewModel) {
        self.first = first
        self.second = second
        self.third = third
        super.init(
            initialState: CompositeState(
                firstState: first.currentState,
                secondState: second.currentState,
                thirdState: third.currentState
            )
        )

        Observable.combineLatest(first.state, second.state, third.state)
            .debounce(0.15, scheduler: self.scheduler)
            .map { [weak self] (firstState: FirstState, secondState: SecondState, thirdState: ThirdState) -> CompositeState? in
                guard let s = self else { return nil }
                return s.currentState.copy { (mutableState: inout CompositeState) -> Void in
                    mutableState.firstState = firstState
                    mutableState.secondState = secondState
                    mutableState.thirdState = thirdState
                }
            }
            .filter { $0 != nil }
            .map { $0! } // Filter out nil values swiftlint:disable:this force_unwrapping
            .bind(to: self.state)
            .disposed(by: self.disposeBag)
    }

    public let first: FirstViewModel
    public let second: SecondViewModel
    public let third: ThirdViewModel
    private let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.userInitiated)
}
