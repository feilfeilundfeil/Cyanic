//
//  ButtonComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.ButtonLayout
import class LayoutKit.ButtonLayoutDefaults
import class LayoutKit.InsetLayout
import class LayoutKit.SizeLayout
import class RxSwift.DisposeBag
import class RxSwift.SerialDisposable
import class UIKit.UIButton
import class UIKit.UIColor
import class UIKit.UIControl
import class UIKit.UIView
import enum LayoutKit.ButtonLayoutImage
import enum LayoutKit.ButtonLayoutType
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets
import struct UIKit.UIControlEvents

/**
 The ButtonComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>. Used to create, size, and arrange the subviews
 associated with ButtonComponent.
*/
open class ButtonComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer
     - Parameters:
        - type: The ButtonLayoutType of the ButtonLayout.
        - title: The title to be displayed on UIButton's titleLabel.
        - backgroundColor: The backgroundColor for the entire content.
        - height: The height of the entire content.
        - contentEdgeInsets: The insets on the UIButton relative to its root UIView.
        - alignment: The alignment of the ButtonLayout and SizeLayout.
        - flexibility: The flexibility of the ButtonLayout and SizeLayout.
        - viewReuseId: The unique id of the ButtonComponent used for debugging.
        - style: The styling to be applied on the UIButton.
        - onTap: The code executed when the UIButton is tapped.
    */
    public init(
        type: ButtonLayoutType,
        title: String,
        backgroundColor: UIColor,
        height: CGFloat,
        contentEdgeInsets: UIEdgeInsets,
        alignment: Alignment,
        flexibility: Flexibility,
        viewReuseId: String,
        style: AlacrityStyle<UIButton>,
        onTap: @escaping () -> Void
    ) {
        let size: CGSize = CGSize(width: Constants.screenWidth, height: height)

        let serialDisposable: SerialDisposable = SerialDisposable()
        let disposeBag: DisposeBag = DisposeBag()
        serialDisposable.disposed(by: disposeBag)
        self.disposeBag = disposeBag

        let buttonLayout: ButtonLayout<UIButton> = ButtonLayout<UIButton>(
            type: type,
            title: title,
            image: ButtonLayoutImage.size(size),
            alignment: alignment,
            flexibility: flexibility,
            config: style
                .modifying { (view: UIButton) -> Void in
                    serialDisposable.disposable = view.rx.controlEvent(UIControl.Event.touchUpInside)
                        .debug(viewReuseId, trimOutput: false)
                        .bind(onNext: onTap)
                }
                .style
        )

        let insetLayout: InsetLayout = InsetLayout(
            insets: contentEdgeInsets,
            viewReuseId: "\(ButtonComponentLayout.identifier)InsetLayout",
            sublayout: buttonLayout
        )

        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            alignment: alignment,
            flexibility: flexibility,
            viewReuseId: "\(ButtonComponentLayout.identifier)SizeLayout",
            sublayout: insetLayout,
            config: { (view: UIView) -> Void in
                view.backgroundColor = backgroundColor
            }
        )
    }

    deinit {
        print("ButtonButtonComponentLayout was deallocated")
    }

    public let disposeBag: DisposeBag
}
