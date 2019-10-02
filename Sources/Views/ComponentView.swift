//
//  Cyanic
//  Created by Julio Miguel Alorro on 07.08.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

/**
 ComponentView is a UIView that acts as the root UIView for Cyanic Components.
*/
open class ComponentView: UIView {

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let size = self.layout?.measurement(within: size).size else { return CGSize.zero }
        return size
    }

    open override var intrinsicContentSize: CGSize {
        return self.sizeThatFits(
            CGSize(
                width: self.bounds.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
    }

    public var component: AnyComponent? {
        didSet {
            self.layout = self.component?.layout(width: self.bounds.width)
            self.frame.size = self.intrinsicContentSize

            self.layout?.arrangement(
                origin: self.bounds.origin,
                width: self.bounds.size.width,
                height: self.bounds.size.height
            )
                .makeViews(in: self)
        }
    }

    public private(set) var layout: ComponentLayout?

}
