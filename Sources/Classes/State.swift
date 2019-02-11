//
//  StringState.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation

public final class State<T: Hashable>: StateType, CustomStringConvertible {

    public init(value: T) {
        self.value = value
    }

    public let value: T

    public static func == (lhs: State<T>, rhs: State<T>) -> Bool {
        return lhs.value == rhs.value
    }

    override public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
    }

    public var description: String {
        if let value = self.value as? CustomStringConvertible {
            return value.description
        } else {
            return String(describing: self.value)
        }
    }

}
