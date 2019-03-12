//
//  ThreeViewModelComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxSwift.Observable
import class UIKit.UICollectionViewLayout

open class ThreeViewModelComponentVC<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>,
    ThirdState: State, ThirdViewModel: BaseViewModel<ThirdState>
>: BaseComponentVC {

    public init(viewModelOne: FirstViewModel, viewModelTwo: SecondViewModel, viewModelThree: ThirdViewModel) {
        self.viewModelOne = viewModelOne
        self.viewModelTwo = viewModelTwo
        self.viewModelThree = viewModelThree
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let observable: Observable<(FirstState, SecondState, ThirdState)>

        let combinedObservable: Observable<(FirstState, SecondState, ThirdState)> = Observable.combineLatest(
            self.viewModelOne.state, self.viewModelTwo.state, self.viewModelThree.state
        )

        switch self.throttleType {
            case .debounce(let timeInterval):
                observable = combinedObservable
                    .debounce(timeInterval, scheduler: self.scheduler)

            case .throttle(let timeInterval):
                observable = combinedObservable
                    .throttle(timeInterval, latest: true, scheduler: self.scheduler)

            case .none:
                observable = combinedObservable
        }

        // Call buildModels method when a new element from combinedObservable is emitted
        // Bind the new AnyComponents array to the _components BehaviorRelay
        // RxCollectionViewSectionedAnimatedDataSource.swift line 56.
        // UICollectionView has problems with fast updates. No point in
        // in executing operations when it is throttled anyway.
        observable
            .observeOn(self.scheduler)
            .map { [weak self] (firstState: FirstState, secondState: SecondState, thirdState: ThirdState) -> [AnyComponent] in
                guard let s = self else { return [] }
                var array: ComponentsArray = ComponentsArray()
                s.components(&array, state1: firstState, state2: secondState, state3: thirdState)
                return array.components
            }
            .subscribeOn(self.scheduler)
            .bind(to: self._components)
            .disposed(by: self.disposeBag)
    }

    /**
     The FirstViewModel instance.
     */
    public let viewModelOne: FirstViewModel

    /**
     The SecondViewModel instance.
     */
    public let viewModelTwo: SecondViewModel

    /**
     The ThirdViewModel instance.
     */
    public let viewModelThree: ThirdViewModel

    /**
     This method is responsible for creating the [AnyComponent] array.
     This is where you create for logic to add Components to the ComponentsArray data structure. This method is called every time FirstViewModel's,
     SecondViewModel's, and/or ThirdViewModel's State changes.

     - parameters:
         - components: The ComponentsArray that is mutated by this method. It is always starts as an empty ComponentsArray.
         - state1: The latest snapshot of the FirstState object of FirstViewModel.
         - state2: The latest snapshot of the SecondState object of SecondViewModel.
         - state3: The latest snapshot of the ThirdState object of ThirdViewModel.
     */
    open func components(_ components: inout ComponentsArray, state1: FirstState, state2: SecondState, state3: ThirdState) {
        fatalError("Override this.")
    }

}
