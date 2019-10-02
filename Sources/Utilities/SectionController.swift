//
//  Cyanic
//  Created by Julio Miguel Alorro on 12.04.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics
import RxDataSources

/**
 SectionController represents a section of a UICollectionView/UITableView. It consists of two main properties:

 * The Component that represents the supplementary view (in a UICollectionView) or a header view (in a UITableView) to
   be displayed in that section.
 * The ComponentsController that represents the items/rows to be displayed in that section.

 It is essentially the data source for a section in a UICollectionView/UITableView.
*/
public struct SectionController: AnimatableSectionModelType {

    // MARK: Initializer
    /**
     Initializer.
     - Parameters:
        - width: The width of the UICollectionView/UITableView. SectionController mutates the width property of the
                headerComponent and initializes its ComponentsController instance with it.
    */
    public init(width: CGFloat) {
        self.width = width
        self.componentsController = ComponentsController(width: width)
    }

    public init(original: SectionController, items: [AnyComponent]) {
        self = original
        self.componentsController.components = items
    }

    // MARK: Stored Properties
    /**
     The width of the UICollectionView/UITableView where the components will be displayed.
    */
    public let width: CGFloat

    /**
     The Component representing the header view for the section in the UICollectionView/UITableView.
    */
    public var headerComponent: AnyComponent?

    /**
     The Component representing the footer view for the section in the UICollectionView/UITableView.
     */
    public var footerComponent: AnyComponent?

    /**
     The components for this section of the UICollectionView/UITableView.
    */
    public private(set) var componentsController: ComponentsController

    // MARK: Computed Properties
    public var identity: Int {
        var hasher: Hasher = Hasher()
        hasher.combine(self.headerComponent)
        hasher.combine(self.footerComponent)
        return hasher.finalize()
    }

    public var items: [AnyComponent] {
        return self.componentsController.components
    }

    /**
     The height of all the Components managed by this SectionController.
    */
    public var height: CGFloat {
        let componentsControllerHeight: CGFloat = self.componentsController.height
        let headerHeight: CGFloat = self.headerComponent?
            .layout(width: self.width)
            .measurement(within: CGSize(width: self.width, height: CGFloat.greatestFiniteMagnitude))
            .size
            .height ?? 0.0
        let footerHeight: CGFloat = self.footerComponent?
            .layout(width: self.width)
            .measurement(within: CGSize(width: self.width, height: CGFloat.greatestFiniteMagnitude))
            .size
            .height ?? 0.0
        return componentsControllerHeight + headerHeight + footerHeight
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

public extension SectionController {

    /**
     Represents the two options when adding a Component to a SectionContoller
    */
    enum SupplementaryView {
        /**
         Adds the Component as a header in the UICollectionView/UITableView
        */
        case header

        /**
         Adds the Component as a footer in the UICollectionView/UITableView
        */
        case footer
    }

}
