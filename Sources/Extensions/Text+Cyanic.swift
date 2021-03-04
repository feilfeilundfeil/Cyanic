//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import Foundation
import LayoutKit

extension Text: Hashable {

    /**
     The associated string value of either the String from .unattributed or the NSAttributedString.string from
     .attributed cases.
    */
    public var value: String {
        switch self {
            case .unattributed(let string):
                return string
            case .attributed(let string):
                return string.string
            @unknown default:
                fatalError("New case not handled")
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
            @unknown default:
                fatalError("New case not handled")
        }
    }
}
