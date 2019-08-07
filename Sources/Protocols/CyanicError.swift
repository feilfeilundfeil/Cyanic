//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.05.19.
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 This protocol exists because using the Error protocol's localizedDescription is unreliable. Using localizedDescription
 to diff when overriding the default implmentation does not work as of 14.05.2019.
*/
public protocol CyanicError: Error {

    /**
     String representation of the CyanicError instance
    */
    var errorDescription: String { get }

}
