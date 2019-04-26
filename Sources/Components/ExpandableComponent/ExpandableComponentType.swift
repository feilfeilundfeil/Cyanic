//
//  ExpandableComponentType.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = ExpandableComponent
/// ExpandableComponentType is a protocol for Component data structures that want to function like section headers
/// with content that can be hidden / shown on tap.
public protocol ExpandableComponentType: StaticHeightComponent {

    // sourcery: defaultValue = "EmptyContentLayout()"
    /// The content of the ExpandableComponentType to be displayed. Excludes the accessory UIView.
    var contentLayout: ExpandableContentLayout { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The backgroundColor for the entire content of the ExpandableComponentType. The default value is UIColor.clear.
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets for the entire content of the ExpandableComponentType including the accessory UIView. The default value is UIEdgeInsets.zero.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = "UIView.self"
    // sourcery: skipHashing, skipEquality
    /// The UIView type used as the accessory UIView instance. The default value is UIView.self.
    var accessoryViewType: UIView.Type { get set }

    // sourcery: defaultValue = "CGSize(width: 12.0, height: 12.0)"
    /// The size of the accessory UIView instance. The default value is CGSize(width: 12.0, height: 12.0).
    var accessoryViewSize: CGSize { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The configuration that will be applied accessory UIView instance. The default closure does nothing.
    var accessoryViewConfiguration: (UIView) -> Void { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The configuration that will be applied to the root UIView. The default closure does nothing.
    var configuration: (UIView) -> Void { get set }

    // sourcery: defaultValue = false
    /// The state of the ExpandableComponentType that shows whether it is expanded or contracted.
    var isExpanded: Bool { get set }

    // sourcery: skipHashing,skipEquality
    // sourcery: defaultValue = "{ (_: String, _: Bool) -> Void in fatalError("This default closure must be replaced!") }"
    /// A reference to the function will set a new state when the ExpandableComponentType is tapped.
    var setExpandableState: (String, Bool) -> Void { get set }

    // sourcery: skipHashing,skipEquality
    /// The dividerLine
    var dividerLine: DividerLine? { get set }

}
