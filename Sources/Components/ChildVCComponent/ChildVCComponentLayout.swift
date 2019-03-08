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
 The ChildVCComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>. Used to size the view property of the childVC
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
        childVC: ChildComponentVC,
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
            config: { [weak childVC, weak parentVC] (view: UIView) -> Void in
                guard let childVC = childVC, let parentVC = parentVC, childVC.parent !== parentVC else { return }
                parentVC.addChild(childVC)
                childVC.didMove(toParent: parentVC)
                view.addSubview(childVC.view)
                childVC.view.frame = view.bounds
            }
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
