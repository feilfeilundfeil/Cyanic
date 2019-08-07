//
//  Cyanic
//  Created by Julio Miguel Alorro on 10.04.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

/**
 DividerLine is a data structure representing the characteristics of the UIView used a "divider line" on the ExpandableComponent.
*/
public struct DividerLine {

    /**
     Initializer.
     - Parameters:
        - backgroundColor: The UIColor of the divider line UIView.
        - insets: The insets of the divider line UIView.
        - height: The height of the divider line.
    */
    public init(backgroundColor: UIColor, insets: UIEdgeInsets, height: CGFloat) {
        self.backgroundColor = backgroundColor
        self.insets = insets
        self.height = height
    }

    /**
     The UIColor used by the divider line UIView
    */
    public let backgroundColor: UIColor

    /**
     The UIEdgeInsets used by the divider line UIView.
    */
    public let insets: UIEdgeInsets

    /**
     The height used by the divider line UIView
    */
    public let height: CGFloat

}
