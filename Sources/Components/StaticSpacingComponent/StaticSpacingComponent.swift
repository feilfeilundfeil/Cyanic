//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = StaticSpacingComponentLayout
/// StaticSpacingComponent is a Component that represents static spacing between content / other Components.
public struct StaticSpacingComponent: StaticSpacingComponentType {

// sourcery:inline:auto:StaticSpacingComponent.AutoGenerateComponent
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the StaticSpacingComponent.
    */
    public init(id: String) {
        self.id = id
    }

    public var id: String

    public var height: CGFloat = 44.0

    public var backgroundColor: UIColor = UIColor.clear

    public var identity: StaticSpacingComponent { return self }

    public func layout(width: CGFloat) -> ComponentLayout {
        return StaticSpacingComponentLayout(component: self, width: width)
    }
// sourcery:end
}
