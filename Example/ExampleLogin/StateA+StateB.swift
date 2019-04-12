//
//  StateA+StateB.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

public struct StateA: State {

    public static var `default`: StateA {
        return StateA(isTrue: true, isFirstResponder: false, userName: "")
    }

    public var isTrue: Bool
    public var isFirstResponder: Bool
    public var userName: String

}

public struct StateB: State {

    public static var `default`: StateB {
        return StateB(isTrue: false, isFirstResponder: false, password: "")
    }

    public var isTrue: Bool
    public var isFirstResponder: Bool
    public var password: String

}
