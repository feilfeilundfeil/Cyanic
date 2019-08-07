//
//  Cyanic
//  Created by Julio Miguel Alorro on 16.05.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

// swiftlint:disable line_length weak_delegate

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
    public let delegate: UITextViewDelegate = CyanicTextViewDelegateProxy()

    // sourcery: skipHashing, skipEquality
    public var shouldBeginEditing: (UITextView) -> Bool = { _ in return true }

    // sourcery: skipHashing, skipEquality
    public var shouldEndEditing: (UITextView) -> Bool = { _ in return true }

    // sourcery: skipHashing, skipEquality
    public var didBeginEditing: (UITextView) -> Void = { _ in }

    // sourcery: skipHashing, skipEquality
    public var didEndEditing: (UITextView) -> Void = { _  in }

    // sourcery: skipHashing, skipEquality
    public var maximumCharacterCount: Int = Int.max

    // sourcery: skipHashing, skipEquality
    public var didChange: (UITextView) -> Void = { _ in }

    // sourcery: skipHashing, skipEquality
    public var didChangeSelection: (UITextView) -> Void = { _ in }

    // sourcery: skipHashing, skipEquality
    public var shouldInteractWithURLInCharacterRange: (UITextView, URL, NSRange, UITextItemInteraction) -> Bool = { _, _, _, _ in return true }

    // sourcery: skipHashing, skipEquality
    public var shouldInteractWithTextAttachmentInCharacterRange: (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool = { _, _, _, _ in return true }

    // sourcery: skipHashing, skipEquality
    public var layout: ComponentLayout { return TextViewComponentLayout(component: self) }

    public var identity: TextViewComponent { return self }
// sourcery:end
}
