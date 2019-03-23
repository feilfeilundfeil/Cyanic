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
import struct CoreGraphics.CGFloat

/**
 A BaseComponentVC subclass that is managed by three BaseViewModels. State changes from any of the three BaseViewModels
 triggers a rebuild of the AnyComponents array.
*/
open class ThreeViewModelComponentVC<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>,
    ThirdState: State, ThirdViewModel: BaseViewModel<ThirdState>
>: BaseComponentVC {

    /**
     Initializer.
     - Parameters:
        - viewModelOne: The first BaseViewModel that manages this BaseComponentVC
        - viewModelTwo: The second BaseViewModel that manages this BaseComponentVC
        - viewModelThree: The third BaseViewModel that manages this BaseComponentVC
    */
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

        let combinedObservable: Observable<(FirstState, SecondState, ThirdState)> = Observable
            .combineLatest(self.viewModelOne.state, self.viewModelTwo.state, self.viewModelThree.state)
        self.setUpStateObservable(combinedObservable)
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

}
