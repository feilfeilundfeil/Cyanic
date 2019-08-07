//
//  Cyanic
//  Created by Julio Miguel Alorro on 07.03.19.
//  Licensed under the MIT license. See LICENSE file
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
