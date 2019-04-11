//
//  TextFieldComponentType.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UITextField
import class UIKit.UIColor
import struct Alacrity.AlacrityStyle
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = TextFieldComponent
/// TextFieldComponentType is a protocol for Components that represents a UITextField.
public protocol TextFieldComponentType: StaticHeightComponent {

    // sourcery: defaultValue = """"
    /// The String displayed as placeholder text on the UITextField. The default value is an empty string: "".
    var placeholder: String { get set }

    // sourcery: defaultValue = """"
    // sourcery: skipHashing, skipEquality
    /// The String displayed as text on the UITextField. The default value is an empty string: "". This is intentionally not
    /// used in the Equatable and Hashable implementations due to firstResponder issues.
    var text: String { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets on the UITextField relative to its root UIView.
    /// UIButton. The default value is UIEdgeInsets.zero.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The background color of the UITextField. The default value is UIColor.clear.
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = Alignment.centerLeading
    // sourcery: skipHashing, skipEquality
    /// The alignment of the underlying SizeLayout. The default value is Alignment.centerLeading.
    var alignment: Alignment { get set }

    // sourcery: defaultValue = Flexibility.flexible
    // sourcery: skipHashing, skipEquality
    /// The flexibility of the underlying SizeLayout. The default value is Flexibility.flexible.
    var flexibility: Flexibility { get set }

    // sourcery: defaultValue = AlacrityStyle<UITextField> { _ in }
    // sourcery: skipHashing, skipEquality
    /// The styling applied to the UITextField. The default value is an empty style.
    var style: AlacrityStyle<UITextField> { get set }

    // sourcery: defaultValue = "{ (_: UITextField) -> Void in print("TextField has new text") }"
    // sourcery: skipHashing, skipEquality
    /// This closure is executed 0.5 seconds after the user has stopped typing on the UITextField.
    var textDidChange: (UITextField) -> Void { get set }

    // sourcery: defaultValue = "UITextField.self"
    // sourcery: skipHashing, skipEquality
    var textFieldType: UITextField.Type { get set }

}
