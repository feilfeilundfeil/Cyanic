//
//  TableComponentHeaderView.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation
import LayoutKit
import RxSwift
import UIKit

/**
 TableComponentHeaderView serves as the root UIView for any section UIView for UITableViews.
*/
public final class TableComponentHeaderView: UIView {

    // MARK: Class Properties
    /**
     The String identifier used by the TableComponentHeaderView.
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
     The current ComponentLayout instance that creates and arranges the subviews in this TableComponentHeaderView.
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
                width: Constants.screenWidth,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
    }

    // MARK: Overridden Methods
//    public override final func layoutSubviews() {
//
//        // Get the rect of the contentView in the main thread.
//        let bounds: CGRect = self.bounds
//
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: { () -> Void in
//            guard let layout = self.layout else { return }
//
//            // Do the size calculation in a background thread
//            let measurement: LayoutMeasurement = layout.measurement(
//                within: bounds.size
//            )
//
//            // Do the arrangement calculation in a background thread
//            let arrangement: LayoutArrangement = measurement
//                .arrangement(within: bounds)
//
//            // Size and place the subviews on the main thread
//            DispatchQueue.main.async(execute: { () -> Void in
//                arrangement.makeViews(in: self)
//            })
//        })
//    }

    public override final func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let size = self.layout?.measurement(within: size).size else { return CGSize.zero }
        return size
    }

    /**
     Reads the layout from the AnyComponent instance to create the subviews in this TableComponentHeaderView instance. T
     his also sets the frame.size equal to its intrinsicContentSize and calls setNeedsLayout.
     - Parameters:
        - component: The AnyComponent instance that represents this TableComponentHeaderView.
    */
    public func configure(with component: AnyComponent) {
        self.layout = component.layout
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
            origin: self.frame.origin,
            width: self.frame.size.width,
            height: self.frame.size.height
        )
            .makeViews(in: self)
    }

}
