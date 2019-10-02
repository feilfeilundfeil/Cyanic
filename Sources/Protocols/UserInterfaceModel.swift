//
//  Cyanic
//  Created by Julio Miguel Alorro on 04.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics

/**
 The UserInterfaceModel protocol is a workaround protocol to be able to access a Component's layout without casting
 it to Component (which causes a generic constraint error).
*/
public protocol UserInterfaceModel {

    /**
     Returns a ComponentLayout with the given
     */
    func layout(width: CGFloat) -> ComponentLayout

}
