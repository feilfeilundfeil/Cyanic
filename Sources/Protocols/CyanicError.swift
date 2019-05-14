//
//  CyanicError.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
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
