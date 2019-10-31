//
//  Cyanic
//  Created by Julio Miguel Alorro on 07.08.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import RxCocoa
import RxSwift
import UIKit

/**
 ComponentView is a UIView that acts as the root UIView for Cyanic Components.
*/
open class ComponentView: UIView {

    // MARK: Stored Properties
    /**
     The Component that arranges the subviews within this UIView instance.
     */
    open var component: AnyComponent? {
        didSet {
            guard let component = self.component else { return }
            self.configure(with: component)
        }
    }

    public private(set) var layout: ComponentLayout?
    private lazy var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    private lazy var disposeBag: DisposeBag = DisposeBag()
    private lazy var disposable: SerialDisposable = {
        let d: SerialDisposable = SerialDisposable()
        d.disposed(by: self.disposeBag)
        return d
    }()

    // MARK: Methods
    open func configure(with component: AnyComponent) {
        self.layout = self.component?.layout
        self.frame.size = self.intrinsicContentSize

        self.layout?.arrangement(
            origin: self.bounds.origin,
            width: self.bounds.size.width,
            height: self.bounds.size.height
        )
            .makeViews(in: self)

        if let component = self.component?.identity.base as? Selectable {
            self.disposable.disposable = self.tap.rx.event.subscribe(
                onNext: { [weak self] (_: UITapGestureRecognizer) -> Void in
                    guard let s = self else { return }
                    component.onSelect(s)
                },
                onDisposed: { [weak self] () -> Void in
                    guard let s = self else { return }
                    s.removeGestureRecognizer(s.tap)
                }
            )

            self.addGestureRecognizer(self.tap)
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let size = self.layout?.measurement(within: size).size else { return CGSize.zero }
        return size
    }

    open override var intrinsicContentSize: CGSize {
        return self.sizeThatFits(
            CGSize(
                width: self.bounds.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
    }

}
