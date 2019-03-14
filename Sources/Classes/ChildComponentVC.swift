//
//  ChildComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIViewController

/**
 The base class for UIViewControllers that should be shown inside a BaseComponentVC via a ChildVCComponent.
 When a ChildComponentVC is deinitialized, it removes itself from its parent and it removes its UIView from its superview.
*/
open class ChildComponentVC: UIViewController {

    deinit {
        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view?.removeFromSuperview()
    }

}

/**
 The default ChildComponentVC in a ChildVCComponent. This MUST be replaced by another custom ChildComponentVC. Otherwise, it forces a
 fatalError.
*/
internal final class InvalidChildComponentVC: ChildComponentVC {

    override internal func viewDidLoad() {
        super.viewDidLoad()
        fatalError("This cannot be used as a childVC in ChildVCComponent")
    }

}
