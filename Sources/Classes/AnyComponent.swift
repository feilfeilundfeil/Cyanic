//
//  AnyComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.DisposeBag
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import protocol Differentiator.IdentifiableType
import struct Foundation.IndexPath

/**
 Type Erased wrapper for a Component instance
*/
public final class AnyComponent: IdentifiableType {

    /**
     Initializer.
     Keeps the underlying Component in memory and creates a reference to its layout and cellType. 
    */
    public init<C: Component>(_ component: C) {
        self.cellType = component.cellType
        self.identity = AnyHashable(component.identity)
    }

    deinit {
        print("\(self) was deallocated")
//        guard let component = self.identity.base as? ChildVCComponent else { return }
//        component.removeVC()
    }

    /**
     The layout from the Component.
    */
    public var layout: ComponentLayout {
        return (self.identity.base as! UserInterfaceModel).layout // swiftlint:disable:this force_cast
    }

    /**
     The cellType from the Component.
    */
    public let cellType: ComponentCell.Type

    /**
     The underlying Component instance wrapped in an AnyHashable type erased container.
    */
    public let identity: AnyHashable

}

public extension AnyComponent {

    /**
     Dequeues the correct cellType for the given Component on the BaseComponentsVC's UICollectionView.
     - parameters:
         - collectionView: The UICollectionView dequeuing the UICollectionViewCell
         - cellType: The UICollectionViewCell subclass type with the identifier
         - indexPath: The indexPath in the UICollectionView for the UICollectionViewCell.
    */
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
