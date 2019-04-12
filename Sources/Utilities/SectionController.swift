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
 A SectionController is a helper struct that represents a section and its items in a UICollectionView.
*/
public struct SectionController {

    // MARK: Initializer
    public init(size: CGSize) {
        self.size = size
        self.components = ComponentsController(size: size)
    }

    // MARK: Stored Properties
    /**
     The CGSize of the UICollectionView where the components will be displayed.
    */
    public let size: CGSize

    /**
     The Component representing the section header in the UICollectionView.
    */
    public var sectionComponent: AnyComponent!

    /**
     The components for this section of the UICollectionView.
     */
    public private(set) var components: ComponentsController

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

    public mutating func buildComponents(_ block: (_ components: inout ComponentsController) -> Void) {
        block(&self.components)
    }

}
