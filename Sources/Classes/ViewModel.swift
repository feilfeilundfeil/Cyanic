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

protocol ViewModelType {}

open class BaseViewModel<S: State>: ViewModelType {

    public init(initialState: S) {
        self.state = BehaviorRelay<S>(value: initialState)
    }

    internal let state: BehaviorRelay<S>
    public let disposeBag: DisposeBag = DisposeBag()

    public var currentState: S {
        return self.state.value
    }

    public final func setState(block: (inout S) -> Void) {
        let firstState: S = self.currentState.changing(block: block)
        let secondState: S = self.currentState.changing(block: block)

        guard firstState == secondState else {
            fatalError("Executing your block twice produced different states. This must not happen!")
        }

        self.state.accept(firstState)

    }

}
