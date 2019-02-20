//
//  ComponentsArray.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/18/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation

/**
 ComponentsArray is a helper struct that transforms Component instances into AnyComponent instances and adds it to an array.
*/
public struct ComponentsArray {

    public private(set) var components: [AnyComponent] = []

    public mutating func add<C: Component>(_ component: C) {
        self.components.append(component.asAnyComponent())
    }

    public mutating func add<Components: Collection>(_ components: Components) where Components.Element == Component {
        self.components.append(contentsOf: components.map { $0.asAnyComponent()})
    }

    public mutating func add<Components: Component>(_ components: Components...) {
        self.components.append(contentsOf: components.map { $0.asAnyComponent()})
    }

}
