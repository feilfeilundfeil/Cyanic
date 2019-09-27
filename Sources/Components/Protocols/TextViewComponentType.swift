//
//  Cyanic
//  Created by Julio Miguel Alorro on 16.05.19.
//  Licensed under the MIT license. See LICENSE file
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

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The textContainerInset on the UITextView. The default value is UIEdgeInsets.zero.
    var textContainerInset: UIEdgeInsets { get set }

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

    // sourcery: defaultValue = "CyanicTextViewDelegateProxy()"
    // sourcery: skipHashing, skipEquality
    /// The UITextViewDelegate for the underlying UITextView. This cannot be set, Cyanic takes care of the
    /// implementation. Use the closures to customize functionality.
    var delegate: UITextViewDelegate { get }

    // sourcery: defaultValue = "{ _ in return true }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textViewShouldBeginEditing delegate method is called.
    var shouldBeginEditing: (UITextView) -> Bool { get set }

    // sourcery: defaultValue = "{ _ in return true }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textViewShouldEndEditing delegate method is called.
    var shouldEndEditing: (UITextView) -> Bool { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textViewDidBeginEditing delegate method is called.
    var didBeginEditing: (UITextView) -> Void { get set }

    // sourcery: defaultValue = "{ _  in }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textViewDidEndEditing delegate method is called.
    var didEndEditing: (UITextView) -> Void { get set }

    // sourcery: defaultValue = "Int.max"
    // sourcery: skipHashing, skipEquality
    /// The maximum number of characters allowed on the UITextView.
    var maximumCharacterCount: Int { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textViewDidChange delegate method is called.
    var didChange: (UITextView) -> Void { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textViewDidChangeSelection delegate method is called.
    var didChangeSelection: (UITextView) -> Void { get set }

    // sourcery: defaultValue = " { _, _, _, _ in return true }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textView:shouldInteractWithURL:characterRange:interaction delegate method is called.
    var shouldInteractWithURLInCharacterRange: (UITextView, URL, NSRange, UITextItemInteraction) -> Bool { get set } // swiftlint:disable:this line_length

    // sourcery: defaultValue = " { _, _, _, _ in return true }"
    // sourcery: skipHashing, skipEquality
    /// The closure executed when the textView:shouldInteractWithTextAttachement:characterRange:interaction delegate
    /// method is called.
    var shouldInteractWithTextAttachmentInCharacterRange: (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool { get set }
    // swiftlint:disable:previous line_length

}
