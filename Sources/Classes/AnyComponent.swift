//
//  AnyComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import struct UIKit.IndexPath
import protocol LayoutKit.Layout
import protocol Differentiator.IdentifiableType
import class RxSwift.DisposeBag

/**
 Type Erasure class for data structures that conform to Component.
*/
public final class AnyComponent {

    init<ComponentSubclass: Component>(_ component: ComponentSubclass) {
        self._identity = component.identity
        self.cellType = component.cellType
        self.layout = component.layout
        self.viewModel = component.viewModel
        self.disposeBag = component.disposeBag
    }

    // MARK: Stored Properties
    /**
     The StateType instance of the Component. Used for the diffing portion in RxDataSources.
    */
    private let _identity: StateType

    /**
     The type information of the ConfigurableCell subclass used to host the UIViews created by the Layout instance.
    */
    public let cellType: ConfigurableCell.Type

    /**
     The Layout instance of the Component. Defines the size and location of the UIViews it will create and binds the data from the ViewModel
     instance.

     This Layout instance is custom made aka is not generated.
    */
    public let layout: ComponentLayout

    /**
     The ViewModel instance contains the information of the model that will be displayed on UI for this component.

     This ViewModel instance is custom made aka is not generated.
    */
    public let viewModel: ViewModel

    public let disposeBag: DisposeBag

    /**
    */
    func dequeueReusableCell<ConfigurableCellSubclass: ConfigurableCell>(
        in collectionView: UICollectionView,
        to cellType: ConfigurableCellSubclass.Type,
        for indexPath: IndexPath
    ) -> UICollectionViewCell? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ConfigurableCellSubclass.identifier, for: indexPath)
    }

}

// MARK: - IdentifiableType

extension AnyComponent: IdentifiableType {

    public var identity: StateType { return self._identity }

}

// MARK: - Hashable Protocol

extension AnyComponent: Hashable {

    public static func == (lhs: AnyComponent, rhs: AnyComponent) -> Bool {
        return lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identity)
    }

}
