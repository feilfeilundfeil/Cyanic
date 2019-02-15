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

public final class StaticTextComponent: Component, Hashable {

    public init(
        id: String,
        text: Text,
        font: UIFont = UIFont.systemFont(ofSize: 13.0),
        lineFragmentPadding: CGFloat = 0.0,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
        flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
        style: AlacrityStyle<UITextView>,
        isShown: @escaping () -> Bool = { return true }
    ) {
        self.id = id
        self.text = text
        self.font = font
        self.lineFragmentPadding = lineFragmentPadding
        self.insets = insets
        self.alignment = alignment
        self.flexibility = flexibility
        self.style = style
        self.isShown = isShown
    }

    public let id: String
    public let text: Text
    public let font: UIFont
    public let lineFragmentPadding: CGFloat
    public let insets: UIEdgeInsets
    public let alignment: Alignment
    public let flexibility: Flexibility
    public let style: AlacrityStyle<UITextView>
    public let isShown: () -> Bool

    // MARK: - Stored Properties
    public let cellType: ConfigurableCell.Type = ConfigurableCell.self

    public var layout: ComponentLayout {
        return StaticTextComponentLayout(
            id: self.id,
            text: self.text,
            font: self.font,
            lineFragmentPadding: self.lineFragmentPadding,
            insets: self.insets,
            layoutAlignment: self.alignment,
            flexibility: self.flexibility,
            style: self.style
        )
    }

    public func isEqual(to other: StaticTextComponent) -> Bool {
        return self.id == other.id &&
            self.text == other.text &&
            self.font == other.font &&
            self.lineFragmentPadding == other.lineFragmentPadding &&
            self.insets == other.insets
    }

    public static func == (lhs: StaticTextComponent, rhs: StaticTextComponent) -> Bool {
        return lhs.isEqual(to: rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.text)
        hasher.combine(self.font)
        hasher.combine(self.lineFragmentPadding)
        hasher.combine(self.insets.bottom)
        hasher.combine(self.insets.top)
        hasher.combine(self.insets.left)
        hasher.combine(self.insets.right)
    }

    public var identity: StaticTextComponent {
        return self
    }
}
