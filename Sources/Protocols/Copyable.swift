//
//  Copyable.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/1/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 Copyable is a fork of https://gist.github.com/nicklockwood/9b4aac87e7f88c80e932ba3c843252df.
 Used to mutate Components and State in place with a copy (due to the value-type nature of structs)
*/
public protocol Copyable {}

public extension Copyable {
    /**
     Creates a mutable copy of Self and mutates that copy with the closure.
     - parameters:
        - block: The closure that mutates the mutable copy of Self
        - mutableSelf: The mutable copy of Self passed to the closure.
     - Returns: Mutated copy of Self.
    */
    func copy(with changes: (_ mutableSelf: inout Self) -> Void) -> Self {
        var mutableSelf: Self = self
        changes(&mutableSelf)
        return mutableSelf
    }
}
