//
//  ExpandableComponentType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class FFUFWidgets.ChevronView
import class RxCocoa.PublishRelay
import class RxSwift.DisposeBag
import class UIKit.UIColor
import class UIKit.UIFont
import class UIKit.UILabel
import enum LayoutKit.Text
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct LayoutKit.Alignment
import struct UIKit.UIEdgeInsets

public protocol ExpandableComponentType: Component {

    // sourcery: skipHashing, skipEquality
    var contentLayout: ExpandableContentLayout { get set }

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

    // sourcery: defaultValue = "CGSize(width: 12.0, height: 12.0)"
    var chevronSize: CGSize { get set }

    // sourcery: defaultValue = AlacrityStyle<ChevronView> { _ in }
    // sourcery: skipHashing, skipEquality
    var chevronStyle: AlacrityStyle<ChevronView> { get set }

    var isExpanded: Bool { get set }

    // sourcery: skipHashing,skipEquality
    var relay: PublishRelay<(String, Bool)> { get }

    // sourcery: defaultValue = DisposeBag()
    // sourcery: skipHashing,skipEquality
    var disposeBag: DisposeBag { get }
}
