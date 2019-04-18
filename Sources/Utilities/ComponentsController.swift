//
//  ComponentsController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/18/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize

/**
 ComponentsController is responsible for managing an Array of AnyComponents. It functions as the data source for models
 to display on a UICollectionView/UITableView.
*/
public struct ComponentsController {

    /**
     Initializer.
     - Parameters:
        - size: The size of the UICollectionView/UITableView. ComponentsController mutates the width property of every
                Component that is added to its Array.
    */
    internal init(size: CGSize) {
        self.size = size
    }

    /**
     The CGSize of the UICollectionView/UITableView where the Components will be displayed.
    */
    public let size: CGSize

    /**
     The width of the UICollectionView/UITableView where the Components will be displayed.
    */
    public var width: CGFloat {
        return self.size.width
    }

    /**
     The height of the UICollectionView/UITableView where the Components will be displayed.
    */
    public var height: CGFloat {
        return self.size.height
    }

    /**
     The Array of AnyComponents managed by this ComponentsController.
    */
    public private(set) var components: [AnyComponent] = []

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
