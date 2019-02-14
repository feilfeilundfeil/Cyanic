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

protocol ViewModelType {

}

open class BaseViewModel<S: Equatable>: ViewModelType {

    public init(initialState: S) {
        self.state = BehaviorRelay<S>(value: initialState)
    }

    public let state: BehaviorRelay<S>
    public var currentState: S {
        return self.state.value
    }

}
