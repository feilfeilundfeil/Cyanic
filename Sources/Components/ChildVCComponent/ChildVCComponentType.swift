//
//  ChildVCComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIViewController
import struct CoreGraphics.CGSize

// sourcery: AutoEquatable,AutoHashable
// sourcery: Component = ChildVCComponent
/// ChildVCComponentType is a protocol for Component data structures that want to show other UIViewControllers as a
/// child UIViewController to the BaseComponentVC.
public protocol ChildVCComponentType: Component, CustomStringConvertible {

    // sourcery: skipHashing, skipEquality
    // sourcery: defaultValue = "InvalidChildComponentVC()", isLazy
    /// The child UIViewController instance to be shown on the UICollectionView.
    var childVC: ChildComponentVC { mutating get set }

    // sourcery: skipHashing, skipEquality
    // sourcery: isWeak
    /// The parent UIViewController instance of the child VC. It is usually the BaseComponentVC.
    var parentVC: UIViewController? { get set }

    // sourcery: defaultValue = "CGSize(width: Constants.screenWidth, height: 250.0)"
    /// The size of the UICollectionViewCell that this Component is currently representing.
    /// The default value is CGSize(width: Constants.screenWidth, height: 250.0).
    var size: CGSize { get set }

}

public extension ChildVCComponentType {

    /// The class name of the childVC.
    // sourcery: isInExtension
    var name: String {
        var mutableSelf: Self = self
        return String(describing: Mirror(reflecting: mutableSelf.childVC).subjectType)
    }

}

public extension ChildVCComponentType {

    // sourcery: isInExtension
    var description: String {
        return self.name
    }

}
