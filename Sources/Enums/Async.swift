//
//  Async.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/13/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 Represents some data/model that is must be retrieved some time after the screen in rendered.
*/
public enum Async<T: Hashable>: Hashable {

    // MARK: Static Methods
    public static func == (lhs: Async<T>, rhs: Async<T>) -> Bool {
        switch (lhs, rhs) {
            case let (.success(lhsValue), .success(rhsValue)):
                return lhsValue == rhsValue

            case let (.failure(lhsError), .failure(rhsError)):
                return type(of: lhsError) == type(of: rhsError) &&
                    lhsError.errorDescription == rhsError.errorDescription

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
    case failure(CyanicError)

    /**
     The data/model is being fetched.
    */
    case loading

    /**
     The data/model has not been fetched and the process to get it has not started
    */
    case uninitialized

    // MARK: Computed Properties
    /**
     Returns the underlying model if this instance is a .success case. Otherwise, returns nil.
    */
    public var value: T? {
        guard case let .success(model) = self else { return nil }
        return model
    }

    // MARK: Instance Methods
    public func hash(into hasher: inout Hasher) {
        switch self {
            case .success(let value):
                value.hash(into: &hasher)

            case .failure(let error):
                error.localizedDescription.hash(into: &hasher)
                ObjectIdentifier(type(of: self)).hash(into: &hasher)

            case .loading:
                "loading".hash(into: &hasher)

            case .uninitialized:
                "uninitialized".hash(into: &hasher)
        }
    }
}
