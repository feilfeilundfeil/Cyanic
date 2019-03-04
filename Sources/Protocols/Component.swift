//
//  Component.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.DisposeBag
import protocol Differentiator.IdentifiableType

/**
 Component is the data model representation of the UICollectionViewCell to be rendered on the BaseComponentVC.
 A Component should be an immutable struct and it should contain UI specific characteristics related to the content
 that should be displayed in the ComponentCell.

 A Component is what is used to diff between two collections by RxDataSources.
*/
public protocol Component: IdentifiableType, Changeable, UserInterfaceModel where Identity == Self {

    /// The unique id of the Component. This is mutable because structs are the only data structure that should conform to Component
    /// this allows deep copying of Component structs via Copyable protocol
    var id: String { get set }

}

public extension Component {

    /**
     Since Component has a generic constraint. AnyComponent is used as a type erased wrapper around it so Components can be grouped in Collections.
     - Returns: This instance as an AnyComponent.
    */
    func asAnyComponent() -> AnyComponent {
        return AnyComponent(self)
    }

}




