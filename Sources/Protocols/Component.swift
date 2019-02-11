//
//  Component.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import protocol LayoutKit.Layout
import protocol Differentiator.IdentifiableType
import class RxSwift.DisposeBag

/**
 Component holds information for the state of the component. Might have observables for user input so it can mutate its StateType
*/
public protocol Component: IdentifiableType where Identity == StateType {

    var cellType: ConfigurableCell.Type { get }

    var layout: ComponentLayout { get }

    var viewModel: ViewModel { get set }

    var disposeBag: DisposeBag { get }

}

public extension Component {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identity)
    }

    public func asAnyComponent() -> AnyComponent {
        return AnyComponent(self)
    }

}




