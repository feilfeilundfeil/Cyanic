//
//  ExpandableContentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/4/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.InsetLayout
import class LayoutKit.LabelLayout
import class LayoutKit.LabelLayoutDefaults
import class LayoutKit.SizeLayout
import class LayoutKit.StackLayout
import class UIKit.UIFont
import class UIKit.UIImage
import class UIKit.UIImageView
import class UIKit.UILabel
import class UIKit.UIView
import enum LayoutKit.Axis
import enum LayoutKit.Text
import enum LayoutKit.StackLayoutDistribution
import struct Alacrity.AlacrityStyle
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct Foundation.Data
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility
import struct UIKit.UIEdgeInsets

open class ExpandableContentLayout: InsetLayout<UIView> {}

public final class LabelContentLayout: ExpandableContentLayout {

    public init(
        text: Text,
        font: UIFont = UIFont.systemFont(ofSize: 17.0),
        alignment: Alignment = Alignment.center,
        style: AlacrityStyle<UILabel> = AlacrityStyle<UILabel> { _ in }
    ) {

        let labelLayout: LabelLayout<UILabel> = LabelLayout<UILabel>(
            text: text,
            font: font,
            numberOfLines: 0,
            alignment: Alignment.centerLeading,
            flexibility: LabelLayoutDefaults.defaultFlexibility,
            viewReuseId: "\(ExpandableComponentLayout.identifier)ContentLabel",
            config: style.style
        )

        super.init(
            insets: UIEdgeInsets.zero,
            alignment: alignment,
            flexibility: labelLayout.flexibility,
            viewReuseId: "\(ExpandableComponentLayout.identifier)ContentInset",
            sublayout: labelLayout,
            config: nil
        )

    }

}

public final class ImageLabelContentLayout: ExpandableContentLayout {

    public init(
        text: Text,
        font: UIFont = UIFont.systemFont(ofSize: 17.0),
        labelStyle: AlacrityStyle<UILabel> = AlacrityStyle<UILabel> { _ in },
        imageSize: CGSize,
        imageAlignment: Alignment = Alignment.aspectFit,
        imageStyle: AlacrityStyle<UIImageView> = AlacrityStyle<UIImageView> { _ in },
        spacing: CGFloat
    ) {

        let labelLayout: LabelLayout<UILabel> = LabelLayout<UILabel>(
            text: text,
            font: font,
            numberOfLines: 0,
            alignment: Alignment.centerLeading,
            flexibility: LabelLayoutDefaults.defaultFlexibility,
            viewReuseId: "\(ExpandableComponentLayout.identifier)ContentLabelWithImage",
            config: labelStyle.style
        )

        let imageLayout: SizeLayout<UIImageView> = SizeLayout<UIImageView>(
            size: imageSize,
            alignment: imageAlignment,
            flexibility: Flexibility.inflexible,
            viewReuseId: "\(ExpandableComponentLayout.identifier)ContentImage",
            config: imageStyle.style
        )

        let stackLayout: StackLayout<UIView> = StackLayout<UIView>(
            axis: Axis.horizontal,
            spacing: spacing,
            distribution: StackLayoutDistribution.fillEqualSpacing,
            alignment: Alignment.center,
            viewReuseId: "\(ExpandableComponentLayout.identifier)ContentStack",
            sublayouts: [imageLayout, labelLayout]
        )

        super.init(
            insets: UIEdgeInsets.zero,
            alignment: Alignment.center,
            flexibility: Flexibility.low,
            viewReuseId: "\(ExpandableComponentLayout.identifier)ContentInset",
            sublayout: stackLayout,
            config: nil
        )
    }

}
