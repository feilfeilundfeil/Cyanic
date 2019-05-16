//
//  TextViewComponent.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/16/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = TextViewComponent
/// TextViewComponentType is a protocol for Components that represents a UITextView.
public protocol TextViewComponentType: StaticHeightComponent {

    // sourcery: defaultValue = """"
    // sourcery: skipHashing, skipEquality
    /// The String displayed as text on the UITextView. The default value is an empty string: "".
    var text: String { get set }

    // sourcery: defaultValue = "UIFont.systemFont(ofSize: 13.0)"
    // sourcery: skipHashing, skipEquality
    /// The font of the Text. The default value is UIFont.systemFont(ofSize: 13.0).
    var font: UIFont { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets on the UITextView relative to its root UIView. The default value is UIEdgeInsets.zero.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The background color of the UITextView. The default value is UIColor.clear.
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
    /// The configuration applied to the UITextField. The default closure does nothing.
    var configuration: (UITextView) -> Void { get set }

    // sourcery: defaultValue = "UITextView.self"
    // sourcery: skipHashing, skipEquality
    var textViewType: UITextView.Type { get set }

}
