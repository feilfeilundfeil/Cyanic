//
//  CyanicTextViewDelegateProxy.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/22/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit

internal final class CyanicTextViewDelegateProxy: NSObject {

    // Stored Properties
    /**
     The closure executed when the textViewShouldBeginEditing delegate method is called.
    */
    internal var shouldBeginEditing: (UITextView) -> Bool = { _ in return true }

    /**
     The closure executed when the textViewShouldEndEditing delegate method is called.
    */
    internal var shouldEndEditing: (UITextView) -> Bool = { _ in return true }

    /**
     The closure executed when the textViewDidBeginEditing delegate method is called.
    */
    internal var didBeginEditing: (UITextView) -> Void = { _ in }

    /**
     The closure executed when the textViewDidEndEditing delegate method is called.
    */
    internal var didEndEditing: (UITextView) -> Void = { _  in }

    /**
     The maximum number of characters allowed on the UITextView.
    */
    internal var maximumCharacterCount: Int = Int.max

    /**
     The closure executed when the textViewDidChange delegate method is called.
    */
    internal var didChange: (UITextView) -> Void  = { _ in }

    /**
     The closure executed when the textViewDidChangeSelection delegate method is called.
    */
    internal var didChangeSelection: (UITextView) -> Void = { _ in }

    /**
     The closure executed when the textView:shouldInteractWithURL:characterRange:interaction delegate method is called.
    */
    internal var shouldInteractWithURLInCharacterRange: (UITextView, URL, NSRange, UITextItemInteraction) -> Bool = { _, _, _, _ in return true } // swiftlint:disable:this line_length

    /**
     The closure executed when the textView:shouldInteractWithTextAttachement:characterRange:interaction delegate
     method is called.
    */
    internal var shouldInteractWithTextAttachmentInCharacterRange: (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool = { _, _, _, _ in return true } // swiftlint:disable:this line_length
}

extension CyanicTextViewDelegateProxy: UITextViewDelegate {
    internal func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.shouldBeginEditing(textView)
    }

    internal func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.shouldEndEditing(textView)
    }

    internal func textViewDidBeginEditing(_ textView: UITextView) {
        self.didBeginEditing(textView)
    }

    internal func textViewDidEndEditing(_ textView: UITextView) {
        self.didEndEditing(textView)
    }

    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText: String = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= self.maximumCharacterCount
    }

    internal func textViewDidChange(_ textView: UITextView) {
        self.didChange(textView)
    }

    internal func textViewDidChangeSelection(_ textView: UITextView) {
        self.didChangeSelection(textView)
    }

    internal func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.shouldInteractWithURLInCharacterRange(textView, URL, characterRange, interaction)
    }

    internal func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.shouldInteractWithTextAttachmentInCharacterRange(textView, textAttachment, characterRange, interaction)
    }
}
