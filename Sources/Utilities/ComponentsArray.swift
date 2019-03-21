//
//  ComponentsArray.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/18/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct CoreGraphics.CGFloat

/**
 ComponentsArray is a helper struct that transforms Component instances into AnyComponent instances and adds it to an array.
*/
public struct ComponentsArray {

    /**
     Initializer.
     - Parameters:
        - width: The width of the UICollectionView. Since ComponentsArray adds components to itself, it will also determine
                 the width of the Component by mutating its width property to the width of the UICollectionView.
    */
    internal init(width: CGFloat) {
        self.width = width
    }

    /**
     The width of the UICollectionView
    */
    internal let width: CGFloat

    /**
     The AnyComponent array mutated by this ComponentsArray.
    */
    public private(set) var components: [AnyComponent] = []

    /**
     Adds a Component to the array as an AnyComponent instance.
     - Parameters:
        - component: The Component instance to be added to the components array.
    */
    public mutating func add<C: Component>(_ component: C) {
        self.components.append(component.asAnyComponent())
    }

    /**
     Adds Components of the same type to the array.
     - Parameters:
        - components: The Component instances to be added to the components array.
    */
    public mutating func add<Components: Sequence>(_ components: Components) where Components.Element == Component {
        self.components.append(contentsOf: components.map { $0.asAnyComponent()})
    }

    /**
     Adds Components of the same type to the array. Variadic version of the method.
     - Parameters:
        - components: The Component instances to be added to the components array.
     */
    public mutating func add<Components: Component>(_ components: Components...) {
        self.components.append(contentsOf: components.map { $0.asAnyComponent()})
    }

}
