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
 Component is the data model representation of the UICollectionViewCell to be rendered on the BaseCollectionVC.
 Information it contains:
 - The ComponentLayout, which defines the following characteristics of the subviews in the the ConfigurableCell
    - the sizing
    - the location
    - UI properties such as backgroundColor
 - The subclass of ConfigurableCell it will render
 - The DisposeBag to deallocate any subscriptions on the Rx side.

*/
public protocol Component: IdentifiableType where Identity == Self {

    var layout: ComponentLayout { get }

    var cellType: ConfigurableCell.Type { get }

    var isShown: () -> Bool { get }

    func isEqual(to other: Self) -> Bool

}

public extension Component {

    func asAnyComponent() -> AnyComponent {
        return AnyComponent(self)
    }

}




