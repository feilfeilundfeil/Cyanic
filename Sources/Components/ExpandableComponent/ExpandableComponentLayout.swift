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
        - id: The unique identifier used by the ExpandableComponent as a means to map the isExpanded state to the PublishRelay.
        - contentLayout: The Layout that creates, sizes, and arranges the content-specific UI. Excludes the ChevronView.
        - backgroundColor: The backgroundColor of the entire content.
        - height: The height specified for the root UIView.
        - insets: The insets of the entire content including the ChevronView.
        - chevronSize: The size applied to the ChevronView.
        - chevronStyle: The style applied to the ChevronView
        - relay: The PublishRelay that emits the id and isExpanded state of the ExpandableComponent when the UI is tapped.
        - disposeBag: The disposeBag of the ExpandableComponent used to dispose of Rx related subscriptions.
        - isExpanded: The state of the ExpandableComponent used to determine the next Bool value to be emitted by the PublishRelay.
    */
    public init(component: ExpandableComponent) {  // swiftlint:disable:this function_body_length
        let size: CGSize = component.size
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
