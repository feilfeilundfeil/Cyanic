//
//  TwoViewModelComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import FFUFComponents
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

    /**
     The FirstViewModel instance.
     */
    public let viewModelOne: FirstViewModel

    /**
     The SecondViewModel instance.
    */
    public let viewModelTwo: SecondViewModel

}
