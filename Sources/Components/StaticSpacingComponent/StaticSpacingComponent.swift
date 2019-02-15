//
//  StaticSpacingComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation
import UIKit

public final class StaticSpacingComponent: Component, Hashable {

    public init(id: String, height: CGFloat = 0.0) {
        self.id = id
        self.height = height
    }

    public let id: String
    public let height: CGFloat

    public var layout: ComponentLayout {
        return StaticSpacingComponentLayout(height: self.height)
    }

    public let cellType: ComponentCell.Type = ComponentCell.self

    public var identity: StaticSpacingComponent {
        return self
    }

    public func isEqual(to other: StaticSpacingComponent) -> Bool {
        return self.id == other.id &&
            self.height == other.height
    }

    public static func == (lhs: StaticSpacingComponent, rhs: StaticSpacingComponent) -> Bool {
        return lhs.isEqual(to: rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.height)
        hasher.combine(self.id)
    }
}
