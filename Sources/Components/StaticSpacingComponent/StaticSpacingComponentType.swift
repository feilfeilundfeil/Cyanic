//
//  StaticSpacingComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIColor
import struct CoreGraphics.CGFloat

/**
 StaticSpacingComponentType is a protocol for Components that represent space between other components / content on the screen.
*/
public protocol StaticSpacingComponentType: Component {

    // sourcery: defaultValue = "0.0"
    /// The height of the spacing between content.
    var height: CGFloat { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The backgroundColor of the spacing.
    var backgroundColor: UIColor { get set }

}
