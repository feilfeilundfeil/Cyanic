//
//  UserInterfaceModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/4/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 The UserInterfaceModel protcol is a workaround protocol to be able to access a Component's layout and cellType without casting it to
 Component (which causes a generic constraint error).
*/
public protocol UserInterfaceModel {

    // sourcery: defaultValue = fatalError()
    // sourcery: isComputed = true
    // sourcery: skipHashing,skipEquality
    /// The LayoutKit related class that will calculate size, location and configuration of the subviews in the ComponentCell
    var layout: ComponentLayout { get }

    // sourcery: defaultValue = ComponentCell.self
    // sourcery: skipHashing,skipEquality
    /// The ComponentCell subclass used as the root view for the subviews.
    var cellType: ComponentCell.Type { get }

}