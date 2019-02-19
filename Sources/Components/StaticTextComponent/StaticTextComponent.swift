//
//  StaticTextComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Alacrity
import CoreGraphics
import Foundation
import LayoutKit

public final class StaticTextComponent: Component, AutoEquatable, AutoHashable {

    public init(
        id: String,
        text: Text,
        font: UIFont = UIFont.systemFont(ofSize: 13.0),
        backgroundColor: UIColor = UIColor.clear,
        lineFragmentPadding: CGFloat = 0.0,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        alignment: Alignment = Alignment.centerLeading,
        flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility,
        style: AlacrityStyle<UITextView>
    ) {
        self.id = id
        self.text = text
        self.font = font
        self.backgroundColor = backgroundColor
        self.lineFragmentPadding = lineFragmentPadding
        self.insets = insets
        self.alignment = alignment
        self.flexibility = flexibility
        self.style = style
    }

    public let id: String
    public let text: Text
    public let font: UIFont
    public let backgroundColor: UIColor
    public let lineFragmentPadding: CGFloat
    //sourcery:skipHashing,skipEquality
    public let insets: UIEdgeInsets
    //sourcery:skipHashing,skipEquality
    public let alignment: Alignment
    //sourcery:skipHashing,skipEquality
    public let flexibility: Flexibility
    //sourcery:skipHashing,skipEquality
    public let style: AlacrityStyle<UITextView>

    // MARK: - Stored Properties
    //sourcery:skipHashing,skipEquality
    public let cellType: ComponentCell.Type = ComponentCell.self

    public var layout: ComponentLayout {
        return StaticTextComponentLayout(
            id: self.id,
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

    public var identity: StaticTextComponent {
        return self
    }
    
    public func isEqual(to other: StaticTextComponent) -> Bool {
        return self == other
    }
}
