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

        let size: CGSize = CGSize(width: component.width, height: CGFloat.greatestFiniteMagnitude)

        let insetLayout: InsetLayout<UIView> = InsetLayout<UIView>(insets: component.insets, sublayout: labelLayout)

        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            viewReuseId: "\(StaticTextComponentLayout.identifier)Size",
            sublayout: insetLayout,
            config: {
                $0.backgroundColor = component.backgroundColor
            }
        )
    }
}
