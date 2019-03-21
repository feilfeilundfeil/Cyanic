//
//  TwoViewModelComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxSwift.Observable
import class UIKit.UICollectionViewLayout
import struct CoreGraphics.CGFloat

/**
 A BaseComponentVC subclass that is managed by two BaseViewModels. State changes from any of the two BaseViewModels triggers
 a rebuild of the AnyComponents array.
*/
open class TwoViewModelComponentVC<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>
>: BaseComponentVC {

    /**
     Initializer.
     - Parameters:
        - viewModelOne: The first BaseViewModel that manages this BaseComponentVC
        - viewModelTwo: The second BaseViewModel that manages this BaseComponentVC
    */
    public init(viewModelOne: FirstViewModel, viewModelTwo: SecondViewModel) {
        self.viewModelOne = viewModelOne
        self.viewModelTwo = viewModelTwo
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let observable: Observable<(CGFloat, FirstState, SecondState)>

        let combinedObservable: Observable<(CGFloat, FirstState, SecondState)> = Observable
            .combineLatest(
                self._width, self.viewModelOne.state, self.viewModelTwo.state
            )
            .observeOn(self.scheduler)

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

        // Call buildComponents method when a new element from combinedObservable is emitted
        // Bind the new AnyComponents array to the _components BehaviorRelay.
        // NOTE:
        // RxCollectionViewSectionedAnimatedDataSource.swift line 56.
        // UICollectionView has problems with fast updates. So, there is no point in
        // in executing operations in quick succession when it is throttled anyway.
        observable
            .map { [weak self] (width: CGFloat, firstState: FirstState, secondState: SecondState) -> [AnyComponent] in
                guard let s = self else { return [] }
                s.width = width
                var array: ComponentsArray = ComponentsArray(width: width)
                s.buildComponents(&array, state1: firstState, state2: secondState)
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
     This method is responsible for creating the [AnyComponent] array.
     This is where you create for logic to add Components to the ComponentsArray data structure. This method is called
     every time FirstViewModel's and/or SecondViewModel's State changes.

     - Parameters:
        - components: The ComponentsArray that is mutated by this method. It is always starts as an empty ComponentsArray.
        - state1: The latest snapshot of the FirstState object of FirstViewModel.
        - state2: The latest snapshot of the SecondState object of SecondViewModel.
    */
    open func buildComponents(_ components: inout ComponentsArray, state1: FirstState, state2: SecondState) {
        fatalError("Override this.")
    }

}
