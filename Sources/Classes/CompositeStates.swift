//
//  CompositeStates.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

///**
// Represents a State data structure that keeps track of two other State data structures. CompositeState2 itself is stateless. It functions
// as a container for other states.
// */
//public final class CompositeState2<FirstState: State, SecondState: State>: State {
//
//    public static var `default`: CompositeState2<FirstState, SecondState> {
//        return CompositeState2(firstState: FirstState.default, secondState: SecondState.default)
//    }
//
//    /**
//     Initializer.
//     - Parameters:
//     - firstState: The FirstState instance.
//     - secondState: The SecondState instance.
//     */
//    public init(firstState: FirstState, secondState: SecondState) {
//        self.firstState = firstState
//        self.secondState = secondState
//    }
//
//    /**
//     The instance of the first State data structure.
//     */
//    public internal(set) var firstState: FirstState
//
//    /**
//     The instance of the second State data structure.
//     */
//    public internal(set) var secondState: SecondState
//
//    public static func == (lhs: CompositeState2<FirstState, SecondState>, rhs: CompositeState2<FirstState, SecondState>) -> Bool {
//        return lhs.firstState == rhs.firstState &&
//            lhs.secondState == rhs.secondState
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        self.firstState.hash(into: &hasher)
//        self.secondState.hash(into: &hasher)
//    }
//
//}
//
///**
// Represents a State data structure that keeps track of three other State data structures. CompositeState3 itself is stateless. It functions
// as a container for other states.
// */
//public final class CompositeState3<FirstState: State, SecondState: State, ThirdState: State>: State {
//
//    public static var `default`: CompositeState3<FirstState, SecondState, ThirdState> {
//        return CompositeState3(
//            firstState: FirstState.default,
//            secondState: SecondState.default,
//            thirdState: ThirdState.default
//        )
//    }
//
//    /**
//     Initializer.
//     - Parameters:
//     - firstState: The FirstState instance.
//     - secondState: The SecondState instance.
//     - thirdState: The ThirdState instance.
//     */
//    public init(firstState: FirstState, secondState: SecondState, thirdState: ThirdState) {
//        self.firstState = firstState
//        self.secondState = secondState
//        self.thirdState = thirdState
//    }
//
//    /**
//     The instance of the first State data structure.
//     */
//    public internal(set) var firstState: FirstState
//
//    /**
//     The instance of the second State data structure.
//     */
//    public internal(set) var secondState: SecondState
//
//    /**
//     The instance of the third State data structure.
//     */
//    public internal(set) var thirdState: ThirdState
//
//    public static func == (
//        lhs: CompositeState3<FirstState, SecondState, ThirdState>,
//        rhs: CompositeState3<FirstState, SecondState, ThirdState>
//        ) -> Bool {
//        return lhs.firstState == rhs.firstState &&
//            lhs.secondState == rhs.secondState &&
//            lhs.thirdState == rhs.thirdState
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        self.firstState.hash(into: &hasher)
//        self.secondState.hash(into: &hasher)
//        self.thirdState.hash(into: &hasher)
//    }
//
//}
