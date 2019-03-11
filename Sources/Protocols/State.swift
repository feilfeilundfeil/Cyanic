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

    /**
     The default State instance.
    */
    static var `default`: Self { get }

}

/**
 State that has expandable UI and needs to persist the isExpanded/isCollapsed state.
*/
public protocol ExpandableState: State {

    /**
     The dictionary that contains the isExpanded/isCollapsed state of ExpandableComponentTypes.
    */
    var expandableDict: [String: Bool] { get set }

}

/**
 Represents a State data structure that keeps track of two other State data structures.
*/
public protocol CompositeTwoStateType: State {

    /**
     The concrete type of the first State data structure being tracked.
    */
    associatedtype FirstState: State

    /**
     The concrete type of the second State data structure being tracked.
    */
    associatedtype SecondState: State

    /**
     The instance of the first State data structure.
    */
    var firstState: FirstState { get set }

    /**
     The instance of the first State data structure.
    */
    var secondState: SecondState { get set }

}

/**
 Represents a State data structure that keeps track of two other State data structures.
*/
public protocol CompositeThreeStateType: State {

    /**
     The concrete type of the first State data structure being tracked.
    */
    associatedtype FirstState: State

    /**
     The concrete type of the second State data structure being tracked.
    */
    associatedtype SecondState: State

    /**
     The concrete type of the third State data structure being tracked.
    */
    associatedtype ThirdState: State

    /**
     The instance of the first State data structure.
    */
    var firstState: FirstState { get set }

    /**
     The instance of the first State data structure.
    */
    var secondState: SecondState { get set }

    /**
     The instance of the first State data structure.
    */
    var thirdState: ThirdState { get set }

}
