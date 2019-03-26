//
//  Array+Cyanic.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/23/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.Observable

internal extension Array where Element == AnyViewModel {

    /**
     Combines the ViewModels' state observables into one combinedLatest Observable<[Any]>
     - Returns:
        The ViewModels' states as an Observable<[Any]>
    */
    func combineStateObservables() -> Observable<[Any]> {
        let stateObservables: [Observable<Any>] = self.map { $0.state }
        let combinedStatesObservables: Observable<[Any]> = Observable.combineLatest(stateObservables)
        return combinedStatesObservables
    }

}
