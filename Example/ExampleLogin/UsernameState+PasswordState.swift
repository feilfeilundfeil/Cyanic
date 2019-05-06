//
//  UsernameState+PasswordState.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

public struct UsernameState: State {

    public static var `default`: UsernameState {
        return UsernameState(userName: "")
    }

    public var userName: String

}

public struct PasswordState: State {

    public static var `default`: PasswordState {
        return PasswordState(password: "")
    }

    public var password: String

}
