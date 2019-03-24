//
//  BaseViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.MainScheduler
import protocol RxSwift.ObservableType
import protocol RxSwift.Disposable

/**
 The base class for custom ViewModels to subclass.
 It contains the basic functionality necessary for reading / mutating State. A ViewModel handles
 the business logic necessary to render the screen it is responsible for. ViewModels own state and
 its state can be observed.
*/
open class BaseViewModel<StateType: State>: AbstractViewModel<StateType> {

    public var asAnyViewModel: AnyViewModel {
        return AnyViewModel(self)
    }

    /**
     Accesses the current State after all pending setState methods are resolved.
     - Parameters:
        - block:        The closure executed when fetching the current State.
        - currentState: The current value of the State instance when this is called.
    */
    public final func withState(block: @escaping (_ currentState: StateType) -> Void) {
        self.stateStore.getState(with: block)
    }

    /**
     Used to mutate the current State object of the ViewModelType.
     Runs the block given twice to make sure the same State is produced. Otherwise throws a fatalError.
     When run successfully, it emits a value to BaseComponentsVC that tells it to rebuild its ComponentsController.
     - Parameters:
        - block:        The closure that contains mutating logic on the State object.
        - mutableState: The State to be mutated by the reducer.
     */
    public final func setState(with reducer: @escaping (_ mutableState: inout StateType) -> Void) {
        switch self.isDebugMode {
            case true:
                self.stateStore.setState { (mutableState: inout StateType) -> Void in
                    let firstState: StateType = mutableState.copy(with: reducer)
                    let secondState: StateType = mutableState.copy(with: reducer)

                    guard firstState == secondState else {
                        fatalError("Executing your block twice produced different states. This must not happen!")
                    }

                    reducer(&mutableState)

                }
            case false:
                self.stateStore.setState(with: reducer)
        }
    }

    /**
     Subscribes to changes in an Async property of StateType. The closures are executed on the main thread asynchronously.
     - Parameters:
        - keyPath:   KeyPath of the Async property to be observed.
        - onSuccess: Executed when the Async property is changed to Async.success, if it was not Async.success before.
                     It will NOT execute when it is already Async.success at the time of subscription
        - newValue:  The underlying value of the property when it is changed to Async.success.
        - onFailure: Executed when the Async property is changed to Async.failure, if it was not Async.failure before.
                     It will NOT execute when it is already Async.failure at the time of subscription
        - error:     The underlying error value of the property when it is changed to Async.failure.
    */
    public final func asyncSubscribe<T>(
        to keyPath: KeyPath<StateType, Async<T>>,
        onSuccess: @escaping (_ newValue: T) -> Void = { _ in },
        onFailure: @escaping (_ error: Error) -> Void = { _ in }
    ) {

        // BehaviorRelay emits its current/initial value to new subscribers therefore use that as
        // starting value to compare against in the distinctUntilChanged operator
        // and skip it so it doesn't trigger onNewValue when subscribing.
        self.stateStore.state
            .map { (state: StateType) -> Async<T> in
                return state[keyPath: keyPath]
            }
            .distinctUntilChanged()
            .skip(1)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { (async: Async<T>) -> Void in
                    switch async {
                        case .success(let value):
                            onSuccess(value)
                        case .failure(let error):
                            onFailure(error)
                        default:
                            print("Not a success/failure yet")
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }

    /**
     Subscribes to changes in a property of the StateType. The closures are executed on the main thread asynchronously.
     - Parameters:
        - keyPath:    The KeyPath of the property being observed.
        - onNewValue: Executed when the property changes to a new value (different from the old value).
        - newValue:   The new value of the property.
    */
    public final func selectSubscribe<T: Equatable>(
        to keyPath: KeyPath<StateType, T>,
        onNewValue: @escaping (_ newValue: T) -> Void
    ) {

        // BehaviorRelay emits its current/initial value to new subscribers therefore use that as
        // starting value to compare against in the distinctUntilChanged operator
        // and skip it so it doesn't trigger onNewValue when subscribing.
        self.stateStore.state
            .map { (state: StateType) -> T in
                return state[keyPath: keyPath]
            }
            .distinctUntilChanged()
            .skip(1)
            .debug("Select Subscribe state change", trimOutput: false)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { (value: T) -> Void in
                    onNewValue(value)
                }
            )
            .disposed(by: self.disposeBag)
    }

    /**
     Subscribes to changes in two properties of the StateType. The closures are executed on the main thread asynchronously.
     - Parameters:
        - keyPath1:   The KeyPath of the first property being observed.
        - keyPath2:   The KeyPath of the second property being observed.
        - onNewValue: Executed when at least one of the properties change to a new value (different from the old value).
        - newValue:   The value of the properties when onNewValue is executed.
    */
    public final func selectSubscribe<T: Equatable, U: Equatable>(
        keyPath1: KeyPath<StateType, T>,
        keyPath2: KeyPath<StateType, U>,
        onNewValue: @escaping (_ newValue: (T, U)) -> Void
    ) {

        // BehaviorRelay emits its current/initial value to new subscribers therefore use that as
        // starting value to compare against in the distinctUntilChanged operator
        // and skip it so it doesn't trigger onNewValue when subscribing.
        self.stateStore.state
            .map { (state: StateType) -> SubscribeSelect2<T, U> in
                return SubscribeSelect2<T, U>(t: state[keyPath: keyPath1], u: state[keyPath: keyPath2])
            }
            .distinctUntilChanged()
            .skip(1)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { (value: SubscribeSelect2<T, U>) -> Void in
                    onNewValue((value.t, value.u))
                }
            )
            .disposed(by: self.disposeBag)
    }

    /**
     Subscribes to changes in three properties of the StateType. The closures are executed on the main thread asynchronously.
     - Parameters:
         - keyPath1:   The KeyPath of the first property being observed.
         - keyPath2:   The KeyPath of the second property being observed.
         - keyPath3:   The KeyPath of the second property being observed.
         - onNewValue: Executed when at least one of the properties change to a new value (different from the old value).
         - newValue:   The value of the properties when onNewValue is executed.
    */
    public final func selectSubscribe<T: Equatable, U: Equatable, V: Equatable>(
        keyPath1: KeyPath<StateType, T>,
        keyPath2: KeyPath<StateType, U>,
        keyPath3: KeyPath<StateType, V>,
        onNewValue: @escaping (_ newValue: (T, U, V)) -> Void // swiftlint:disable:this large_tuple
    ) {

        // BehaviorRelay emits its current/initial value to new subscribers therefore use that as
        // starting value to compare against in the distinctUntilChanged operator
        // and skip it so it doesn't trigger onNewValue when subscribing.
        self.stateStore.state
            .map { (state: StateType) -> SubscribeSelect3<T, U, V> in
                return SubscribeSelect3<T, U, V>(
                    t: state[keyPath: keyPath1],
                    u: state[keyPath: keyPath2],
                    v: state[keyPath: keyPath3]
                )
            }
            .distinctUntilChanged()
            .skip(1)
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
     - id:         The unique identifier of the ExpandableComponent.
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
