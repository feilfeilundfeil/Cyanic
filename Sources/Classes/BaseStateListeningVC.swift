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
    internal func setUpObservables(with viewModels: [AnyViewModel]) {
        guard !viewModels.isEmpty else { return }
        let combinedStatesObservables: Observable<[Any]> = viewModels.combineStateObservables()

        var throttledStateObservable: Observable<[Any]> = self.setUpThrottleType(
            on: combinedStatesObservables,
            throttleType: self.throttleType,
            scheduler: self.scheduler
        )
        .share()

        #if DEBUG
        throttledStateObservable = throttledStateObservable.debug("\(type(of: self))", trimOutput: false)
        #endif

        throttledStateObservable
            .subscribeOn(self.scheduler)
            .bind(to: self.state)
            .disposed(by: self.disposeBag)

        throttledStateObservable
            .observeOn(self.scheduler)
            .subscribeOn(self.scheduler)
            .bind(
                onNext: { [weak self] (_: [Any]) -> Void in
                    self?.invalidate()
                }
            )
            .disposed(by: self.disposeBag)
    }

    /**
     When the State of the ViewModel changes, invalidate is called, therefore, you should place logic here that
     should react to changes in state.
    */
    open func invalidate() {}

}
