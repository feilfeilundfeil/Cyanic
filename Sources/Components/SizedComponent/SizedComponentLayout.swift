//
//  SizedComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit

/**
 The SizedComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with SizedComponent.
*/
public final class SizedComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(component: SizedComponent) {
        let insets: UIEdgeInsets = component.insets
        let sizeLayout: SizeLayout<UIView> = SizeLayout<UIView>(
            minWidth: component.width,
            maxWidth: component.width,
            minHeight: component.height,
            maxHeight: component.height,
            alignment: component.alignment,
            viewReuseId: "\(SizedComponentLayout.identifier)ViewSize",
            viewClass: component.viewClass,
            sublayout: nil,
            config: component.configuration
        )

        let insetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
            insets: insets,
            flexibility: Flexibility.inflexible,
            viewReuseId: "\(SizedComponentLayout.identifier)Inset",
            sublayout: sizeLayout
        )

        super.init(
            minWidth: component.width,
            maxWidth: component.width,
            minHeight: component.height,
            maxHeight: component.height,
            alignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(SizedComponentLayout.identifier)Size",
            sublayout: insetLayout,
            config: { (view: UIView) -> Void in
                view.backgroundColor = component.backgroundColor
            }
        )
    }

}
