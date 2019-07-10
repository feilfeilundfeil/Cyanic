//
//  ButtonComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import RxSwift
import UIKit

/**
 The ButtonComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with ButtonComponent.
*/
open class ButtonComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer.
     - Parameters:
        - component: The ButtonComponent whose properties define the UI characters of the subviews to be created.
     */
    public init(component: ButtonComponent) {
        let size: CGSize = component.size
        let insets: UIEdgeInsets = component.insets
        let adjustedHeight: CGFloat = size.height + insets.top + insets.bottom

        let serialDisposable: SerialDisposable = SerialDisposable()
        let disposeBag: DisposeBag = DisposeBag()
        serialDisposable.disposed(by: disposeBag)
        self.disposeBag = disposeBag

        let buttonLayout: ButtonLayout<UIButton> = ButtonLayout<UIButton>(
            type: component.type,
            title: component.title,
            image: ButtonLayoutImage.size(CGSize(width: size.width, height: adjustedHeight)),
            font: component.font,
            alignment: component.alignment,
            flexibility: component.flexibility,
            config: { (view: UIButton) -> Void in
                component.configuration(view)
                serialDisposable.disposable = view.rx.controlEvent(UIControl.Event.touchUpInside)
                    .map { () -> UIButton in
                        return view
                    }
                    .bind(onNext: component.onTap)
            }
        )

        let insetLayout: InsetLayout = InsetLayout(
            insets: component.insets,
            flexibility: Flexibility.inflexible,
            viewReuseId: "\(ButtonComponentLayout.identifier)InsetLayout",
            sublayout: buttonLayout
        )

        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height + insets.top + insets.bottom,
            maxHeight: size.height + insets.top + insets.bottom,
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
