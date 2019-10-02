//
//  Cyanic
//  Created by Julio Miguel Alorro on 25.08.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = StaticLabelComponentLayout
/// A StaticLabelComponent is a Component that represents a UICollectionViewCell/UITableViewCell that displays a
/// static text on a UILabel in its contentView.
public struct StaticLabelComponent: StaticLabelComponentType {

// sourcery:inline:auto:StaticLabelComponent.AutoGenerateComponent
    /**
     Work around Initializer because memberwise initializers are all or nothing
     - Parameters:
         - id: The unique identifier of the StaticLabelComponent.
    */
    public init(id: String) {
        self.id = id
    }

    public var id: String

    public var text: Text = Text.unattributed("")

    public var font: UIFont = UIFont.systemFont(ofSize: 13.0)

    public var backgroundColor: UIColor = UIColor.clear

    public var numberOfLines: Int = 0

    public var lineBreakMode: NSLineBreakMode = NSLineBreakMode.byTruncatingTail

    // sourcery: skipHashing, skipEquality
    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    // sourcery: skipHashing, skipEquality
    public var alignment: Alignment = Alignment.centerLeading

    // sourcery: skipHashing, skipEquality
    public var flexibility: Flexibility = Flexibility.flexible

    // sourcery: skipHashing, skipEquality
    public var configuration: (UILabel) -> Void = { _ in }

    public var identity: StaticLabelComponent { return self }

    public func layout(width: CGFloat) -> ComponentLayout {
        return StaticLabelComponentLayout(component: self, width: width)
    }
// sourcery:end
}
