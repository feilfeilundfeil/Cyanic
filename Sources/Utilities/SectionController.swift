//
//  SectionController.swift
//  Example
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize

/**
 SectionController represents a section of a UICollectionView/UITableView. It consists of two main properties:

 * The Component that represents the supplementary view (in a UICollectionView) or a header view (in a UITableView) to
   be displayed in that section.
 * The ComponentsController that represents the items/rows to be displayed in that section.

 It is essentially the data source for a section in a UICollectionView/UITableView.
*/
public struct SectionController {

    // MARK: Initializer
    /**
     Initializer.
     - Parameters:
        - size: The size of the UICollectionView/UITableView. SectionController mutates the width property of the
                sectionComponent and initializes its ComponentsController instance with it.
    */
    public init(size: CGSize) {
        self.size = size
        self.componentsController = ComponentsController(size: size)
    }

    // MARK: Stored Properties
    /**
     The CGSize of the UICollectionView/UITableView where the components will be displayed.
    */
    public let size: CGSize

    /**
     The Component representing the section header in the UICollectionView/UITableView.
    */
    public var sectionComponent: AnyComponent! // swiftlint:disable:this implicitly_unwrapped_optional

    /**
     The components for this section of the UICollectionView/UITableView.
    */
    public private(set) var componentsController: ComponentsController

    // MARK: Computed Properties
    /**
     The width of the UICollectionView/UITableView where the components will be displayed.
    */
    public var width: CGFloat {
        return self.size.width
    }

    /**
     The height of the UICollectionView/UITableView where the components will be displayed.
    */
    public var height: CGFloat {
        return self.size.height
    }

    /**
     This method mutates the ComponentsController of this SectionController. Use this method to configure the
     ComponentController.
     - Parameters:
        - configuration: The closure contains the configuration logic to mutate the ComponentsController
        - componentsController: This SectionController's ComponentsController instance.
    */
    public mutating func buildComponents(_ configuration: (_ componentsController: inout ComponentsController) -> Void) {
        configuration(&self.componentsController)
    }

}
