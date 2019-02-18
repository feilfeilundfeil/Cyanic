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

public final class ExpandableComponentLayout<Key>: SizeLayout<UIView>, ComponentLayout {

    public init(
        id: Key,
        text: Text,
        font: UIFont,
        height: CGFloat,
        insets: UIEdgeInsets,
        alignment: Alignment,
        labelStyle: AlacrityStyle<UILabel>,
        relay: BehaviorRelay<(Key, Bool)>,
        disposeBag: DisposeBag
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

                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)

                serial.disposable = tap.rx.event
                    .map { (_: UITapGestureRecognizer) -> (Key, Bool) in
                        return (id, !relay.value.1)
                    }
                    .debug()
                    .subscribe(
                        onNext: { relay.accept($0) },
                        onDisposed: { view.removeGestureRecognizer(tap) }
                    )

                view.addGestureRecognizer(tap)
                print("Gesture Recognizers: \(view.gestureRecognizers)")
            }
        )
    }

    public let disposeBag: DisposeBag
}
