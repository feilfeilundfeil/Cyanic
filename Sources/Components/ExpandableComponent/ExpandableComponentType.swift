//
//  ExpandableComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.PublishRelay
import class RxSwift.DisposeBag
import class UIKit.UIColor
import class UIKit.UIFont
import class UIKit.UILabel
import enum LayoutKit.Text
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct LayoutKit.Alignment
import struct UIKit.UIEdgeInsets

public protocol ExpandableComponentType: Component {

    // sourcery: defaultValue = "Text.unattributed("")"
    var text: Text { get set }

    // sourcery: defaultValue = "UIFont.systemFont(ofSize: 17.0)"
    var font: UIFont { get set }

    // sourcery: defaultValue = UIColor.clear
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = "44.0"
    var height: CGFloat { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = Alignment.centerLeading
    // sourcery: skipHashing, skipEquality
    var alignment: Alignment { get set }

    // sourcery: defaultValue = AlacrityStyle<UILabel> { _ in }
    // sourcery: skipHashing, skipEquality
    var style: AlacrityStyle<UILabel> { get set }

    var isExpanded: Bool { get set }

    // sourcery: skipHashing,skipEquality
    var relay: PublishRelay<(String, Bool)> { get }

    // sourcery: defaultValue = DisposeBag()
    // sourcery: skipHashing,skipEquality
    var disposeBag: DisposeBag { get }
}
