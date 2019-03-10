//
//  ChildComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIViewController

open class ChildComponentVC: UIViewController {

    deinit {
        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view?.removeFromSuperview()
    }

}
