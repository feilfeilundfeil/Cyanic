//
//  ExampleLoginStateA+ExampleLoginStateB.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

public struct ExampleLoginStateA: State {

    public static var `default`: ExampleLoginStateA {
        return ExampleLoginStateA(isTrue: true, isFirstResponder: false, userName: "")
    }

    public var isTrue: Bool
    public var isFirstResponder: Bool
    public var userName: String

}

public struct ExampleLoginStateB: State {

    public static var `default`: ExampleLoginStateB {
        return ExampleLoginStateB(isTrue: false, isFirstResponder: false, password: "")
    }

    public var isTrue: Bool
    public var isFirstResponder: Bool
    public var password: String

}
