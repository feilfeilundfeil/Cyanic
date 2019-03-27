//
//  TestState.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

struct TestState: State {

    // MARK: Static Properties
    static var `default`: TestState {
        return TestState(changeCount: 0)
    }

    // MARK: Stored Properties
    var changeCount: Int

}
