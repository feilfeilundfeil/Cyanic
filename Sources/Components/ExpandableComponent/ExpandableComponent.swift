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

// sourcery: AutoEquatable,AutoHashable
public struct ExpandableComponent: ExpandableComponentType {

    public var id: String

    // sourcery: skipHashing, skipEquality 
    public var layout: ComponentLayout {
        return ExpandableComponentLayout(
            id: self.id,
            text: self.text,
            font: self.font,
            backgroundColor: self.backgroundColor,
            height: self.height,
            insets: self.insets,
            alignment: self.alignment,
            labelStyle: self.style,
            relay: self.relay,
            disposeBag: self.disposeBag,
            isExpanded: self.isExpanded
        )
    }

    // sourcery: skipHashing, skipEquality 
    public let cellType: ComponentCell.Type = ComponentCell.self

    public var text: Text = Text.unattributed("")

    public var font: UIFont = UIFont.systemFont(ofSize: 17.0)

    public var backgroundColor: UIColor = UIColor.clear

    public var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality 
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    // sourcery: skipHashing, skipEquality 
    public var alignment: Alignment = Alignment.centerLeading

    // sourcery: skipHashing, skipEquality 
    public var style: AlacrityStyle<UILabel> = AlacrityStyle<UILabel> { _ in }

    public var isExpanded: Bool

    // sourcery: skipHashing, skipEquality 
    public let relay: PublishRelay<(String, Bool)>

    // sourcery: skipHashing, skipEquality
    public let disposeBag: DisposeBag = DisposeBag()

    public var identity: ExpandableComponent { return self }
}

public extension ExpandableComponent {

    init(id: String, isExpanded: Bool, relay: PublishRelay<(String, Bool)>) {
        self.id = id
        self.isExpanded = isExpanded
        self.relay = relay
    }

}
