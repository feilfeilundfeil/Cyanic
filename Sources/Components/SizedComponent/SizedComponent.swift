//
//  SizedComponent.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import UIKit

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = SizedComponentLayout
/// SizedComponent is a Component that represents a fixed size UIView.
public struct SizedComponent: SizedComponentType {

// sourcery:inline:auto:SizedComponent.AutoGenerateComponent
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the SizedComponent.
    */
    public init(id: String) {
        self.id = id
    }

    public var id: String

    public var width: CGFloat = 0.0

    // sourcery: skipHashing, skipEquality
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    public var backgroundColor: UIColor = UIColor.clear

    // sourcery: skipHashing, skipEquality
    public var alignment: Alignment = Alignment.fill

    // sourcery: skipHashing, skipEquality
    public var flexibility: Flexibility = Flexibility.flexible

    // sourcery: skipHashing, skipEquality
    public var configuration: (UIView) -> Void = { _ in }

    // sourcery: skipHashing, skipEquality
    public var viewClass: UIView.Type = UIView.self

    public var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality
    public var layout: ComponentLayout { return SizedComponentLayout(component: self) }

    public var identity: SizedComponent { return self }
// sourcery:end
}
