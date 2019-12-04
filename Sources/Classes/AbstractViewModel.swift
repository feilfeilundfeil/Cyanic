//
//  Cyanic
//  Created by Julio Miguel Alorro on 04.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import RxCocoa
import RxSwift
import os

internal let CyanicViewModelLog: OSLog = OSLog(subsystem: CyanicConstants.bundleIdentifier, category: "ViewModel")

/**
 AbstractViewModel is a class that provides the essential functionality that must exist in all ViewModel subclasses.
*/
open class AbstractViewModel<StateType: State>: NSObject, ViewModelType {

    /**
     Initializer for the ViewModel.
     When instantiating the ViewModel, it is important to pass an initial State object which should represent
     the initial State of the current view / screen of the app.
     - Parameters:
        - initialState: The starting State of the ViewModel.
    */
    public init(initialState: StateType, isDebugMode: Bool = false) {
        self.stateStore = StateStore<StateType>(initialState: initialState)
        self.isDebugMode = isDebugMode
        super.init()
    }

    deinit {
        logDeallocation(of: self, log: CyanicViewModelLog)
    }

    /**
     The StateStore that manages the State of the ViewModel
    */
    internal let stateStore: StateStore<StateType>

    /**
     Indicates whether debugging functionality will be used.
    */
    internal let isDebugMode: Bool

    /**
     The DisposeBag used to clean up any Rx related subscriptions related to the ViewModel instance.
    */
    public let disposeBag: DisposeBag = DisposeBag()

    /**
     Accessor for the current State of the AbstractViewModel.
    */
    public var currentState: StateType {
        return self.stateStore.currentState
    }

}

public extension AbstractViewModel {

    /**
     Accessor for the State Observable of the AbstractViewModel.
    */
    var state: Observable<StateType> {
        return self.stateStore.state
    }

}

internal protocol ViewModelType {}
