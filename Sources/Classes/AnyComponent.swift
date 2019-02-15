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

/**
 Type Erased wrapper for a Component instance
*/
public final class AnyComponent: IdentifiableType {

    public init<C: Component>(_ component: C) {
        self.layout = component.layout
        self.cellType = component.cellType
        self.identity = AnyHashable(component.identity)
        self.isShown = component.isShown
    }

    public let layout: ComponentLayout
    public let cellType: ComponentCell.Type
    public let identity: AnyHashable
    public let isShown: () -> Bool

}

public extension AnyComponent {

    func dequeueReusableCell(in collectionView: UICollectionView, as cellType: ComponentCell.Type, for indexPath: IndexPath) -> UICollectionViewCell? {
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

extension AnyComponent: CustomStringConvertible {

    public var description: String {
        return self.identity.description
    }

}
