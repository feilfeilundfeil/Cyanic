//
//  Component.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.DisposeBag
import protocol Differentiator.IdentifiableType
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize

/**
 Component is the data model representation of the UICollectionViewCell/UITableViewCell rendered on a ComponentViewController.
 A Component should be an immutable struct and it should contain UI specific characteristics related to the content
 that should be displayed in a CollectionComponentCell/TableComponentCell.

 A Component is what is used to diff between two collections by RxDataSources.
*/
public protocol Component: IdentifiableType, Copyable, UserInterfaceModel, CustomStringConvertible where Identity == Self {

    /// The unique id of the Component. This is mutable because structs are the only data structure
    /// that should conform to Component this allows deep copying of Component (assuming all the other properties are
    /// value types) via the Copyable protocol's copy method.
    var id: String { get set }

    // sourcery: defaultValue = "0.0"
    /// The width of the UICollectionViewCell/UITableViewCell that hosts the content created by the Component.
    /// This should not be modified because it will be set by the framework. Mutating this won't do anything.
    var width: CGFloat { get set }

}

public extension Component {

    // sourcery: isExcluded
    // sourcery: skipHashing, skipEquality
    /// Since Component has a generic constraint. AnyComponent is used as a type erased wrapper around it
    /// so Components can be grouped in Collections.
    var asAnyComponent: AnyComponent {
        return AnyComponent(self)
    }

}

extension Component {

    // sourcery: isExcluded
    // sourcery: skipHashing, skipEquality
    public var description: String {
        return self.id
    }

}

public protocol StaticHeightComponent: Component {

    // sourcery: defaultValue = "44.0"
    /// The height of the UICollectionViewCell/UITableViewCell that hosts the content created by the Component.
    /// The default value is 44.0
    var height: CGFloat { get set }

}

public extension StaticHeightComponent {

    // sourcery: isExcluded
    // sourcery: skipHashing, skipEquality
    /// The size of the StaticHeightComponent.
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }

}
