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
 ComponentsController is a helper struct that transforms Component instances into AnyComponent instances and
 adds it to an array.
*/
public final class ComponentsController {

    /**
     Initializer.
     - Parameters:
        - width: The width of the UICollectionView. Since ComponentsController adds components to itself, it
                 will also determine the width of the Component by mutating its width property to the width
                 of the UICollectionView.
    */
    internal init(size: CGSize) {
        self.size = size
    }

    /**
     The CGSize of the UICollectionView where the components will be displayed.
    */
    public let size: CGSize

    /**
     The width of the UICollectionView where the components will be displayed.
    */
    public var width: CGFloat {
        return self.size.width
    }

    /**
     The height of the UICollectionView where the components will be displayed.
    */
    public var height: CGFloat {
        return self.size.height
    }

    /**
     The AnyComponent array mutated by this ComponentsController.
    */
    public private(set) var components: [AnyComponent] = []

    /**
     Adds a Component to the array as an AnyComponent instance.
     - Parameters:
        - component: The Component instance to be added to the components array.
    */
    public func add<C: Component>(_ component: C) {
        self.components.append(component.asAnyComponent)
    }

    /**
     Adds Components of the same type to the array.
     - Parameters:
        - components: The Component instances to be added to the components array.
    */
    public func add<Components: Sequence, C: Component>(_ components: Components) where Components.Element == C {
        self.components.append(contentsOf: components.map({ $0.asAnyComponent}))
    }

    /**
     Adds Components of the same type to the array. Variadic version of the method.
     - Parameters:
        - components: The Component instances to be added to the components array.
     */
    public func add<Components: Component>(_ components: Components...) {
        self.components.append(contentsOf: components.map({ $0.asAnyComponent}))
    }

}
