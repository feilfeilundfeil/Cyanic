//
//  Cyanic
//  Created by Julio Miguel Alorro on 23.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import RxSwift

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
