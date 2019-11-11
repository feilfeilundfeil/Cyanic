//
//  Cyanic
//  Created by Julio Miguel Alorro on 07.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = ChildVCComponent,isFrameworkComponent
/// ChildVCComponentType is a protocol for Component data structures that want to show other UIViewControllers as a
/// child UIViewController to the SingleSectionComponentViewController.
public protocol ChildVCComponentType: StaticHeightComponent {

    // sourcery: skipHashing, skipEquality, isLazy
    // sourcery: defaultValue = "InvalidChildComponentVC()"
    /// The child UIViewController instance to be shown on the UICollectionView. This must be a lazy property otherwise you
    /// may run into threading issues.
    var childVC: UIViewController & CyanicChildVCType { mutating get set }

    // sourcery: skipHashing, skipEquality
    // sourcery: isWeak
    /// The parent UIViewController instance of the child VC. It is usually the BaseComponentVC.
    var parentVC: UIViewController? { get set }

    // sourcery: skipHashing, skipEquality
    // sourcery: defaultValue = "{ _ in }"
    /// Additional configuration of the childVC. Called in the Layout's config closure
    var configuration: (UIViewController) -> Void { get set }

}

public extension ChildVCComponentType {

    /// The class name of the childVC.
    // sourcery: isExcluded
    var name: String {
        var component: Self = self
        return String(describing: Mirror(reflecting: component.childVC).subjectType)
    }

}

public extension ChildVCComponentType {

    // sourcery: isExcluded
    var description: String {
        return self.name
    }

}
