//
//  BaseStateListeningVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/21/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxCocoa.BehaviorRelay
import class RxSwift.DisposeBag
import class RxSwift.Observable
import class RxSwift.SerialDispatchQueueScheduler
import class UIKit.UIViewController
import struct Foundation.DispatchQoS
import struct Foundation.UUID

open class BaseStateListeningVC: UIViewController, StateObservableBuilder {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpObservables(with: self.viewModels)
    }

    // MARK: Stored Properties
    /**
     The serial scheduler where the ViewModel's state changes are observed on and mapped to the _components
     */
    internal let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(
        qos: DispatchQoS.userInitiated,
        internalSerialQueueName: "\(UUID().uuidString)"
    )

    /**
     The combined state of the ViewModels as a BehviorRelay for debugging purposes.
    */
    internal let state: BehaviorRelay<[Any]> = BehaviorRelay<[Any]>(value: [()])

    internal let disposeBag: DisposeBag = DisposeBag()

    // MARK: Computed Properties
    /**
     Limits the frequency of state updates.
    */
    open var throttleType: ThrottleType { return ThrottleType.none }

    /**
     The current state of the ViewModels from the state BehaviorRelay.
    */
    public var currentState: Any { return self.state.value }

    /**
     The ViewModels whose state is observed by this BaseStateListeningVC.
    */
    open var viewModels: [AnyViewModel] { return [] }

    // MARK: Methods
    /**
     Creates an Observables based on ThrottleType and binds it to the invalidate method.

     It creates a new Observables based on the ViewModels' States and  BaseStateListeningVC ThrottleType and
     binds it to the invalidate method so any new State change calls the invalidate method.

     - Parameters:
     - viewModels: The ViewModels whose States will be observed.
     */
    internal func setUpObservables(with viewModels: [AnyViewModel]) {
        guard !viewModels.isEmpty else { return }
        let combinedStatesObservables: Observable<[Any]> = viewModels.combineStateObservables()

        var throttledStateObservable: Observable<[Any]> = self.setUpThrottleType(
            on: combinedStatesObservables,
            throttleType: self.throttleType,
            scheduler: self.scheduler
        )
        .share()
        .observeOn(self.scheduler)
        .subscribeOn(self.scheduler)

        #if DEBUG
        throttledStateObservable = throttledStateObservable.debug("\(type(of: self))", trimOutput: false)
        #endif

        throttledStateObservable
            .debug("\(type(of: self))", trimOutput: false)
            .bind(to: self.state)
            .disposed(by: self.disposeBag)

        throttledStateObservable
            .bind { [weak self] (_: [Any]) -> Void in
                self?.invalidate()
            }
            .disposed(by: self.disposeBag)
    }

    /**
     When the State of the ViewModel changes, invalidate is called, therefore, you should place logic here that
     should react to changes in state.

     When overriding, no need to call super because it does nothing.
    */
    open func invalidate() {}

}
