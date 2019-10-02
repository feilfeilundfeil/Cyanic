//
//  Cyanic
//  Created by Julio Miguel Alorro on 07.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics
import RxSwift
import Differentiator

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
