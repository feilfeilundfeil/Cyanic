//
//  ConfigurableCell.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import func Foundation.ceilf
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import class UIKit.UICollectionViewCell
import class UIKit.UIView
import class UIKit.UIScreen
import class UIKit.UICollectionViewLayoutAttributes
import class UIKit.UICollectionViewFlowLayout
import struct Foundation.IndexPath
import protocol LayoutKit.Layout
import class LayoutKit.SizeLayout
import class RxSwift.DisposeBag

/**
 The ConfigurableCell serves as the root UIView for the UI elements generated by its Layout
*/
open class ConfigurableCell: UICollectionViewCell {

    /**
     The String identifier used by the ConfigurableCell to register to a UICollectionView instance
     */
    open class var identifier: String {
        return String(describing: Mirror(reflecting: self).subjectType)
    }

    // MARK: Layout
    /**
    */
    private var layout: ComponentLayout?

    override public final func layoutSubviews() {
        self.layout?.measurement(
            within: self.contentView.frame.size
        )
            .arrangement(within: self.contentView.bounds)
            .makeViews(in: self.contentView)
        print("ContentView: \(self.contentView.bounds)")
        print(self.contentView.subviews)
        print(
            self.contentView.subviews
                .map { "\(type(of: $0)): \($0.bounds)"}
                .joined(separator: "\n")
        )
    }

    override public final func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let size = self.layout?.measurement(within: size).size else { return CGSize.zero }
        return size
    }

    override public final var intrinsicContentSize: CGSize {
        return self.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open func configure(with component: AnyComponent) {
        self.layout = component.layout
        let size: CGSize

        if let layout = self.layout as? SizeLayout<UIView>, let minWidth = layout.minWidth, let minHeight = layout.minHeight {
            size = CGSize(width: minWidth, height: minHeight)
        } else {
            size = UICollectionViewFlowLayout.automaticSize
        }

        self.contentView.frame.size = size

        defer { self.setNeedsLayout() }
    }

    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()

        let size: CGSize

        if let layout = self.layout as? SizeLayout<UIView>, let minWidth = layout.minWidth, let minHeight = layout.minHeight {
            size = CGSize(width: minWidth, height: minHeight)
        } else {
            size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        }

        var newFrame: CGRect = layoutAttributes.frame
        newFrame.size.height = CGFloat(ceilf(Float(size.height)))
        newFrame.size.width = UIScreen.main.bounds.width
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

}
