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
