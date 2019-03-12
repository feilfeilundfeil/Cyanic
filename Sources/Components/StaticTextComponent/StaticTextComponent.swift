//
//  StaticTextComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.TextViewLayoutDefaults
import class UIKit.UIColor
import class UIKit.UIFont
import class UIKit.UITextView
import enum LayoutKit.Text
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct UIKit.UIEdgeInsets
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility

// sourcery: AutoEquatable,AutoHashable,AutoGenerateComponent
/// StaticTextComponent is a Component that represents static text to be displayed in a UICollectionViewCell.
public struct StaticTextComponent: StaticTextComponentType {

    public var id: String

    // sourcery: skipHashing, skipEquality 
    public var layout: ComponentLayout {
        return StaticTextComponentLayout(
            text: self.text,
            font: self.font,
            backgroundColor: self.backgroundColor,
            lineFragmentPadding: self.lineFragmentPadding,
            insets: self.insets,
            layoutAlignment: self.alignment,
            flexibility: self.flexibility,
            style: self.style
        )
    }

    // sourcery: skipHashing, skipEquality 
    public let cellType: ComponentCell.Type = ComponentCell.self

    public var text: Text = Text.unattributed("")

    public var font: UIFont = UIFont.systemFont(ofSize: 13.0)

    public var backgroundColor: UIColor = UIColor.clear

    public var lineFragmentPadding: CGFloat = 0.0

    // sourcery: skipHashing, skipEquality 
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    // sourcery: skipHashing, skipEquality 
    public var alignment: Alignment = Alignment.centerLeading

    // sourcery: skipHashing, skipEquality 
    public var flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility

    // sourcery: skipHashing, skipEquality 
    public var style: AlacrityStyle<UITextView> = AlacrityStyle<UITextView> { _ in }

    public var identity: StaticTextComponent { return self }

}

public extension StaticTextComponent {

    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
        - id: The unique identifier of the StaticTextComponent.
    */
    init(id: String) {
        self.id = id
    }
}
