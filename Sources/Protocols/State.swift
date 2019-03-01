//
//  State.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation

/**
 State is the data structure representing the state of your screen.
*/
public protocol State: Equatable, Changeable {

    static var `default`: Self { get }

}
