//
//  Text+FFUFComponents.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit

extension Text: Hashable {

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
                hasher.combine(string)
            case .unattributed(let string):
                hasher.combine(string)
        }
    }
}
