//
//  StateA+StateB.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

struct StateA: State {

    static var `default`: StateA {
        return StateA(isTrue: true)
    }

    var isTrue: Bool

}

struct StateB: State {

    static var `default`: StateB {
        return StateB(isTrue: false)
    }

    var isTrue: Bool

}
