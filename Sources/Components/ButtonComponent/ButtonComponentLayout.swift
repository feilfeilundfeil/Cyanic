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
        onTap: @escaping () -> Void
    ) {
        let size: CGSize = CGSize(width: Constants.screenWidth, height: height)
        let disposeBag: DisposeBag = DisposeBag()
        self.disposeBag = disposeBag

        let buttonLayout = ButtonLayout<UIButton>(
            type: type,
            title: title,
            image: ButtonLayoutImage.size(size),
            alignment: alignment,
            flexibility: flexibility,
            viewReuseId: viewReuseId,
            config: style
                .modifying { (view: UIButton) -> Void in
                    view.rx.controlEvent(UIControlEvents.touchUpInside)
                        .bind(onNext: onTap)
                        .disposed(by: disposeBag)
                }
                .style
        )

        let insetLayout: InsetLayout = InsetLayout(
            insets: contentEdgeInsets,
            viewReuseId: "\(viewReuseId)InsetLayout",
            sublayout: buttonLayout
        )

        super.init(
            minWidth: size.width, maxWidth: size.width,
            minHeight: size.height, maxHeight: size.height,
            alignment: alignment,
            flexibility: flexibility,
            viewReuseId: "\(viewReuseId)SizeLayout",
            sublayout: insetLayout
        )
    }

    public let disposeBag: DisposeBag
}
