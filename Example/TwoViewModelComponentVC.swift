//
//  TwoViewModelComponentVC.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic
import class Foundation.NSCoder
import class RxSwift.Observable
import class UIKit.UICollectionViewLayout
import struct CoreGraphics.CGFloat

/**
 A ComponentViewController subclass that is managed by two BaseViewModels. State changes from any of the two BaseViewModels triggers
 a rebuild of the AnyComponents array.
*/
open class TwoViewModelComponentVC<
    FirstState: State, FirstViewModel: BaseViewModel<FirstState>,
    SecondState: State, SecondViewModel: BaseViewModel<SecondState>
>: BaseComponentVC {

    /**
     Initializer.
     - Parameters:
        - viewModelOne: The first ViewModel that manages this ComponentViewController
        - viewModelTwo: The second ViewModel that manages this ComponentViewController
    */
    public init(viewModelOne: FirstViewModel, viewModelTwo: SecondViewModel) {
        self.viewModelOne = viewModelOne
        self.viewModelTwo = viewModelTwo
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     The FirstViewModel instance.
     */
    public let viewModelOne: FirstViewModel

    /**
     The SecondViewModel instance.
    */
    public let viewModelTwo: SecondViewModel

}
