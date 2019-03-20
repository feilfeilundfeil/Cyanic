//
//  ChildVCComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIViewController
import struct CoreGraphics.CGSize

// sourcery: AutoComponentType,AutoGenerateComponent,RequiredVariables
// sourcery: ComponentLayout = "ChildVCComponentLayout"
/// A ChildVCComponent is a Component that represents a child UIViewController presented on a UICollectionViewCell.
public struct ChildVCComponent: ChildVCComponentType {

// sourcery:inline:auto:ChildVCComponent.AutoComponentType
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the ChildVCComponent.
    */
    public init(id: String) {
        self.id = id
    }

    // sourcery: skipHashing, skipEquality 
    public lazy var childVC: ChildComponentVC = InvalidChildComponentVC()

    // sourcery: skipHashing, skipEquality 
    public weak var parentVC: UIViewController?

    public var size: CGSize = CGSize(width: Constants.screenWidth, height: 250.0)

    public var id: String

    // sourcery: skipHashing, skipEquality 
    public var layout: ComponentLayout { return ChildVCComponentLayout(component: self) }

    // sourcery: skipHashing, skipEquality 
    public let cellType: ComponentCell.Type = ComponentCell.self

    public var identity: ChildVCComponent { return self }
// sourcery:end
}
