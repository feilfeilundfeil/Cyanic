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

public protocol CompositeTwoStateType: State {

    associatedtype FirstState: State
    associatedtype SecondState: State

    init(firstState: FirstState, secondState: SecondState)

    var firstState: FirstState { get set }
    var secondState: SecondState { get set }

}

public protocol CompositeThreeStateType: State {

    associatedtype FirstState: State
    associatedtype SecondState: State
    associatedtype ThirdState: State

    init(firstState: FirstState, secondState: SecondState, thirdState: ThirdState)

    var firstState: FirstState { get }
    var secondState: SecondState { get }
    var thirdState: ThirdState { get }

}
