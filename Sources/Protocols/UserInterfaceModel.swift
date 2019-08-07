//
//  Cyanic
//  Created by Julio Miguel Alorro on 04.03.19.
//  Licensed under the MIT license. See LICENSE file
//

/**
 The UserInterfaceModel protocol is a workaround protocol to be able to access a Component's layout without casting
 it to Component (which causes a generic constraint error).
*/
public protocol UserInterfaceModel {

    // sourcery: isLayout = true
    // sourcery: skipHashing,skipEquality,
    /// The LayoutKit related class that will calculate size, location and configuration of the subviews in the ComponentCell
    var layout: ComponentLayout { get }

}
