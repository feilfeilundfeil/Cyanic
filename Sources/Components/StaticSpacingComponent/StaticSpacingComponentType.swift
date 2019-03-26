//
//  StaticSpacingComponentType.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIColor
import struct CoreGraphics.CGFloat

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = StaticSpacingComponent
/// StaticSpacingComponentType is a protocol for Components that represent space between
/// other components / content on the screen.
public protocol StaticSpacingComponentType: StaticHeightComponent {

    // sourcery: defaultValue = UIColor.clear
    /// The backgroundColor of the spacing.
    var backgroundColor: UIColor { get set }

}
