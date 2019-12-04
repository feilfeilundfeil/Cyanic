//
//  Cyanic
//  Created by Julio Miguel Alorro on 13.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

public enum ComponentStateValidator {

    /**
     Checks if the Component instance has a valid identifier.
     - Parameters:
        - component: The Component instance to be checked.
     - Returns:
        Bool indicating whether or not the id is valid.
    */
    public static func hasValidIdentifier<ConcreteComponent: Component>(_ component: ConcreteComponent) -> Bool {
        return component.id != CyanicConstants.invalidID
    }

    /**
     Checks if the ExpandableComponent instance has a valid contentLayout
     - Parameters:
        - component: The ExpandableComponent instance to be checked.
     - Returns:
        Bool indicating whether or not the component's state is valid.
    */
    public static func validateExpandableComponent(_ component: ExpandableComponent) -> Bool {
        let isValidContentLayout: Bool = !(component.contentLayout is EmptyContentLayout)
        var validations: [Bool] = [isValidContentLayout]
        if let contentLayout = component.contentLayout as? ImageLabelContentLayout {
            let size: CGSize = contentLayout.imageSize
            let isValid: Bool = !(size.width == 0.0 || size.height == 0.0)
            #if DEBUG
            if !isValid {
                let errorString: String = "Your imageSize cannot have zero values"
                print("ExpandableError: \(errorString)")
            }
            #endif
            validations.append(isValid)
        }

        return !validations.contains(false)

    }

    /**
     Checks if the ChildVCComponent instance has a valid contentLayout
     - Parameters:
        - component: The ChildVCComponent instance to be checked.
     - Returns:
        Bool indicating whether or not the component's state is valid.
    */
    public static func validateChildVCComponent(_ component: ChildVCComponent) -> Bool {
        var component: ChildVCComponent = component
        let childVC: UIViewController & CyanicChildVCType = component.childVC
        let isInvalidChildComponentVC: Bool = childVC is InvalidChildComponentVC
        return !isInvalidChildComponentVC && component.parentVC != nil
    }

}
