//
//  TextViewComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 5/16/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit

/**
 The TextViewComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with TextViewComponent.
 */
public final class TextViewComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer.
     - Parameters:
        - component: The StaticTextComponent whose properties define the UI characters of the subviews to be created.
     */
    public init(component: TextViewComponent) {

        let textLayout: TextViewLayout<UITextView> = TextViewLayout<UITextView>(
            text: Text.unattributed(component.text),
            font: component.font,
            lineFragmentPadding: 0,
            textContainerInset: UIEdgeInsets.zero,
            layoutAlignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(TextViewComponentLayout.identifier)TextView",
            viewClass: component.textViewType,
            config: { (view: UITextView) -> Void in
                view.backgroundColor = component.backgroundColor
                view.isEditable = true
                view.isUserInteractionEnabled = true
                view.isScrollEnabled = true
                component.configuration(view)

                view.delegate = component.delegate
            }
        )

        let insetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
            insets: component.insets,
            sublayout: textLayout
        )

        super.init(
            minWidth: component.width,
            maxWidth: component.width,
            minHeight: component.height,
            maxHeight: component.height,
            viewReuseId: "\(TextViewComponentLayout.identifier)Size",
            sublayout: insetLayout,
            config: {
                $0.backgroundColor = component.backgroundColor
            }
        )
    }
}
