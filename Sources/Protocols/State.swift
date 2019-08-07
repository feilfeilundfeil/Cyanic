//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.02.19.
//  Licensed under the MIT license. See LICENSE file
//

/**
 State is a protocol adopted structs representing the state of your view model.
*/
public protocol State: Hashable, Copyable {

    /**
     The default State instance.
    */
    static var `default`: Self { get }

}

/**
 State type that has expandable UI and needs to persist the isExpanded/isCollapsed state.
*/
public protocol ExpandableState: State {

    /**
     The dictionary that contains the isExpanded/isCollapsed state of ExpandableComponentTypes.
    */
    var expandableDict: [String: Bool] { get set }

}
