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
 The ButtonComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with ButtonComponent.
*/
open class ButtonComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer
     - Parameters:
        - component: ButtonComponent instance.
    */
    public init(component: ButtonComponent) {
        let size: CGSize = CGSize(width: component.width, height: component.height)

        let serialDisposable: SerialDisposable = SerialDisposable()
        let disposeBag: DisposeBag = DisposeBag()
        serialDisposable.disposed(by: disposeBag)
        self.disposeBag = disposeBag

        let buttonLayout: ButtonLayout<UIButton> = ButtonLayout<UIButton>(
            type: component.type,
            title: component.title,
            image: ButtonLayoutImage.size(size),
            alignment: component.alignment,
            flexibility: component.flexibility,
            config: component.style
                .modifying { (view: UIButton) -> Void in
                    serialDisposable.disposable = view.rx.controlEvent(UIControl.Event.touchUpInside)
                        .debug(component.id, trimOutput: false)
                        .bind(onNext: component.onTap)
                }
                .style
        )

        let insetLayout: InsetLayout = InsetLayout(
            insets: component.insets,
            viewReuseId: "\(ButtonComponentLayout.identifier)InsetLayout",
            sublayout: buttonLayout
        )

        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            alignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(ButtonComponentLayout.identifier)SizeLayout",
            sublayout: insetLayout,
            config: { (view: UIView) -> Void in
                view.backgroundColor = component.backgroundColor
            }
        )
    }

    public let disposeBag: DisposeBag
}
