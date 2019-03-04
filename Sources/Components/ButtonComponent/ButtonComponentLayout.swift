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

open class ButtonComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(
        type: ButtonLayoutType,
        title: String,
        backgroundColor: UIColor,
        height: CGFloat,
        contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        alignment: Alignment = ButtonLayoutDefaults.defaultAlignment,
        flexibility: Flexibility = ButtonLayoutDefaults.defaultFlexibility,
        viewReuseId: String,
        style: AlacrityStyle<UIButton>,
        onTap: @escaping () -> Void
    ) {
        let size: CGSize = CGSize(width: Constants.screenWidth, height: height)

        let serialDisposable: SerialDisposable = SerialDisposable()
        let disposeBag: DisposeBag = DisposeBag()
        serialDisposable.disposed(by: disposeBag)
        self.disposeBag = disposeBag

        let buttonLayout = ButtonLayout<UIButton>(
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
            minWidth: size.width, maxWidth: size.width,
            minHeight: size.height, maxHeight: size.height,
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
