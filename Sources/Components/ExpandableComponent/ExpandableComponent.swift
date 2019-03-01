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

public final class ExpandableComponent: Component, AutoHashable, AutoEquatable {

    public init(
        id: String,
        text: Text,
        font: UIFont = UIFont.systemFont(ofSize: 17.0),
        height: CGFloat = 44.0,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        alignment: Alignment = Alignment.centerLeading,
        style: AlacrityStyle<UILabel> = AlacrityStyle<UILabel> { _ in },
        isExpanded: Bool,
        relay: PublishRelay<(String, Bool)>
    ) {
        self.id = id
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
    //sourcery:skipHashing,skipEquality
    public let insets: UIEdgeInsets
    //sourcery:skipHashing,skipEquality
    public let alignment: Alignment
    //sourcery:skipHashing,skipEquality
    public let style: AlacrityStyle<UILabel>
    public let isExpanded: Bool
    //sourcery:skipHashing,skipEquality
    public let relay: PublishRelay<(String, Bool)>

    public let id: String

    //sourcery:skipHashing,skipEquality
    public let cellType: ComponentCell.Type = ComponentCell.self
    //sourcery:skipHashing,skipEquality
    public let disposeBag: DisposeBag = DisposeBag()

    public var layout: ComponentLayout {
        return ExpandableComponentLayout(
            id: self.id,
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
        return self == other
    }

    public var identity: ExpandableComponent {
        return self
    }

}
