//
//  CyanicTextFieldDelegateProxy.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/21/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit

/**
 Serves as the UITextFieldDelegate for the UITextField created in the TextComponentLayout.
*/
internal final class CyanicTextFieldDelegateProxy: NSObject {

    // MARK: Stored Properties
    /**
     The closure executed when the textFieldShouldBeginEditing delegate method is called.
    */
    internal var shouldBeginEditing: (UITextField) -> Bool = { _ in return true }

    /**
     The closure executed when the textFieldDidBeginEditing delegate method is called.
    */
    internal var didBeginEditing: (UITextField) -> Void = { _ in }

    /**
     The closure executed when the textFieldShouldEndEditing delegate method is called.
    */
    internal var shouldEndEditing: (UITextField) -> Bool = { _ in return true }

    /**
     The closure executed when the textFieldDidEndEditing delegate method is called.
    */
    internal var didEndEditing: (UITextField) -> Void = { _ in }

    /**
     The maximum number of characters allowed on the UITextField.
    */
    internal var maximumCharacterCount: Int = Int.max

    /**
     The closure executed when the textFieldShouldClear delegate method is called.
    */
    internal var shouldClear: (UITextField) -> Bool = { _ in return true }

    /**
     The closure executed when the textFieldShouldReturn delegate method is called.
    */
    internal var shouldReturn: (UITextField) -> Bool = { _ in return true }
}

extension CyanicTextFieldDelegateProxy: UITextFieldDelegate {

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.shouldBeginEditing(textField)
    }

    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        self.didBeginEditing(textField)
    }

    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.shouldEndEditing(textField)
    }

    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.didEndEditing(textField)
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: String = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText: String = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= self.maximumCharacterCount
    }

    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.shouldClear(textField)
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.shouldReturn(textField)
    }

}
