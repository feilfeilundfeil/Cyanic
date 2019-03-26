//
//  ChildVCComponentLayout.swift
//  Cyanic
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
 The ChildVCComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to size the view property of the childVC
 */
public final class ChildVCComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer.
     - Parameters:
        - component: The ChildVCComponent whose properties define the UI characters of the subviews to be created.
    */
    public init(component: ChildVCComponent) {
        var component: ChildVCComponent = component
        let size: CGSize = component.size
        let childVC: ChildComponentVC = component.childVC
        let parentVC: UIViewController? = component.parentVC

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
