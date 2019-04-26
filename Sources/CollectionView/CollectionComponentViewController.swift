//
//  CollectionComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit

/**
 CollectionComponentViewController is a subclass of ComponentViewController. It serves as the base class for the
 SingleSectionCollectionComponentViewController and MultiSectionCollectionComponentViewController, therefore it contains
 the logic and implementations shared between the two subclasses.
*/
open class CollectionComponentViewController: ComponentViewController, UICollectionViewDelegateFlowLayout {

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
    /**
     Creates a UICollectionView with a UICollectionViewLayout instantiated from the createUICollectionViewLayout method.
     This method is called in the ComponentViewController's loadView method.
     - Returns:
        - UICollectionView instance typed as a UIView.
    */
    open override func setUpListView() -> UIView {
        return UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: self.createUICollectionViewLayout()
        )
    }

    /**
     Creates the UICollectionViewLayout to be used by the UICollectionView managed by this CollectionComponentViewController.
     The default implementation creates a UICollectionViewFlowLayout with a minimumLineSpacing and minimumInteritemSpacing of
     0.0.
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
