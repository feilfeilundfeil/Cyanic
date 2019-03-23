//
//  OneViewModelComponentVC.swift
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
 A BaseComponentVC subclass that is managed by one BaseViewModel. State changes from its BaseViewModel triggers
 a rebuild of the AnyComponents array.
*/
open class OneViewModelComponentVC<ConcreteState: State, ConcreteViewModel: BaseViewModel<ConcreteState>>: BaseComponentVC {

    /**
     Initializer.
     - Parameters:
        - viewModel: The BaseViewModel that manages this BaseComponentVC
    */
    public init(viewModel: ConcreteViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
//        self.setUpStateObservable(self.viewModel.state)
    }

    /**
     The ViewModel instance that manages the business logic of this instance of BaseComponentVC
    */
    public let viewModel: ConcreteViewModel

}
