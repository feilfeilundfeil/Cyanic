//
//  ExpandableComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/15/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import Alacrity
import Foundation
import LayoutKit
import RxCocoa
import RxSwift

/**
 The ExpandableComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>
*/
public final class ExpandableComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(
        id: String,
        text: Text,
        font: UIFont,
        backgroundColor: UIColor,
        height: CGFloat,
        insets: UIEdgeInsets,
        alignment: Alignment,
        labelStyle: AlacrityStyle<UILabel>,
        relay: PublishRelay<(String, Bool)>,
        disposeBag: DisposeBag,
        isExpanded: Bool
    ) {
        let size: CGSize = CGSize(width: Constants.screenWidth, height: height)

        let labelLayout: LabelLayout<UILabel> = LabelLayout<UILabel>(
            text: text,
            font: font,
            numberOfLines: 0,
            alignment: LabelLayoutDefaults.defaultAlignment,
            flexibility: LabelLayoutDefaults.defaultFlexibility,
            viewReuseId: "\(ExpandableComponentLayout.identifier)Label",
            config: labelStyle.style
        )

        let insetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
            insets: insets,
            alignment: alignment,
            viewReuseId: "\(ExpandableComponentLayout.identifier)Inset",
            sublayout: labelLayout
        )

        let serial: SerialDisposable = SerialDisposable()
        serial.disposed(by: disposeBag)
        self.disposeBag = disposeBag
        super.init(
            minWidth: size.width, maxWidth: size.width,
            minHeight: size.height, maxHeight: size.height,
            viewReuseId: ExpandableComponentLayout.identifier,
            sublayout: insetLayout,
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
