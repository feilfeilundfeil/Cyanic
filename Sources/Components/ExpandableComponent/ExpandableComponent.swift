//
//  ExpandableComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Alacrity
import LayoutKit
import RxSwift
import RxCocoa
import UIKit

public final class ExpandableComponent<Key: RawRepresentable>: Component, Hashable where Key.RawValue == String  {

    public init(
        key: Key,
        text: Text,
        font: UIFont = UIFont.systemFont(ofSize: 17.0),
        height: CGFloat = 44.0,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        alignment: Alignment = Alignment.centerLeading,
        style: AlacrityStyle<UILabel> = AlacrityStyle<UILabel> { _ in },
        isExpanded: Bool,
        relay: PublishRelay<(Key, Bool)>
    ) {
        self.key = key
        self.text = text
        self.font = font
        self.height = height
        self.insets = insets
        self.alignment = alignment
        self.style = style
        self.isExpanded = isExpanded
        self.relay = relay
    }

    // MARK: UI Characteristics
    public let text: Text
    public let font: UIFont
    public let height: CGFloat
    public let insets: UIEdgeInsets
    public let alignment: Alignment
    public let style: AlacrityStyle<UILabel>
    public let isExpanded: Bool
    public let relay: PublishRelay<(Key, Bool)>

    public let key: Key
    public var id: String {
        return self.key.rawValue
    }
    public let cellType: ComponentCell.Type = ComponentCell.self
    public let disposeBag: DisposeBag = DisposeBag()

    public var layout: ComponentLayout {
        return ExpandableComponentLayout<Key>(
            id: self.key,
            text: self.text,
            font: self.font,
            height: self.height,
            insets: self.insets,
            alignment: self.alignment,
            labelStyle: self.style,
            relay: self.relay,
            disposeBag: self.disposeBag,
            isExpanded: self.isExpanded
        )
    }

    public func isEqual(to other: ExpandableComponent) -> Bool {
        return self.id == other.id &&
            self.text == other.text &&
            self.font == other.font &&
            self.height == other.height &&
            self.insets == other.insets &&
            self.isExpanded == other.isExpanded
    }

    public static func == (lhs: ExpandableComponent, rhs: ExpandableComponent) -> Bool {
        return lhs.isEqual(to: rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.text)
        hasher.combine(self.font)
        hasher.combine(self.height)
        hasher.combine(self.insets.bottom)
        hasher.combine(self.insets.top)
        hasher.combine(self.insets.left)
        hasher.combine(self.insets.right)
        hasher.combine(self.isExpanded)
    }

    public var identity: ExpandableComponent {
        return self
    }



}
