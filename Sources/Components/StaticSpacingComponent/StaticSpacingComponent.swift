//
//  StaticSpacingComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIColor
import struct CoreGraphics.CGFloat

// sourcery: AutoEquatable,AutoHashable
public struct StaticSpacingComponent: StaticSpacingComponentType {

    public var identity: StaticSpacingComponent { return self }

    public var id: String

    // sourcery: skipHashing, skipEquality
    public var layout: ComponentLayout {
        return StaticSpacingComponentLayout(height: self.height, backgroundColor: self.backgroundColor)
    }

    // sourcery: skipHashing, skipEquality
    public let cellType: ComponentCell.Type = ComponentCell.self

    public var height: CGFloat = 0.0

    public var backgroundColor: UIColor = UIColor.clear
}

public extension StaticSpacingComponent {

    init(id: String) {
        self.id = id
    }

}
