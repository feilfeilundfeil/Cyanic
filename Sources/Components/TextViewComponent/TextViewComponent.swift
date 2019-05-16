//
//  TextViewComponent.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/16/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import UIKit

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = TextViewComponentLayout
public struct TextViewComponent: TextViewComponentType {

// sourcery:inline:auto:TextViewComponent.AutoGenerateComponent
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the TextViewComponent.
    */
    public init(id: String) {
        self.id = id
    }

    public var id: String

    public var width: CGFloat = 0.0

    public var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality
    public var text: String = ""

    // sourcery: skipHashing, skipEquality
    public var font: UIFont = UIFont.systemFont(ofSize: 13.0)

    // sourcery: skipHashing, skipEquality
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    public var backgroundColor: UIColor = UIColor.clear

    // sourcery: skipHashing, skipEquality
    public var alignment: Alignment = Alignment.fill

    // sourcery: skipHashing, skipEquality
    public var flexibility: Flexibility = Flexibility.flexible

    // sourcery: skipHashing, skipEquality
    public var configuration: (UITextView) -> Void = { _ in }

    // sourcery: skipHashing, skipEquality
    public var textViewType: UITextView.Type = UITextView.self

    // sourcery: skipHashing, skipEquality
    public var layout: ComponentLayout { return TextViewComponentLayout(component: self) }

    public var identity: TextViewComponent { return self }
// sourcery:end
}
