//
//  ButtonComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import RxSwift
import RxCocoa
import Alacrity

open class ButtonComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(
        type: ButtonLayoutType,
        title: String,
        height: CGFloat,
        contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        alignment: Alignment = ButtonLayoutDefaults.defaultAlignment,
        flexibility: Flexibility = ButtonLayoutDefaults.defaultFlexibility,
        viewReuseId: String,
        style: AlacrityStyle<UIButton>,
        onTap: @escaping () -> Void,
        disposeBag: DisposeBag
    ) {
        let size: CGSize = CGSize(width: Constants.screenWidth, height: height)

        let serialDisposable: SerialDisposable = SerialDisposable()
        let bag: DisposeBag = DisposeBag()
        serialDisposable.disposed(by: bag)
        self.disposeBag = bag

        let buttonLayout = ButtonLayout<UIButton>(
            type: type,
            title: title,
            image: ButtonLayoutImage.size(size),
            alignment: alignment,
            flexibility: flexibility,
            viewReuseId: "\(ButtonComponentLayout.identifier)",
            config: style
                .modifying { (view: UIButton) -> Void in
                    serialDisposable.disposable = view.rx.controlEvent(UIControlEvents.touchUpInside)
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
            sublayout: insetLayout
        )
    }

    deinit {
        print("ButtonButtonComponentLayout was deallocated")
    }

    public let disposeBag: DisposeBag
}
