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
 ChildVCComponentType is a protocol for Component data structures that want to show other UIViewControllers as a
 child UIViewController to the BaseComponentVC.
*/
public protocol ChildVCComponentType: Component, CustomStringConvertible {

    // sourcery: skipHashing, skipEquality
    // sourcery: defaultValue = "InvalidChildComponentVC()"
    /// The child UIViewController instance to be shown on the UICollectionView.
    var childVC: ChildComponentVC { get set }

    // sourcery: skipHashing, skipEquality
    // sourcery: isWeak
    /// The parent UIViewController instance of the child VC. It is usually the BaseComponentVC.
    var parentVC: UIViewController? { get set }

    // sourcery: defaultValue = "250.0"
    /// The height of the ComponentCell that represents this Component.
    var height: CGFloat { get set }

}

public extension ChildVCComponentType {

    /// The class name of the childVC.
    // sourcery: isInExtension
    var name: String {
        return String(describing: Mirror(reflecting: self.childVC).subjectType)
    }

}

public extension ChildVCComponentType {

    // sourcery: isInExtension
    var description: String {
        return self.name
    }

}
