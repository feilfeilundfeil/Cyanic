//
//  Cyanic
//  Created by Julio Miguel Alorro on 27.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = ButtonComponent,isFrameworkComponent
/// ButtonComponentType is a protocol for Components that represents a UIButton.
public protocol ButtonComponentType: StaticHeightComponent {

    // sourcery: defaultValue = ButtonLayoutType.system
    /// The ButtonLayoutType which maps to UIButton.ButtonType. The default value is .system.
    var type: ButtonLayoutType { get set }

    // sourcery: defaultValue = """"
    /// The title displayed as text on the UIButton. The default value is an empty string: "".
    var title: String { get set }

    // sourcery: defaultValue = "UIFont.systemFont(ofSize: 15.0)"
    /// The title displayed as text on the UIButton. The default value is an empty string: "".
    var font: UIFont { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets on the UIButton relative to its root UIView. This is NOT the insets on the content inside the
    /// UIButton. The default value is UIEdgeInsets.zero.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The background color of the UICollectionView's contentView. The default value is UIColor.clear.
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = ButtonLayoutDefaults.defaultAlignment
    // sourcery: skipHashing, skipEquality
    /// The alignment of the underlying ButtonLayout and SizeLayout. The default value is
    /// ButtonLayoutDefaults.defaultAlignment.
    var alignment: Alignment { get set }

    // sourcery: defaultValue = ButtonLayoutDefaults.defaultFlexibility
    // sourcery: skipHashing, skipEquality
    /// The flexibility of the underlying ButotnLayout and SizeLayout. The default value is
    /// ButtonLayoutDefaults.defaultFlexibility.
    var flexibility: Flexibility { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The styling applied to the UIButton. The default value is an empty style.
    var configuration: (UIButton) -> Void { get set }

    // sourcery: defaultValue = { _ in print("Hello World \(#file)") }
    // sourcery: skipHashing, skipEquality
    /// The code executed when the UIButton is tapped.
    var onTap: (UIButton) -> Void { get set }

}
