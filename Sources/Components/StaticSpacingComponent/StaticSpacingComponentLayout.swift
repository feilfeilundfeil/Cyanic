//
//  StaticSpacingComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.SizeLayout
import class RxSwift.DisposeBag
import class UIKit.UIColor
import class UIKit.UIView
import struct CoreGraphics.CGSize
import struct LayoutKit.Alignment
import struct LayoutKit.Flexibility

/**
 The StaticSpacingComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with StaticSpacingComponent.
*/
public final class StaticSpacingComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(component: StaticSpacingComponent) {
        let size: CGSize = CGSize(width: component.width, height: component.height)
        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            alignment: Alignment.center,
            flexibility: Flexibility.inflexible,
            viewReuseId: StaticSpacingComponentLayout.identifier,
            sublayout: nil,
            config: { (view: UIView) -> Void in
                view.backgroundColor = component.backgroundColor
            }
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
