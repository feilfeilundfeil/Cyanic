//
//  Cyanic
//  Created by Julio Miguel Alorro on 25.08.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent,
// sourcery: Component = StaticLabelComponent,isFrameworkComponent
/// A StaticLabelComponentType is a protocol adopted by Components that represent a UICollectionViewCell/UITableViewCell that
/// displays static text on a UILabel in its contentView.
public protocol StaticLabelComponentType: Component {

    // sourcery: defaultValue = "Text.unattributed("")"
    /// The text to be displayed on the Component as either a String or NSAttributedString. The default
    /// value is Text.unattributed("").
    var text: Text { get set }

    // sourcery: defaultValue = "UIFont.systemFont(ofSize: 13.0)"
    /// The font of the Text. The default value is UIFont.systemFont(ofSize: 13.0).
    var font: UIFont { get set }

    // sourcery: defaultValue = UIColor.clear
    /// The backgroundColor for the entire content. The default value is UIColor.clear.
    var backgroundColor: UIColor { get set }

    // sourcery: defaultValue = "0"
    /// The numberOfLines for the UILabel. The default value is 0.
    var numberOfLines: Int { get set }

    // sourcery: defaultValue = "NSLineBreakMode.byTruncatingTail"
    /// The lineBreakMode for the UILabel. The default value is NSLineBreakMode.byTruncatingTail.
    var lineBreakMode: NSLineBreakMode { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets for the content. Default value is 0.0.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = Alignment.centerLeading
    // sourcery: skipHashing, skipEquality
    /// The alignment for the underlying LabelLayout. The default value is Alignment.centerLeading.
    var alignment: Alignment { get set }

    // sourcery: defaultValue = "Flexibility.flexible"
    // sourcery: skipHashing, skipEquality
    /// The flexibility of the underlying LabelLayout. The default value is Flexible.flexible.
    var flexibility: Flexibility { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The configuration applied to the UILabel. The default closure does nothing.
    var configuration: (UILabel) -> Void { get set }

}
