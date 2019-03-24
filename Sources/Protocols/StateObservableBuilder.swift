//
//  StateObservableBuilder.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/23/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.Observable
import protocol RxSwift.SchedulerType

internal protocol StateObservableBuilder {

    func setUpObservables(with viewModels: [AnyViewModel])

}

internal extension StateObservableBuilder {

    /**
     Throttles or debounces the observable based on the passed ThrottleType argument.

     This method either throttles or debounces the observable unless ThrottleType.none is passed.
     - Parameters:
        - observable: The Observable instance to be throttled, debounced ,or unchanged.
        - throttleType: The type of throttling to be used on the the Observable.
        - scheduler: The SchedulerType where the throttling / debouncing occurs.
     - Returns:
        The throttled Observable if ThrottleType.debounce or ThrottleType.throttle are used. Otherwise, it returns
        the same observable.
    */
    internal func setUpThrottleType<State>(
        on observable: Observable<State>,
        throttleType: ThrottleType,
        scheduler: SchedulerType
    ) -> Observable<State> {
        let throttledObservable: Observable<State>

        switch throttleType {
            case .debounce(let timeInterval):
                throttledObservable = observable
                    .debounce(timeInterval, scheduler: scheduler)

            case .throttle(let timeInterval):
                throttledObservable = observable
                    .throttle(timeInterval, latest: true, scheduler: scheduler)

            case .none:
                throttledObservable = observable
        }

        return throttledObservable
    }

}
