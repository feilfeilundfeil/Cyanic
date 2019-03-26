//
//  OneViewModelComponentVC.swift
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
 A ComponentViewController subclass that is managed by one ViewModel. State changes from its ViewModel triggers
 a rebuild of the AnyComponents array.
*/
open class OneViewModelComponentVC<ConcreteState: State, ConcreteViewModel: BaseViewModel<ConcreteState>>: BaseComponentVC {

    /**
     Initializer.
     - Parameters:
        - viewModel: The BaseViewModel that manages this ComponentViewController
    */
    public init(viewModel: ConcreteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     The ViewModel instance that manages the business logic of this instance of ComponentViewController
    */
    public let viewModel: ConcreteViewModel

}
