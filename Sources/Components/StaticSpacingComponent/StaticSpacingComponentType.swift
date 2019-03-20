//
//  StaticSpacingComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIColor
import struct CoreGraphics.CGSize

// sourcery: AutoEquatable,AutoHashable
// sourcery: Component = StaticSpacingComponent
/// StaticSpacingComponentType is a protocol for Components that represent space between
/// other components / content on the screen.
public protocol StaticSpacingComponentType: Component {

    // sourcery: defaultValue = "CGSize(width: Constants.screenWidth, height: 44.0)"
    /// The size of the UICollectionViewCell that this Component is currently representing.
    /// The default value is CGSize(width: Constants.screenWidth, height: 44.0).
    var size: CGSize { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The backgroundColor of the spacing.
    var backgroundColor: UIColor { get set }

}
