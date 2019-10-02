//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import Differentiator
import Foundation

/**
 Type-erased wrapper for a Component instance
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
        self.id = component.id
    }

    /**
     The layout from the Component.
    */
    public func layout(width: CGFloat) -> ComponentLayout {
        return (self.identity.base as! UserInterfaceModel).layout(width: width) // swiftlint:disable:this force_cast
    }

    /**
     The underlying Component instance wrapped in an AnyHashable type erased container.
    */
    public let identity: AnyHashable

    /**
     The unique identifier of the Component.
    */
    public let id: String

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
