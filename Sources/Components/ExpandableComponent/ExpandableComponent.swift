//
//  ExpandableComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class FFUFWidgets.ChevronView
import class RxSwift.DisposeBag
import class RxCocoa.PublishRelay
import class UIKit.UIColor
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct LayoutKit.Alignment
import struct UIKit.UIEdgeInsets

// sourcery: AutoEquatable,AutoHashable
/// An ExpandableComponent is a Component that represents an expandable UI element that shows / hides other UI elements grouped with it.
public struct ExpandableComponent: ExpandableComponentType, Selectable {

    public var id: String

    // sourcery: skipHashing, skipEquality 
    public var layout: ComponentLayout {
        return ExpandableComponentLayout(
            id: self.id,
            contentLayout: self.contentLayout,
            backgroundColor: self.backgroundColor,
            height: self.height,
            insets: self.insets,
            chevronSize: self.chevronSize,
            chevronStyle: self.chevronStyle,
            isExpanded: self.isExpanded
        )
    }

    // sourcery: skipHashing, skipEquality 
    public let cellType: ComponentCell.Type = ComponentCell.self

    public var contentLayout: ExpandableContentLayout

    public var backgroundColor: UIColor = UIColor.clear

    public var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality 
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    public var chevronSize: CGSize = CGSize(width: 12.0, height: 12.0)

    // sourcery: skipHashing, skipEquality
    public var chevronStyle: AlacrityStyle<ChevronView> = AlacrityStyle<ChevronView> { _ in }

    public var isExpanded: Bool

    // sourcery: skipHashing, skipEquality 
    public let setExpandableState: (String, Bool) -> Void

    public var identity: ExpandableComponent { return self }

    public func onSelect() {
        self.setExpandableState(self.id, !self.isExpanded)
    }
}

public extension ExpandableComponent {

    /**
     Work around Initializer because memberwise initializers are all or nothing.
     - Parameters:
        - id: The unique identifier of the ExpandableComponent
        - contentLayout: The custom content for the ExpandableComponent
        - isExpanded: Whether the ExpandableComponent is expanded or contracted.
        - relay: PublishRelay that tracks the isExpanded state of this ExpandableComponent.
    */
    init(id: String, contentLayout: ExpandableContentLayout, isExpanded: Bool, setExpandableState: @escaping (String, Bool) -> Void) {
        self.id = id
        self.contentLayout = contentLayout
        self.isExpanded = isExpanded
        self.setExpandableState = setExpandableState
    }

}
