//
//  CollectionComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxDataSources.RxCollectionViewSectionedAnimatedDataSource
import class RxSwift.DisposeBag
import class RxSwift.MainScheduler
import class RxSwift.Observable
import class RxSwift.SerialDispatchQueueScheduler
import class UIKit.NSLayoutConstraint
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionViewFlowLayout
import class UIKit.UICollectionViewLayout
import class UIKit.UIView
import class UIKit.UIViewController
import protocol UIKit.UICollectionViewDelegateFlowLayout
import protocol UIKit.UIViewControllerTransitionCoordinator
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct Foundation.DispatchQoS
import struct Foundation.IndexPath
import struct Foundation.UUID
import struct RxCocoa.KeyValueObservingOptions
import struct RxSwift.RxTimeInterval

/**
 CollectionComponentViewController is the base class of UIViewControllers that use Cyanic's state driven UI logic
*/
open class CollectionComponentViewController: AbstractComponentViewController, UICollectionViewDelegateFlowLayout {

    // MARK: UIViewController Lifecycle Methods
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(CollectionComponentCell.self, forCellWithReuseIdentifier: CollectionComponentCell.identifier)

        // Set up as the UICollectionView's UICollectionViewDelegateFlowLayout,
        // UICollectionViewDelegate, and UIScrollViewDelegate
        self.collectionView.delegate = self
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: Computed Properties
    /**
     The UICollectionView instance managed by this CollectionComponentViewController instance.
    */
    public var collectionView: UICollectionView {
        return self._listView as! UICollectionView // swiftlint:disable:this force_cast
    }

    internal typealias CombinedState = (CGSize, [Any])

    // MARK: Methods
    internal override func setUpListView() -> UIView {
        return UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: self.createUICollectionViewLayout()
        )
    }

    /**
     Creates the UICollectionViewLayout to be used by the UICollectionView managed by this CollectionComponentViewController
     - Returns:
        A UICollectionViewLayout instance.
    */
    open func createUICollectionViewLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        return layout
    }

    // MARK: UICollectionViewDelegateFlowLayout Methods
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let component: AnyComponent = self.component(at: indexPath) else { return }
        guard let selectable = component.identity.base as? Selectable else { return }
        selectable.onSelect()
    }
}
