//
//  Cyanic
//  Created by Julio Miguel Alorro on 07.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension,RequiredVariables
// sourcery: ComponentLayout = "ChildVCComponentLayout"
/// A ChildVCComponent is a Component that represents a child UIViewController presented on a UICollectionViewCell.
public struct ChildVCComponent: ChildVCComponentType {

// sourcery:inline:auto:ChildVCComponent.AutoGenerateComponent
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the ChildVCComponent.
    */
    public init(id: String) {
        self.id = id
    }

    // sourcery: skipHashing, skipEquality
    public lazy var childVC: UIViewController & CyanicChildVCType = InvalidChildComponentVC()

    // sourcery: skipHashing, skipEquality
    public weak var parentVC: UIViewController?

    // sourcery: skipHashing, skipEquality
    public var configuration: (UIViewController) -> Void

    public var id: String

    public var width: CGFloat = 0.0

    public var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality
    public var layout: ComponentLayout { return ChildVCComponentLayout(component: self) }

    public var identity: ChildVCComponent { return self }
// sourcery:end
}
