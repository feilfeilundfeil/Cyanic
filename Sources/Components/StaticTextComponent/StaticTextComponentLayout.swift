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

public final class StaticTextComponentLayout: TextViewLayout<UITextView>, ComponentLayout {

    public init(
        id: String,
        text: Text,
        font: UIFont?,
        lineFragmentPadding: CGFloat,
        insets: UIEdgeInsets,
        layoutAlignment: Alignment,
        flexibility: Flexibility,
        style: AlacrityStyle<UITextView>
    ) {
        super.init(
            text: text,
            font: font,
            lineFragmentPadding: lineFragmentPadding,
            textContainerInset: insets,
            layoutAlignment: layoutAlignment,
            flexibility: flexibility,
            viewReuseId: id,
            config: style.modifying { (view: UITextView) -> Void in
                view.isEditable = false
            }
            .style
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
