//
//  StaticTextComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.SizeLayout
import class LayoutKit.TextViewLayout
import class UIKit.UIFont
import class UIKit.UIColor
import class UIKit.UITextView
import class UIKit.UIView
import enum LayoutKit.Text
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

/**
 The StaticTextComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with StaticTextComponent.
*/
public final class StaticTextComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer.
     - Parameters:
        - component: The StaticTextComponent whose properties define the UI characters of the subviews to be created.
    */
    public init(component: StaticTextComponent) {
        let textLayout: TextViewLayout<UITextView> = TextViewLayout<UITextView>(
            text: component.text,
            font: component.font,
            lineFragmentPadding: component.lineFragmentPadding,
            textContainerInset: component.insets,
            layoutAlignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(StaticTextComponentLayout.identifier)TextView",
            config: { (view: UITextView) -> Void in
                view.backgroundColor = UIColor.clear
                view.isEditable = false
                component.configuration(view)
            }
        )

        let size: CGSize = CGSize(width: component.width, height: CGFloat.greatestFiniteMagnitude)

        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: 0.0,
            maxHeight: size.height,
            viewReuseId: "\(StaticTextComponentLayout.identifier)Size",
            sublayout: textLayout,
            config: {
                $0.backgroundColor = component.backgroundColor
            }
        )
    }
}
