//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.04.19.
//  Licensed under the MIT license. See LICENSE file
//

import Foundation
import LayoutKit
import RxSwift
import UIKit

/**
 TableComponentSectionView serves as the root UIView for any section UIView for UITableViews.
*/
public final class TableComponentSectionView: UIView {

    // MARK: Class Properties
    /**
     The String identifier used by the TableComponentSectionView.
    */
    public class var identifier: String {
        return String(describing: Mirror(reflecting: self).subjectType)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.serialDisposable.disposed(by: self.disposeBag)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Stored Properties
    /**
     The current ComponentLayout instance that creates and arranges the subviews in this TableComponentSectionView.
    */
    private var layout: ComponentLayout?

    /**
     The UITapGestureRecognizer instance that handles user tap gestures, if there is one.
    */
    private var tap: UITapGestureRecognizer?

    /**
     The DisposeBag that manages Rx-related subscriptions.
    */
    private let disposeBag: DisposeBag = DisposeBag()

    /**
     The SerialDisposable that ensures there is only one subscription at a time for the UITapGestureRecognizer.
    */
    private let serialDisposable: SerialDisposable = SerialDisposable()

    // MARK: Overridden Properties
    public override final var intrinsicContentSize: CGSize {
        return self.sizeThatFits(
            CGSize(
                width: self.bounds.width,
                height: self.bounds.height
            )
        )
    }

    // MARK: Overridden Methods
    public override final func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let size = self.layout?.measurement(within: size).size else { return CGSize.zero }
        return size
    }

    /**
     Reads the layout from the AnyComponent instance to create the subviews in this TableComponentSectionView instance. T
     his also sets the frame.size equal to its intrinsicContentSize and calls setNeedsLayout.
     - Parameters:
        - component: The AnyComponent instance that represents this TableComponentSectionView.
    */
    public func configure(with component: AnyComponent) {
        self.layout = component.layout(width: self.bounds.width)
        self.frame.size = self.intrinsicContentSize

        if let selectable = component.identity.base as? Selectable {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer()

            let disposable: Disposable = tap.rx.event.bind(onNext: { (_: UITapGestureRecognizer) -> Void in
                selectable.onSelect()
            })

            self.addGestureRecognizer(tap)
            self.serialDisposable.disposable = disposable
            self.tap = tap
        }

        self.layout?.arrangement(
            origin: self.bounds.origin,
            width: self.bounds.size.width,
            height: self.bounds.size.height
        )
            .makeViews(in: self)
    }

}
