//
//  AnyComponent.swift
//  Cyanic
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
     - Parameters:
        - component: The Component instance to be type erased.
    */
    public init<C: Component>(_ component: C) {
        self.identity = AnyHashable(component.identity)
    }

    /**
     The layout from the Component.
    */
    public var layout: ComponentLayout {
        return (self.identity.base as! UserInterfaceModel).layout // swiftlint:disable:this force_cast
    }

    /**
     The underlying Component instance wrapped in an AnyHashable type erased container.
    */
    public let identity: AnyHashable

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
