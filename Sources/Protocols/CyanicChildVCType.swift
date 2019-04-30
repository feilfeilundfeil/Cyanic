//
//  CyanicChildVCType.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit

/**
 The protocol that UIViewControllers adopt in order to be shown inside a ComponentViewController via
 a ChildVCComponent. Call the **cleanUp** method inside `deinit`.
*/
public protocol CyanicChildVCType {}

public extension CyanicChildVCType where Self: UIViewController {

    func cleanUp() {
        self.view?.removeFromSuperview()
        self.willMove(toParent: nil)
        self.removeFromParent()
    }

}

/**
 The default CyanicChildVCType in a ChildVCComponent. This MUST be replaced by another custom CyanicChildVCType.
 Otherwise, it forces a fatalError.
*/
internal final class InvalidChildComponentVC: UIViewController, CyanicChildVCType {}
