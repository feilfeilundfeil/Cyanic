//
//  StaticTextComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.SizeLayout
import class LayoutKit.TextViewLayout
import class RxSwift.DisposeBag
import class UIKit.UIFont
import class UIKit.UIColor
import class UIKit.UITextView
import class UIKit.UIView
import enum LayoutKit.Text
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

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
