//
//  Cyanic
//  Created by Julio Miguel Alorro on 25.08.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

/**
 The StaticLabelComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Arranges the content of the StaticLabelComponent.
 */
public final class StaticLabelComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(component: StaticLabelComponent) {
        let labelLayout: LabelLayout<UILabel> = LabelLayout<UILabel>(
            text: component.text,
            font: component.font,
            numberOfLines: component.numberOfLines,
            lineBreakMode: component.lineBreakMode,
            alignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(StaticLabelComponentLayout.identifier)Label",
            config: component.configuration
        )

        let insetLayout: InsetLayout<UIView> = InsetLayout<UIView>(insets: component.insets, sublayout: labelLayout)
        let height: CGFloat = insetLayout
            .measurement(within: CGSize(width: component.width, height: CGFloat.greatestFiniteMagnitude))
            .size
            .height

        let width: CGFloat = component.width

        super.init(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
            viewReuseId: "\(StaticTextComponentLayout.identifier)Size",
            sublayout: insetLayout,
            config: {
                $0.backgroundColor = component.backgroundColor
            }
        )
    }
}
