//
//  ComponentsArray.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/18/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 ComponentsArray is a helper struct that transforms Component instances into AnyComponent instances and adds it to an array.
*/
public struct ComponentsArray {

    /**
     The AnyComponent array mutated by this ComponentsArray.
    */
    public private(set) var components: [AnyComponent] = []

    /**
     Adds a Component to the array as an AnyComponent instance.
     - parameters:
        - component: The Component instance to be added to the components array.
    */
    public mutating func add<C: Component>(_ component: C) {
        self.components.append(component.asAnyComponent())
    }

    /**
     Adds Components of the same type to the array.
     - parameters:
        - components: The Component instances to be added to the components array.
    */
    public mutating func add<Components: Sequence>(_ components: Components) where Components.Element == Component {
        self.components.append(contentsOf: components.map { $0.asAnyComponent()})
    }

    /**
     Adds Components of the same type to the array. Variadic version of the method.
     - parameters:
        - components: The Component instances to be added to the components array.
     */
    public mutating func add<Components: Component>(_ components: Components...) {
        self.components.append(contentsOf: components.map { $0.asAnyComponent()})
    }

}
