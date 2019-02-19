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

open class ButtonComponent: Component, AutoEquatable, AutoHashable {

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
    //sourcery:skipHashing,skipEquality
    public let insets: UIEdgeInsets
    public let backgroundColor: UIColor
    //sourcery:skipHashing,skipEquality
    public let alignment: Alignment
    //sourcery:skipHashing,skipEquality
    public let flexibility: Flexibility
    //sourcery:skipHashing,skipEquality
    public let style: AlacrityStyle<UIButton>
    //sourcery:skipHashing,skipEquality
    public let onTap: () -> Void
    //sourcery:skipHashing,skipEquality
    public let disposeBag: DisposeBag = .init()

    // MARK: - Stored Properties
    //sourcery:skipHashing,skipEquality
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
            onTap: self.onTap,
            disposeBag: self.disposeBag
        )
    }

    open var identity: ButtonComponent {
        return self
    }

    public func isEqual(to other: ButtonComponent) -> Bool {
        return self == other
    }
}
