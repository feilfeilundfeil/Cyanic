//
//  Text+Cyanic.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSAttributedString
import enum LayoutKit.Text

extension Text: Hashable {

    /**
     The associated string value of either the String from .unattributed or the NSAttributedString.string from .attributed cases.
    */
    public var value: String {
        switch self {
            case .unattributed(let string):
                return string
            case .attributed(let string):
                return string.string
        }
    }

    public static func == (lhs: Text, rhs: Text) -> Bool {
        switch (lhs, rhs) {
            case let (.attributed(lhsString), attributed(rhsString)):
                return lhsString.isEqual(to: rhsString)
            case let (.unattributed(lhsString), .unattributed(rhsString)):
                return lhsString == rhsString
            default:
                return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
            case .attributed(let string):
                string.hash(into: &hasher)
            case .unattributed(let string):
                string.hash(into: &hasher)
        }
    }
}
