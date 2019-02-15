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

public final class ExpandableComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(
        text: Text,
        font: UIFont,
        height: CGFloat,
        insets: UIEdgeInsets,
        alignment: Alignment,
        labelStyle: AlacrityStyle<UILabel>,
        relay: BehaviorRelay<(String, Bool)>
        
    ) {
        let disposeBag: DisposeBag = DisposeBag()
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

        self.disposeBag = disposeBag
        super.init(
            minWidth: size.width, maxWidth: size.width,
            minHeight: size.height, maxHeight: size.height,
            viewReuseId: ExpandableComponentLayout.identifier,
            sublayout: insetLayout,
            config: { (view: UIView) -> Void in
                guard view.gestureRecognizers == nil else { return }
                view.isUserInteractionEnabled = true
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)
                tap.rx.event
                    .map { (_: UITapGestureRecognizer) -> (String, Bool) in
                        return (text.value, !relay.value.1)
                    }
                    .debug()
                    .bind(to: relay)
                    .disposed(by: disposeBag)

                view.addGestureRecognizer(tap)
            }
        )
    }

    public let disposeBag: DisposeBag
}
