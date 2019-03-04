//
//  ExpandableComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Alacrity
import FFUFWidgets
import LayoutKit
import RxSwift
import RxCocoa
import UIKit

// sourcery: AutoEquatable,AutoHashable
public struct ExpandableComponent: ExpandableComponentType {

    public var id: String

    // sourcery: skipHashing, skipEquality 
    public var layout: ComponentLayout {
        return ExpandableComponentLayout(
            id: self.id,
            contentLayout: self.contentLayout,
            backgroundColor: self.backgroundColor,
            height: self.height,
            insets: self.insets,
            alignment: self.alignment,
            chevronSize: self.chevronSize,
            chevronStyle: self.chevronStyle,
            relay: self.relay,
            disposeBag: self.disposeBag,
            isExpanded: self.isExpanded
        )
    }

    // sourcery: skipHashing, skipEquality 
    public let cellType: ComponentCell.Type = ComponentCell.self

    // sourcery: skipHashing, skipEquality 
    public var contentLayout: ExpandableContentLayout

    public var backgroundColor: UIColor = UIColor.clear

    public var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality 
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    // sourcery: skipHashing, skipEquality 
    public var alignment: Alignment = Alignment.centerLeading

    public var chevronSize: CGSize = CGSize(width: 12.0, height: 12.0)

    // sourcery: skipHashing, skipEquality
    public var chevronStyle: AlacrityStyle<ChevronView> = AlacrityStyle<ChevronView> { _ in }

    public var isExpanded: Bool

    // sourcery: skipHashing, skipEquality 
    public let relay: PublishRelay<(String, Bool)>

    // sourcery: skipHashing, skipEquality
    public let disposeBag: DisposeBag = DisposeBag()

    public var identity: ExpandableComponent { return self }
}

public extension ExpandableComponent {

    init(id: String, contentLayout: ExpandableContentLayout, isExpanded: Bool, relay: PublishRelay<(String, Bool)>) {
        self.id = id
        self.contentLayout = contentLayout
        self.isExpanded = isExpanded
        self.relay = relay
    }

}
