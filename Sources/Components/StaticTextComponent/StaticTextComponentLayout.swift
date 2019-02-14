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

public final class StaticTextComponentLayout: LabelLayout<UILabel>, ComponentLayout {

    public init(
        id: String,
        text: Text,
        font: UIFont,
        lineFragmentPadding: CGFloat,
        insets: UIEdgeInsets,
        alignment: Alignment,
        flexibility: Flexibility,
        style: AlacrityStyle<UILabel>
    ) {

        super.init(
            text: text,
            font: font,
            lineHeight: nil,
            numberOfLines: 0,
            alignment: alignment,
            flexibility: flexibility,
            viewReuseId: StaticTextComponentLayout.identifier,
            config: style.style
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
