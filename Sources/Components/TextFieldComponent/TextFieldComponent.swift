//
//  TextFieldComponent.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIColor
import class UIKit.UITextField
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = TextFieldComponentLayout
/// TextFieldComponent is a Component that represents a UITextField.
public struct TextFieldComponent: TextFieldComponentType {

// sourcery:inline:auto:TextFieldComponent.AutoGenerateComponent
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the TextFieldComponent.
    */
    public init(id: String) {
        self.id = id
    }

    public var id: String

    public var width: CGFloat = 0.0

    public var height: CGFloat = 44.0

    public var placeholder: String = ""

    // sourcery: skipHashing, skipEquality 
    public var text: String = ""

    // sourcery: skipHashing, skipEquality 
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    public var backgroundColor: UIColor = UIColor.clear

    // sourcery: skipHashing, skipEquality 
    public var alignment: Alignment = Alignment.centerLeading

    // sourcery: skipHashing, skipEquality 
    public var flexibility: Flexibility = Flexibility.flexible

    // sourcery: skipHashing, skipEquality 
    public var configuration: (UITextField) -> Void = { _ in }

    // sourcery: skipHashing, skipEquality 
    public var textDidChange: (UITextField) -> Void = { (_: UITextField) -> Void in print("TextField has new text") }

    // sourcery: skipHashing, skipEquality 
    public var textFieldType: UITextField.Type = UITextField.self

    // sourcery: skipHashing, skipEquality 
    public var layout: ComponentLayout { return TextFieldComponentLayout(component: self) }

    public var identity: TextFieldComponent { return self }
// sourcery:end
}
