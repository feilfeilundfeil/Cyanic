//
//  ButtonComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIButton
import class UIKit.UIColor
import enum LayoutKit.ButtonLayoutType
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

public protocol ButtonComponentType: Component {

    // sourcery: defaultValue = ButtonLayoutType.system
    var type: ButtonLayoutType { get set }

    // sourcery: defaultValue = """"
    var title: String { get set }

    // sourcery: defaultValue = "44.0"
    var height: CGFloat { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = UIColor.clear
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = ButtonLayoutDefaults.defaultAlignment
    // sourcery: skipHashing, skipEquality
    var alignment: Alignment { get set }

    // sourcery: defaultValue = ButtonLayoutDefaults.defaultFlexibility
    // sourcery: skipHashing, skipEquality
    var flexibility: Flexibility { get set }

    // sourcery: defaultValue = AlacrityStyle<UIButton> { _ in }
    // sourcery: skipHashing, skipEquality
    var style: AlacrityStyle<UIButton> { get set }

    // sourcery: defaultValue = { print("Hello World \(#file)") }
    // sourcery: skipHashing, skipEquality
    var onTap: () -> Void { get set }

}


