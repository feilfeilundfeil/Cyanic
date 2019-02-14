//
//  ViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation
import UIKit

protocol ViewModel {

}

open class AbstractViewModel<S: State>: ViewModel {

    public init(initialState: S) {
        self._state = BehaviorRelay<S>(value: initialState)
    }

    internal let _state: BehaviorRelay<S>

    public var state: S {
        return self._state.value
    }

    public final func withState(block: (S) -> Void) {
        block(self._state.value)
    }

    public final func setState(block: () -> S) {

        let firstState: S = block()
        let secondState: S = block()

        if firstState != secondState {
            fatalError("calling setState twice produced different results. This should not happen.")
        }

        self._state.accept(block())
    }

}
