//
//  AnyComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.DisposeBag
import protocol Differentiator.IdentifiableType
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import struct Foundation.IndexPath

public final class AnyComponent: IdentifiableType {

    public init<C: Component>(_ component: C) {
        self.layout = component.layout
        self.cellType = component.cellType
        self.identity = AnyHashable(component.identity)
    }

    public let layout: ComponentLayout
    public let cellType: ConfigurableCell.Type
    public let identity: AnyHashable

}

public extension AnyComponent {

    func dequeueReusableCell(in collectionView: UICollectionView, as cellType: ConfigurableCell.Type, for indexPath: IndexPath) -> UICollectionViewCell? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
    }

}

extension AnyComponent: Hashable {

    public static func == (lhs: AnyComponent, rhs: AnyComponent) -> Bool {
        return lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identity)
    }

}
