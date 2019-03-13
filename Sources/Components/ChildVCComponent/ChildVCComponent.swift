//
//  ChildVCComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIViewController
import struct CoreGraphics.CGFloat

// sourcery: AutoEquatable, AutoHashable,AutoGenerateComponent
public struct ChildVCComponent: ChildVCComponentType, CustomStringConvertible {

    // sourcery: skipHashing, skipEquality, isRequired
    public let childVC: ChildComponentVC

    // sourcery: skipHashing, skipEquality, isRequired
    public unowned let parentVC: UIViewController

    public var height: CGFloat = 250.0

    public var id: String

    // sourcery: skipHashing, skipEquality 
    public var layout: ComponentLayout {
        return ChildVCComponentLayout(childVC: self.childVC, parentVC: self.parentVC, height: height)
    }

    // sourcery: skipHashing, skipEquality 
    public let cellType: ComponentCell.Type = ComponentCell.self

    public var identity: ChildVCComponent { return self }

    public var description: String {
        return self.name
    }

}

public extension ChildVCComponent {

    init(id: String, childVC: ChildComponentVC, parentVC: UIViewController) {
        self.id = id
        self.childVC = childVC
        self.parentVC = parentVC
    }

}
