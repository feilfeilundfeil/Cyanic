//
//  Cyanic
//  Created by Julio Miguel Alorro on 18.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics

/**
 ComponentsController is responsible for managing an Array of AnyComponents. It functions as the data source for models
 to display on a UICollectionView/UITableView.
*/
public struct ComponentsController {

    /**
     Initializer.
     - Parameters:
        - width: The width of the UICollectionView/UITableView. ComponentsController mutates the width property of every
                Component that is added to its Array.
    */
    public init(width: CGFloat) {
        self.width = width
    }

    /**
     The width of the UICollectionView/UITableView where the Components will be displayed.
    */
    public let width: CGFloat

    /**
     The total height of the Components will be displayed.
    */
    public var height: CGFloat {
        return self.components.reduce(into: 0.0, { (currentHeight: inout CGFloat, component: AnyComponent) -> Void in
            currentHeight += component.layout(width: self.width).measurement(
                within: CGSize(width: self.width, height: CGFloat.greatestFiniteMagnitude)
            )
                .size
                .height
        })
    }

    /**
     The Array of AnyComponents managed by this ComponentsController.
    */
    public internal(set) var components: [AnyComponent] = []

    /**
     Adds a Component to the array as an AnyComponent instance.
     - Parameters:
        - component: The Component instance to be added to the components array.
    */
    public mutating func add<C: Component>(_ component: C) {
        self.components.append(component.asAnyComponent)
    }

    /**
     Adds Components of the same type to the array.
     - Parameters:
        - components: The Component instances to be added to the components array.
    */
    public mutating func add<Components: Sequence, C: Component>(_ components: Components) where Components.Element == C {
        self.components.append(contentsOf: components.map({ $0.asAnyComponent}))
    }

    /**
     Adds Components of the same type to the array. Variadic version of the method.
     - Parameters:
        - components: The Component instances to be added to the components array.
    */
    public mutating func add<Components: Component>(_ components: Components...) {
        self.components.append(contentsOf: components.map({ $0.asAnyComponent}))
    }

}
