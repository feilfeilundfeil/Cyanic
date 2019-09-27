//
//  Cyanic
//  Created by Julio Miguel Alorro on 01.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = StaticTextComponent,isFrameworkComponent
/// StaticTextComponentType is a protocol for Component data structures that represent static text.
public protocol StaticTextComponentType: Component {

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

    // sourcery: defaultValue = "0.0"
    /// The lineFragmentPadding for the UITextView. The default value is 0.0.
    var lineFragmentPadding: CGFloat { get set }

    // sourcery: defaultValue = UIEdgeInsets.zero
    // sourcery: skipHashing, skipEquality
    /// The insets for the textContainerInset in the underlying TextViewLayout. Default value is 0.0.
    var insets: UIEdgeInsets { get set }

    // sourcery: defaultValue = Alignment.centerLeading
    // sourcery: skipHashing, skipEquality
    /// The alignment for the underlying TextViewLayout. The default value is Alignment.centerLeading.
    var alignment: Alignment { get set }

    // sourcery: defaultValue = TextViewLayoutDefaults.defaultFlexibility
    // sourcery: skipHashing, skipEquality
    /// The flexibility of the underlying TextViewLayout. The default value is TextViewLayoutDefaults.defaultFlexibility.
    var flexibility: Flexibility { get set }

    // sourcery: defaultValue = "{ _ in }"
    // sourcery: skipHashing, skipEquality
    /// The configuration applied to the UITextView. The default closure does nothing.
    var configuration: (UITextView) -> Void { get set }

}
