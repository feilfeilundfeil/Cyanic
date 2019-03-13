//
//  ChildVCComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIViewController
import struct CoreGraphics.CGFloat

/**
*/
public protocol ChildVCComponentType: Component {

    // sourcery: skipHashing, skipEquality
    var childVC: ChildComponentVC { get set }

    // sourcery: skipHashing, skipEquality
    var parentVC: UIViewController? { get set }

    // sourcery: defaultValue = "250.0"
    var height: CGFloat { get set }

}

public extension ChildVCComponentType {

    var name: String {
        return String(describing: Mirror(reflecting: self.childVC).subjectType)
    }

}
