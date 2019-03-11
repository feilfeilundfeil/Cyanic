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
 Represents a State data structure that keeps track of two other State data structures. CompositeTwoStateType itself is stateless. It functions
 as a container for other states.
*/
public final class CompositeTwoStateType<FirstState: State, SecondState: State>: State {

    public static var `default`: CompositeTwoStateType<FirstState, SecondState> {
        return CompositeTwoStateType(firstState: FirstState.default, secondState: SecondState.default)
    }

    /**
     Initializer.
     - parameters:
        - firstState: The FirstState instance.
        - secondState: The SecondState instance.
    */
    public init(firstState: FirstState, secondState: SecondState) {
        self.firstState = firstState
        self.secondState = secondState
    }

    /**
     The instance of the first State data structure.
    */
    public internal(set) var firstState: FirstState

    /**
     The instance of the second State data structure.
    */
    public internal(set) var secondState: SecondState

    public static func == (lhs: CompositeTwoStateType<FirstState, SecondState>, rhs: CompositeTwoStateType<FirstState, SecondState>) -> Bool {
        return lhs.firstState == rhs.firstState &&
            lhs.secondState == rhs.secondState
    }

    public func hash(into hasher: inout Hasher) {
        self.firstState.hash(into: &hasher)
        self.secondState.hash(into: &hasher)
    }

}

/**
 Represents a State data structure that keeps track of three other State data structures. CompositeThreeStateType itself is stateless. It functions
 as a container for other states.
*/
public final class CompositeThreeStateType<FirstState: State, SecondState: State, ThirdState: State>: State {

    public static var `default`: CompositeThreeStateType<FirstState, SecondState, ThirdState> {
        return CompositeThreeStateType(
            firstState: FirstState.default,
            secondState: SecondState.default,
            thirdState: ThirdState.default
        )
    }

    /**
     Initializer.
     - parameters:
     - firstState: The FirstState instance.
     - secondState: The SecondState instance.
     - thirdState: The ThirdState instance.
     */
    public init(firstState: FirstState, secondState: SecondState, thirdState: ThirdState) {
        self.firstState = firstState
        self.secondState = secondState
        self.thirdState = thirdState
    }

    /**
     The instance of the first State data structure.
    */
    public internal(set) var firstState: FirstState

    /**
     The instance of the second State data structure.
    */
    public internal(set) var secondState: SecondState

    /**
     The instance of the third State data structure.
    */
    public internal(set) var thirdState: ThirdState

    public static func == (
        lhs: CompositeThreeStateType<FirstState, SecondState, ThirdState>,
        rhs: CompositeThreeStateType<FirstState, SecondState, ThirdState>
    ) -> Bool {
        return lhs.firstState == rhs.firstState &&
            lhs.secondState == rhs.secondState &&
            lhs.thirdState == rhs.thirdState
    }

    public func hash(into hasher: inout Hasher) {
        self.firstState.hash(into: &hasher)
        self.secondState.hash(into: &hasher)
        self.thirdState.hash(into: &hasher)
    }

}
