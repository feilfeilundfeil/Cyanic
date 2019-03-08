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
    var vc: ChildComponentVC { get }

    // sourcery: skipHashing, skipEquality
    var parentVC: UIViewController { get }

    // sourcery: defaultValue = "250.0"
    var height: CGFloat { get set }

}

public extension ChildVCComponentType {

    var name: String {
        return String(describing: Mirror(reflecting: self.vc).subjectType)
    }

}
