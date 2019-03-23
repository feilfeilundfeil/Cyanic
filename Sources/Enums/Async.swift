//
//  Async.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/13/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct Kio.MetaType

/**
 Represents some data/model that is must be retrieved some time after the screen in rendered.
*/
public enum Async<T: Hashable>: Hashable {

    public static func == (lhs: Async<T>, rhs: Async<T>) -> Bool {
        switch (lhs, rhs) {
            case let (.success(lhsValue), .success(rhsValue)):
                return lhsValue == rhsValue

            case let (.failure(lhsError), .failure(rhsError)):
                return type(of: lhsError) == type(of: rhsError) &&
                    lhsError.localizedDescription == rhsError.localizedDescription

            case (.loading, .loading):
                return true

            case (.uninitialized, .uninitialized):
                return true

            default:
                return false
        }
    }

    /**
     The data/model was successfully fetched.
    */
    case success(T)

    /**
     An error was encountered while trying to fetched the data/model.
    */
    case failure(Error)

    /**
     The data/model is being fetched.
    */
    case loading

    /**
     The data/model has not been fetched and the process to get it has not started
    */
    case uninitialized

    public func hash(into hasher: inout Hasher) {
        switch self {
            case .success(let value):
                value.hash(into: &hasher)

            case .failure(let error):
                error.localizedDescription.hash(into: &hasher)
                MetaType<Async<T>>(type(of: self)).hash(into: &hasher)

            case .loading:
                "loading".hash(into: &hasher)

            case .uninitialized:
                "uninitialized".hash(into: &hasher)
        }
    }
}
