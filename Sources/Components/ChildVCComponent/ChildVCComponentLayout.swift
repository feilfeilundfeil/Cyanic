//
//  ChildVCComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.SizeLayout
import class RxSwift.DisposeBag
import class UIKit.UIView
import class UIKit.UIViewController
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize

/**
 The StaticTextComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>. Used to create, size, and arrange the subviews
 associated with StaticTextComponent.
 */
public final class ChildVCComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer.
     - parameters:
     - vc: The ChildComponentVC to be displayed.
     - parentVC: The main UIViewController where the ChildComponentVC will be added as a child.
     - height: The height of the content in the view of the vc.
     */
    public init(
        vc: ChildComponentVC,
        parentVC: UIViewController,
        height: CGFloat
    ) {

        let size: CGSize = CGSize(width: Constants.screenWidth, height: height)
        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            viewReuseId: "\(ChildVCComponentLayout.identifier)Size",
            config: { [weak vc, weak parentVC] (view: UIView) -> Void in
                guard let vc = vc, let parentVC = parentVC else { return }
                parentVC.addChild(vc)
                vc.didMove(toParent: parentVC)
                view.addSubview(vc.view)
                vc.view.frame = view.bounds
            }
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
