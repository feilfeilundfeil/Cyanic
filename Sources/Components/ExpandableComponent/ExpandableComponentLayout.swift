//
//  ExpandableComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class FFUFWidgets.ChevronView
import class RxSwift.DisposeBag
import class LayoutKit.InsetLayout
import class LayoutKit.SizeLayout
import class LayoutKit.StackLayout
import class UIKit.UIColor
import class UIKit.UIView
import class RxCocoa.PublishRelay
import enum LayoutKit.Axis
import enum LayoutKit.StackLayoutDistribution
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
public final class ExpandableComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer
     - Parameters:
        - component: ExpandableComponent instance. Properties from this instance are used to configure the view's
                     appearance and determine the size of the content.
    */
    public init(component: ExpandableComponent) {  // swiftlint:disable:this function_body_length
        let size: CGSize = CGSize(width: component.width, height: component.height)
        let insets: UIEdgeInsets = component.insets
        let contentInsetLayout: InsetLayout<UIView> = InsetLayout(
            insets: UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: 0.0),
            sublayout: component.contentLayout
        )

        let flexibleLayout: SizeLayout<UIView> = SizeLayout<UIView>(
            size: CGSize(width: size.width, height: size.height),
            alignment: Alignment.center,
            flexibility: Flexibility.flexible,
            viewReuseId: "\(ExpandableComponentLayout.identifier)flexibleSpace"
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

        let stackLayout: StackLayout<UIView> = StackLayout<UIView>(
            axis: Axis.horizontal,
            spacing: 0.0,
            distribution: StackLayoutDistribution.fillFlexing,
            alignment: Alignment.fillLeading,
            viewReuseId: "\(ExpandableComponentLayout.identifier)HorizontalStack",
            sublayouts: [contentInsetLayout, flexibleLayout, chevronInsetLayout]
        )

        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            viewReuseId: ExpandableComponentLayout.identifier,
            sublayout: stackLayout,
            config: component.style
                .modifying { (view: UIView) -> Void in
                    view.backgroundColor = component.backgroundColor
                }
                .style
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
