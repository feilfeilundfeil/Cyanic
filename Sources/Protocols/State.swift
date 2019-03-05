//
//  State.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 State is the data structure representing the state of your screen.
*/
public protocol State: Equatable, Copyable {

    static var `default`: Self { get }

}

public protocol ExpandableState: State {

    var expandableDict: [String: Bool] { get set }

}
