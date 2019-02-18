//
//  State.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation

public protocol State: Equatable {

    static var `default`: Self { get }

}

public extension State {

    func changing(block: (inout Self) -> Void) -> Self {
        var mutableSelf: Self = self
        block(&mutableSelf)
        return mutableSelf
    }

}
