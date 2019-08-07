//
//  Cyanic
//  Created by Julio Miguel Alorro on 01.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = StaticSpacingComponent
/// StaticSpacingComponentType is a protocol for Components that represent space between
/// other components / content on the screen.
public protocol StaticSpacingComponentType: StaticHeightComponent {

    // sourcery: defaultValue = UIColor.clear
    /// The backgroundColor of the spacing.
    var backgroundColor: UIColor { get set }

}
