//
//  StaticSpacingComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIColor
import struct CoreGraphics.CGFloat

public protocol StaticSpacingComponentType: Component {

    // sourcery: defaultValue = "0.0"
    var height: CGFloat { get set }

    // sourcery: defaultValue = UIColor.clear
    var backgroundColor: UIColor { get set }

}
