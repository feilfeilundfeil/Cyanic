//
//  Cyanic
//  Created by Julio Miguel Alorro on 12.04.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics

/**
 MultiSectionController represents the entire data source of a UICollectionView/UITableView. It manages an Array of
 SectionControllers.
*/
public struct MultiSectionController {

    // MARK: Initializer
    /**
     Initializer.
     - Parameters:
        - width: The width of the UICollectionView/UITableView. MultiSectionController initializes its SectionController
                instances with it.
    */
    public init(width: CGFloat) {
        self.width = width
    }

    // MARK: Stored Properties
    /**
     The CGFloat of the UICollectionView where the components will be displayed.
    */
    public let width: CGFloat

    /**
     The SectionControllers representing the sections in the UICollectionView.
    */
    public private(set) var sectionControllers: [SectionController] = []

    // MARK: Computed Properties
    /**
     The height of the UICollectionView where the components will be displayed.
    */
    public var height: CGFloat {
        return self.sectionControllers.reduce(into: 0.0, { (currentHeight: inout CGFloat, section: SectionController) -> Void in
            currentHeight += section.height
        })
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
        var sectionController: SectionController = SectionController(width: self.width)
        configuration(&sectionController)
        guard sectionController.headerComponent != nil else { fatalError("Missing a sectionComponent!")}
        self.sectionControllers.append(sectionController)
        return sectionController
    }

}
