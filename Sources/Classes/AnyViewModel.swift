//
//  Cyanic
//  Created by Julio Miguel Alorro on 23.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import RxSwift

/**
 Type-erased wrapper for a ViewModel instance.
*/
public final class AnyViewModel {

    /**
     Initializer.
     Keeps the underlying viewModel instance in memory as an Any type.
     - Parameters:
        - viewModel: The BaseViewModel instance to be type erased.
    */
    public init<ConcreteState: State, ConcreteViewModel: ViewModel<ConcreteState>>(_ viewModel: ConcreteViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.state.map({ (state: ConcreteState) -> Any in state as Any })
        self.isDebugMode = viewModel.isDebugMode
    }

    /**
     The underlying ViewModel as an Any type
    */
    public let viewModel: Any

    /**
     The ViewModel's State as an Observable<Any>
    */
    public let state: Observable<Any>

    /**
     The debug mode of the underlying ViewModel instance
    */
    public let isDebugMode: Bool

}
