//
//  Cyanic
//  Created by Julio Miguel Alorro on 07.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit

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
        let insets: UIEdgeInsets = component.insets
        let childVC: UIViewController & CyanicChildVCType = component.childVC
        let parentVC: UIViewController? = component.parentVC

        let sizeLayout: SizeLayout<UIView> = SizeLayout<UIView>(
            size: size,
            viewReuseId: "\(ChildVCComponentLayout.identifier)ChildVCView",
            sublayout: nil,
            config: {  [weak childVC, weak parentVC] (view: UIView) -> Void in
                guard let childVC = childVC, let parentVC = parentVC else { return }

                if childVC.parent !== parentVC {
                    parentVC.addChild(childVC)
                    childVC.view.frame = view.bounds
                    view.addSubview(childVC.view)
                    childVC.didMove(toParent: parentVC)
                } else {
                    childVC.view.frame = view.bounds
                    view.addSubview(childVC.view)
                }

                component.configuration(childVC)
            }
        )

        let insetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
            insets: insets,
            sublayout: sizeLayout
        )

        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height + insets.top + insets.bottom,
            maxHeight: size.height + insets.top + insets.bottom,
            viewReuseId: "\(ChildVCComponentLayout.identifier)Size",
            sublayout: insetLayout,
            config: nil
        )
    }

}
