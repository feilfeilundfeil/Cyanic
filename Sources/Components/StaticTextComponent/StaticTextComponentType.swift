//
//  StaticTextComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIColor
import class UIKit.UIFont
import class UIKit.UITextView
import enum LayoutKit.Text
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

public protocol StaticTextComponentType: Component {

    // sourcery: defaultValue = "Text.unattributed("")"
    var text: Text { get set }

    // sourcery: defaultValue = "UIFont.systemFont(ofSize: 13.0)"
    var font: UIFont { get set }

    // sourcery: defaultValue = UIColor.clear
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = "0.0"
    var lineFragmentPadding: CGFloat { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = Alignment.centerLeading
    // sourcery: skipHashing, skipEquality
    var alignment: Alignment { get set }

    // sourcery: defaultValue = TextViewLayoutDefaults.defaultFlexibility
    // sourcery: skipHashing, skipEquality
    var flexibility: Flexibility { get set }

    // sourcery: defaultValue = AlacrityStyle<UITextView> { _ in }
    // sourcery: skipHashing, skipEquality
    var style: AlacrityStyle<UITextView> { get set }

}
