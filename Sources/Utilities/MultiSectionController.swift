//
//  MultiSectionController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize

/**
 MultiSectionController represents the entire data source of a UICollectionView/UITableView. It manages an Array of
 SectionControllers.
*/
public struct MultiSectionController {

    // MARK: Initializer
    /**
     Initializer.
     - Parameters:
        - size: The size of the UICollectionView/UITableView. MultiSectionController initializes its SectionController
                instances with it.
    */
    public init(size: CGSize) {
        self.size = size
    }

    // MARK: Stored Properties
    /**
     The CGSize of the UICollectionView where the components will be displayed.
    */
    public let size: CGSize

    /**
     The SectionControllers representing the sections in the UICollectionView.
    */
    public private(set) var sectionControllers: [SectionController] = []

    // MARK: Computed Properties
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
     Creates a SectionController instance and configures its properties with the given closure. You must provide a
     sectionComponent, otherwise it will force a fatalError.
     - Parameters:
         - configuration: The closure that mutates the mutable ButtonComponent.
         - sectionController: The SectionController instance to be mutated/configured.
     - Returns:
        SectionController
    */
    @discardableResult
    public mutating func sectionController(with configuration: (_ sectionController: inout SectionController) -> Void) -> SectionController {
        var sectionController: SectionController = SectionController(size: self.size)
        configuration(&sectionController)
        guard sectionController.sectionComponent != nil else { fatalError("Missing a sectionComponent!")}
        self.sectionControllers.append(sectionController)
        return sectionController
    }

}
