//
//  StaticTextComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Alacrity
import LayoutKit
import RxSwift

public final class StaticTextComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(
        id: String,
        text: Text,
        font: UIFont,
        backgroundColor: UIColor,
        lineFragmentPadding: CGFloat,
        insets: UIEdgeInsets,
        layoutAlignment: Alignment,
        flexibility: Flexibility,
        style: AlacrityStyle<UITextView>
    ) {
        let textLayout: TextViewLayout<UITextView> = TextViewLayout<UITextView>(
            text: text,
            font: font,
            lineFragmentPadding: lineFragmentPadding,
            textContainerInset: insets,
            layoutAlignment: layoutAlignment,
            flexibility: flexibility,
            viewReuseId: id,
            config: AlacrityStyle<UITextView> {
                $0.backgroundColor = UIColor.clear
                $0.isEditable = false
            }
            .modifying(with: style.style)
            .style
        )

        let size: CGSize = CGSize(width: Constants.screenWidth, height: CGFloat.greatestFiniteMagnitude)

        super.init(
            minWidth: size.width, maxWidth: size.width,
            minHeight: 0.0, maxHeight: size.height,
            viewReuseId: "\(StaticTextComponentLayout.identifier)Size",
            sublayout: textLayout,
            config: {
                $0.backgroundColor = backgroundColor
            }
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
