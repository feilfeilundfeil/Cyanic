//
//  State.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 State is the data structure representing the state of your screen.
*/
public protocol State: Hashable, Copyable {

    static var `default`: Self { get }

}

public protocol ExpandableState: State {

    var expandableDict: [String: Bool] { get set }

}

public struct CompositeTwoState<FirstState: State, SecondState: State>: State {

    public static var `default`: CompositeTwoState {
        return CompositeTwoState(firstState: FirstState.default, secondState: SecondState.default)
    }

    public var firstState: FirstState
    public var secondState: SecondState

}

public struct CompositeState<FirstState: State, SecondState: State, ThirdState: State>: State {

    public static var `default`: CompositeState {
        return CompositeState(firstState: FirstState.default, secondState: SecondState.default)
    }

    public var firstState: FirstState
    public var secondState: SecondState

}
