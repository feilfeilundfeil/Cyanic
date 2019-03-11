//
//  CompositeViewModels.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.Observable
import class RxSwift.SerialDispatchQueueScheduler
import struct Dispatch.DispatchQoS

///**
// The base class for custom Composite ViewModels to subclass. CompositeViewModels function like containers for the underlying ViewModels.
// */
//open class BaseCompositeViewModel2<
//    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
//    SecondState: State, SecondViewModel: BaseViewModel<SecondState>
//>: AbstractViewModel<CompositeState2<FirstState, SecondState>> {
//
//    public typealias CompositeState = CompositeState2<FirstState, SecondState>
//
//    public init(first: FirstViewModel, second: SecondViewModel) {
//        self.first = first
//        self.second = second
//        super.init(initialState: CompositeState(firstState: first.currentState, secondState: second.currentState))
//
//        Observable.combineLatest(first.state, second.state)
//            .debounce(0.5, scheduler: self.scheduler)
//            .map { [weak self] (firstState: FirstState, secondState: SecondState) -> CompositeState? in
//                guard let s = self else { return nil }
//                return s.currentState.copy { (mutableState: inout CompositeState) -> Void in
//                    mutableState.firstState = firstState
//                    mutableState.secondState = secondState
//                }
//            }
//            .filter { $0 != nil }
//            .map { $0! } // Filter out nil values
//            //            .debug(String(describing: type(of: self)), trimOutput: false)
//            .bind(to: self.state)
//            .disposed(by: self.disposeBag)
//    }
//
//    public let first: FirstViewModel
//    public let second: SecondViewModel
//    private let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.userInitiated)
//
//}
//
///**
// The base class for custom Composite ViewModels to subclass. CompositeViewModels function like containers for the underlying ViewModels.
// */
//open class BaseCompositeViewModel3<
//    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
//    SecondState: State, SecondViewModel: BaseViewModel<SecondState>,
//    ThirdState: State, ThirdViewModel: BaseViewModel<ThirdState>
//>: AbstractViewModel<CompositeState3<FirstState, SecondState, ThirdState>> {
//
//    public typealias CompositeState = CompositeState3<FirstState, SecondState, ThirdState>
//
//    public init(first: FirstViewModel, second: SecondViewModel, third: ThirdViewModel) {
//        self.first = first
//        self.second = second
//        self.third = third
//        super.init(
//            initialState: CompositeState(
//                firstState: first.currentState,
//                secondState: second.currentState,
//                thirdState: third.currentState
//            )
//        )
//
//        Observable.combineLatest(first.state, second.state, third.state)
//            .debounce(0.15, scheduler: self.scheduler)
//            .map { [weak self] (firstState: FirstState, secondState: SecondState, thirdState: ThirdState) -> CompositeState? in
//                guard let s = self else { return nil }
//                return s.currentState.copy { (mutableState: inout CompositeState) -> Void in
//                    mutableState.firstState = firstState
//                    mutableState.secondState = secondState
//                    mutableState.thirdState = thirdState
//                }
//            }
//            .filter { $0 != nil }
//            .map { $0! } // Filter out nil values
//            .bind(to: self.state)
//            .disposed(by: self.disposeBag)
//    }
//
//    public let first: FirstViewModel
//    public let second: SecondViewModel
//    public let third: ThirdViewModel
//    private let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.userInitiated)
//}
