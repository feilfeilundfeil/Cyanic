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

/**
 ExpandableComponentType is a protocol for Component data structures that want to function like section headers with content that
 can be hidden / shown on tap.
*/
public protocol ExpandableComponentType: Component {

    // sourcery: skipHashing, skipEquality
    /// The content of the ExpandableComponentType to be displayed. Excludes the ChevronView which is built in.
    var contentLayout: ExpandableContentLayout { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The backgroundColor for the entire content of the ExpandableComponentType. The default value is UIColor.clear.
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = "44.0"
    /// The height of the underlying UICollectionViewCell. The default value is 44.0.
    var height: CGFloat { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets for the entire content of the ExpandableComponentType including the ChevronView. The default value is UIEdgeInsets.zero.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = "CGSize(width: 12.0, height: 12.0)"
    /// The size of the ChevronView. The default value is CGSize(width: 12.0, height: 12.0).
    var chevronSize: CGSize { get set }

    // sourcery: defaultValue = AlacrityStyle<ChevronView> { _ in }
    // sourcery: skipHashing, skipEquality
    /// The styling applied to the ChevronView. The default value is empty styling.
    var chevronStyle: AlacrityStyle<ChevronView> { get set }

    /// The state of the ExpandableComponentType that shows whether it is expanded or contracted.
    var isExpanded: Bool { get set }

    // sourcery: skipHashing,skipEquality
    /// The PublishRelay that keeps track of the isExpanded state of the ExpandableComponentType. This PublishRelay should come from
    /// the ViewModel or BaseComponentVC.
    var relay: PublishRelay<(String, Bool)> { get }
}
