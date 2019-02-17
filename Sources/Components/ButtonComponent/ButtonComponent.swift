//
//  ButtonComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import LayoutKit
import Alacrity

open class ButtonComponent: Component, Hashable {

    /**
     Initializer
    */
    public init(
        type: ButtonLayoutType = ButtonLayoutType.system,
        title: String = "",
        id: String,
        height: CGFloat = 44.0,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        backgroundColor: UIColor = UIColor.clear,
        alignment: Alignment = ButtonLayoutDefaults.defaultAlignment,
        flexibility: Flexibility = ButtonLayoutDefaults.defaultFlexibility,
        style: AlacrityStyle<UIButton>,
        onTap: @escaping () -> Void
    ) {
        self.type = type
        self.title = title
        self.id = id
        self.height = height
        self.insets = insets
        self.backgroundColor = backgroundColor
        self.alignment = alignment
        self.flexibility = flexibility
        self.style = style.modifying(with: { $0.backgroundColor = backgroundColor })
        self.onTap = onTap
    }

    // MARK: - UI Characteristics
    public let type: ButtonLayoutType
    public let title: String
    public let id: String
    public let height: CGFloat
    public let insets: UIEdgeInsets
    public let backgroundColor: UIColor
    public let alignment: Alignment
    public let flexibility: Flexibility
    public let style: AlacrityStyle<UIButton>
    public let onTap: () -> Void
    public let disposeBag: DisposeBag = .init()

    // MARK: - Stored Properties
    public let cellType: ComponentCell.Type = ComponentCell.self

    open var layout: ComponentLayout {
        return ButtonComponentLayout(
            type: self.type,
            title: self.title,
            height: self.height,
            contentEdgeInsets: self.insets,
            alignment: self.alignment,
            flexibility: self.flexibility,
            viewReuseId: self.id,
            style: self.style,
            onTap: self.onTap, disposeBag: self.disposeBag
        )
    }

    open func isEqual(to other: ButtonComponent) -> Bool {
        return self.type == other.type &&
            self.title == other.title &&
            self.id == other.id &&
            self.height == other.height &&
            self.insets == other.insets &&
            self.backgroundColor == other.backgroundColor
    }

    public static func == (lhs: ButtonComponent, rhs: ButtonComponent) -> Bool {
        return lhs.isEqual(to: rhs)
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.title)
        hasher.combine(self.id)
        hasher.combine(self.height)
        hasher.combine(self.backgroundColor)
        hasher.combine(self.insets.bottom)
        hasher.combine(self.insets.top)
        hasher.combine(self.insets.left)
        hasher.combine(self.insets.right)
    }

    open var identity: ButtonComponent {
        return self
    }

}
