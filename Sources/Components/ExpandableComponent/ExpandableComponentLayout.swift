//
//  ExpandableComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class CommonWidgets.ChevronView
import class LayoutKit.InsetLayout
import class LayoutKit.OverlayLayout
import class LayoutKit.SizeLayout
import class LayoutKit.StackLayout
import class UIKit.UIColor
import class UIKit.UIView
import enum LayoutKit.Axis
import enum LayoutKit.StackLayoutDistribution
import protocol LayoutKit.Layout
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

/**
 The ExpandableComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with ExpandableComponent.
*/
public final class ExpandableComponentLayout: OverlayLayout<UIView>, ComponentLayout {

    /**
     Initializer
     - Parameters:
        - component: ExpandableComponent instance. Properties from this instance are used to configure the view's
                     appearance and determine the size of the content.
    */
    public init(component: ExpandableComponent) {  // swiftlint:disable:this function_body_length
        let size: CGSize = component.size
        let insets: UIEdgeInsets = component.insets
        let contentInsetLayout: InsetLayout<UIView> = InsetLayout(
            insets: UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: 0.0),
            viewReuseId: "\(ExpandableComponentLayout.identifier)RealContentInset",
            sublayout: component.contentLayout
        )

        let chevronLayout: SizeLayout<ChevronView> = SizeLayout<ChevronView>(
            size: component.chevronSize,
            alignment: Alignment.center,
            flexibility: Flexibility.inflexible,
            viewReuseId: "\(ExpandableComponentLayout.identifier)Chevron",
            config: component.chevronStyle
                .modifying { (view: ChevronView) -> Void in
                    switch component.isExpanded {
                        case true: view.direction = .up
                        case false: view.direction = .down
                    }
                }
                .style
        )

        let chevronInsetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
            insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: insets.right),
            alignment: Alignment.center,
            flexibility: chevronLayout.flexibility,
            viewReuseId: "\(ExpandableComponentLayout.identifier)ChevronInset",
            sublayout: chevronLayout
        )

        let adjustedSize: CGSize = CGSize(
            width: size.width - insets.left - insets.right,
            height: component.height - insets.top - insets.bottom
        )

        let contentWidth: CGFloat = contentInsetLayout.measurement(within: adjustedSize).size.width
        let chevronWidth: CGFloat = chevronInsetLayout.measurement(within: adjustedSize).size.width

        let spacing: CGFloat = size.width - contentWidth - chevronWidth

        let horizontalStack: StackLayout<UIView> = StackLayout<UIView>(
            axis: Axis.horizontal,
            spacing: spacing,
            distribution: StackLayoutDistribution.fillEqualSpacing,
            alignment: Alignment.fillLeading,
            flexibility: Flexibility.flexible,
            viewReuseId: "\(ExpandableComponentLayout.identifier)HorizontalStack",
            sublayouts: [contentInsetLayout, chevronInsetLayout]
        )

        let sizeLayout: SizeLayout<UIView> = SizeLayout<UIView>(
            minWidth: component.width,
            maxWidth: component.width,
            minHeight: component.height,
            maxHeight: component.height,
            flexibility: Flexibility.inflexible,
            viewReuseId: "\(ExpandableComponentLayout.identifier)SizeLayout",
            sublayout: horizontalStack
        )

        var overlayLayouts: [Layout] = []

        if let dividerLine = component.dividerLine {

            let sizeLayout: SizeLayout<UIView> = SizeLayout<UIView>(
                minWidth: component.width - dividerLine.insets.left - dividerLine.insets.right,
                maxWidth: component.width,
                minHeight: dividerLine.height,
                maxHeight: dividerLine.height,
                alignment: Alignment.bottomCenter,
                flexibility: Flexibility.inflexible,
                viewReuseId: "dividerLine",
                sublayout: nil,
                config: { (view: UIView) -> Void in
                    view.backgroundColor = dividerLine.backgroundColor
                }
            )

            let dividerLineInsetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
                insets: dividerLine.insets,
                sublayout: sizeLayout
            )

            overlayLayouts.append(dividerLineInsetLayout)
        }

        super.init(
            primaryLayouts: [sizeLayout],
            backgroundLayouts: [],
            overlayLayouts: overlayLayouts,
            alignment: Alignment.centerLeading,
            flexibility: Flexibility.flexible,
            viewReuseId: ExpandableComponentLayout.identifier,
            config: component.style
                .modifying { (view: UIView) -> Void in
                    view.backgroundColor = component.backgroundColor
                }
                .style
        )
    }
}
