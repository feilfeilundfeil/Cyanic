//
//  ComponentSupplementaryView.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Dispatch.DispatchQueue
import class Foundation.NSCoder
import class RxSwift.DisposeBag
import class RxSwift.SerialDisposable
import class UIKit.UICollectionReusableView
import class UIKit.UIColor
import class UIKit.UITapGestureRecognizer
import protocol LayoutKit.Layout
import protocol RxSwift.Disposable
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct Dispatch.DispatchQoS
import struct LayoutKit.LayoutArrangement
import struct LayoutKit.LayoutMeasurement

public final class ComponentSupplementaryView: UICollectionReusableView {

    // MARK: Class Properties
    /**
     The String identifier used by the ComponentCell to register to a UICollectionView instance
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
     The current ComponentLayout instance that created and arranged the subviews in the contentView of this ComponentCell.
     */
    private var layout: ComponentLayout?
    private var tap: UITapGestureRecognizer?
    private let disposeBag: DisposeBag = DisposeBag()
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
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layout = nil

        if let tap = self.tap {
            self.removeGestureRecognizer(tap)
        }

        self.serialDisposable.disposable.dispose()
        self.tap = nil
    }

    public override final func layoutSubviews() {

        // Get the rect of the contentView in the main thread.
        let bounds: CGRect = self.bounds

//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: { () -> Void in
            guard let layout = self.layout else { return }

            // Do the size calculation in a background thread
            let measurement: LayoutMeasurement = layout.measurement(
                within: bounds.size
            )

            // Do the arrangement calculation in a background thread
            let arrangement: LayoutArrangement = measurement
                .arrangement(within: bounds)

            // Size and place the subviews on the main thread
//            DispatchQueue.main.async(execute: { () -> Void in
                arrangement.makeViews(in: self)
//            })
//        })
    }

    public override final func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let size = self.layout?.measurement(within: size).size else { return CGSize.zero }
        return size
    }

    /**
     Reads the layout from the AnyComponent instance to create the subviews in this ComponentCell instance. This also
     sets the contentView.frame.size to the cell's intrinsicContentSize and calls setNeedsLayout.
     - Parameters:
        - component: The AnyComponent instance that represents this ComponentCell
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

        self.setNeedsLayout()
    }

}
