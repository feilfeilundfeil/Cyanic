//
//  BaseViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import RxSwift

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
    public final func setState(block: (inout StateType) -> Void) {
        let firstState: StateType = self.currentState.copy(with: block)
        let secondState: StateType = self.currentState.copy(with: block)

        guard firstState == secondState else {
            fatalError("Executing your block twice produced different states. This must not happen!")
        }

        self.state.accept(firstState)

    }

    public final func asyncSubscribe<T>(
        keyPath: KeyPath<StateType, Async<T>>,
        onSuccess: @escaping (T) -> Void = { _ in },
        onFail: @escaping (Error) -> Void = { _ in }
    ) {
        self.state
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { (async: Async<T>) -> Void in
                    switch async {
                        case .success(let value):
                            onSuccess(value)
                        case .failure(let error):
                            onFail(error)
                        default:
                            break
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }

    public final func selectSubscribe<T: Equatable>(keyPath: KeyPath<StateType, T>, onNewValue: @escaping (T) -> Void) {
        self.state
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { (value: T) -> Void in
                    onNewValue(value)
                }
            )
            .disposed(by: self.disposeBag)
    }

    public final func selectSubscribe<T: Equatable, U: Equatable>(
        keyPath1: KeyPath<StateType, T>,
        keyPath2: KeyPath<StateType, U>,
        onNewValue: @escaping ((T, U)) -> Void) {
        self.state
            .map { SubscribeSelect2<T, U>(t: $0[keyPath: keyPath1], u: $0[keyPath: keyPath2]) }
            .distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { (value: SubscribeSelect2<T, U>) -> Void in
                    onNewValue((value.t, value.u))
                }
            )
            .disposed(by: self.disposeBag)
    }

    public final func selectSubscribe<T: Equatable, U: Equatable, V: Equatable>(
        keyPath1: KeyPath<StateType, T>,
        keyPath2: KeyPath<StateType, U>,
        keyPath3: KeyPath<StateType, V>,
        onNewValue: @escaping ((T, U, V)) -> Void) { // swiftlint:disable:this large_tuple
        self.state
            .map { SubscribeSelect3<T, U, V>(t: $0[keyPath: keyPath1], u: $0[keyPath: keyPath2], v: $0[keyPath: keyPath3]) }
            .distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { (value: SubscribeSelect3<T, U, V>) -> Void in
                    onNewValue((value.t, value.u, value.v))
                }
            )
            .disposed(by: self.disposeBag)
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

internal struct SubscribeSelect2<T: Equatable, U: Equatable>: Equatable {

    internal let t: T
    internal let u: U

}

internal struct SubscribeSelect3<T: Equatable, U: Equatable, V: Equatable>: Equatable {

    internal let t: T
    internal let u: U
    internal let v: V

}
