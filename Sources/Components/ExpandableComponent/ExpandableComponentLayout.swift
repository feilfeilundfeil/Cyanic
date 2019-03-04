//
//  ExpandableComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class FFUFWidgets.ChevronView
import class RxSwift.DisposeBag
import class RxSwift.SerialDisposable
import class LayoutKit.InsetLayout
import class LayoutKit.SizeLayout
import class LayoutKit.StackLayout
import class UIKit.UIColor
import class UIKit.UITapGestureRecognizer
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
 The ExpandableComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>
*/
public final class ExpandableComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(
        id: String,
        contentLayout: ExpandableContentLayout,
        backgroundColor: UIColor,
        height: CGFloat,
        insets: UIEdgeInsets,
        alignment: Alignment,
        chevronSize: CGSize,
        chevronStyle: AlacrityStyle<ChevronView>,
        relay: PublishRelay<(String, Bool)>,
        disposeBag: DisposeBag,
        isExpanded: Bool
    ) {
        let size: CGSize = CGSize(width: Constants.screenWidth, height: height)

        let contentInsetLayout: InsetLayout<UIView> = InsetLayout(
            insets: UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: 0.0),
            sublayout: contentLayout
        )

        let flexibleLayout: SizeLayout<UIView> = SizeLayout<UIView>(
            size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
            alignment: Alignment.center,
            flexibility: Flexibility.flexible,
            viewReuseId: "\(ExpandableComponentLayout.identifier)flexibleSpace"
        )

        let chevronLayout: SizeLayout<ChevronView> = SizeLayout<ChevronView>(
            size: chevronSize,
            alignment: Alignment.center,
            flexibility: Flexibility.inflexible,
            viewReuseId: "\(ExpandableComponentLayout.identifier)Chevron",
            config:  chevronStyle
                .modifying(with: { (view: ChevronView) -> Void in
                    switch isExpanded {
                        case true: view.direction = .up
                        case false: view.direction = .down
                    }
                })
                .style
        )

        let chevronInsetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
            insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: insets.right),
            alignment: alignment,
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

        let serial: SerialDisposable = SerialDisposable()
        serial.disposed(by: disposeBag)
        self.disposeBag = disposeBag
        super.init(
            minWidth: size.width, maxWidth: size.width,
            minHeight: size.height, maxHeight: size.height,
            viewReuseId: ExpandableComponentLayout.identifier,
            sublayout: stackLayout,
            config: { (view: UIView) -> Void in
                view.backgroundColor = backgroundColor
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)

                serial.disposable = tap.rx.event
                    .map { (_: UITapGestureRecognizer) -> (String, Bool) in
                        return (id, !isExpanded)
                    }
                    .debug()
                    .subscribe(
                        onNext: { relay.accept($0) },
                        onDisposed: { view.removeGestureRecognizer(tap) }
                    )

                view.addGestureRecognizer(tap)
            }
        )
    }

    public let disposeBag: DisposeBag
}
