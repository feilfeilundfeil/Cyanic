//
//  SizedComponentType.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = SizedComponent
/// StaticTextComponentType is a protocol for Component data structures that represent UI of a fixed size.
public protocol SizedComponentType: StaticHeightComponent {

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets on the UIView relative to its root UIView.
    /// The default value is UIEdgeInsets.zero.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The background color of the root view. The default value is UIColor.clear.
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = Alignment.fill
    // sourcery: skipHashing, skipEquality
    /// The alignment of the underlying SizeLayout. The default value is Alignment.fill.
    var alignment: Alignment { get set }

    // sourcery: defaultValue = Flexibility.flexible
    // sourcery: skipHashing, skipEquality
    /// The flexibility of the underlying SizeLayout. The default value is Flexibility.flexible.
    var flexibility: Flexibility { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The configuration applied to the UIView. The default closure does nothing.
    var configuration: (UIView) -> Void { get set }

    // sourcery: defaultValue = "UIView.self"
    // sourcery: skipHashing, skipEquality
    /// The UIView subclass that will be created to fill the space of the root UIView.
    var viewClass: UIView.Type { get set }

}
