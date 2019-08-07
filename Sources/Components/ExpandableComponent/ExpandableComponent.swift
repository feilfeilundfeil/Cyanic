//
//  Cyanic
//  Created by Julio Miguel Alorro on 15.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension,RequiredVariables
// sourcery: ComponentLayout = ExpandableComponentLayout
/// An ExpandableComponent is a Component that represents an expandable UI element that shows/hides other UI elements
/// grouped with it.
public struct ExpandableComponent: ExpandableComponentType, Selectable {

// sourcery:inline:auto:ExpandableComponent.AutoGenerateComponent
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the ExpandableComponent.
    */
    public init(id: String) {
        self.id = id
    }

    public var id: String

    public var width: CGFloat = 0.0

    public var contentLayout: ExpandableContentLayout = EmptyContentLayout()

    public var backgroundColor: UIColor = UIColor.clear

    // sourcery: skipHashing, skipEquality
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    // sourcery: skipHashing, skipEquality
    public var accessoryViewType: UIView.Type = UIView.self

    public var accessoryViewSize: CGSize = CGSize(width: 12.0, height: 12.0)

    // sourcery: skipHashing, skipEquality
    public var accessoryViewConfiguration: (UIView) -> Void = { _ in }

    // sourcery: skipHashing, skipEquality
    public var configuration: (UIView) -> Void = { _ in }

    public var isExpanded: Bool = false

    // sourcery: skipHashing, skipEquality
    public var setExpandableState: (String, Bool) -> Void = { (_: String, _: Bool) -> Void in
        fatalError("This default closure must be replaced!")
    }

    // sourcery: skipHashing, skipEquality
    public var dividerLine: DividerLine?

    public var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality
    public var layout: ComponentLayout { return ExpandableComponentLayout(component: self) }

    public var identity: ExpandableComponent { return self }
// sourcery:end

    public func onSelect() {
        self.setExpandableState(self.id, !self.isExpanded)
    }
}
