//
//  OneViewModelComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxSwift.Observable
import class UIKit.UICollectionViewLayout

/**
 
*/
open class OneViewModelComponentVC<ConcreteState: State, ConcreteViewModel: BaseViewModel<ConcreteState>>: BaseComponentVC {

    public init(viewModel: ConcreteViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let observable: Observable<ConcreteState>

        switch self.throttleType {
            case .debounce(let timeInterval):
                observable = self.viewModel.state
                    .debounce(timeInterval, scheduler: self.scheduler)

            case .throttle(let timeInterval):
                observable = self.viewModel.state
                    .throttle(timeInterval, latest: true, scheduler: self.scheduler)

            case .none:
                observable = self.viewModel.state
        }

        // Call components method when a new element in ViewModel's state is emitted
        // Bind the new AnyComponents array to the _components BehaviorRelay.
        // NOTE:
        // RxCollectionViewSectionedAnimatedDataSource.swift line 56.
        // UICollectionView has problems with fast updates. So, there is no point in
        // in executing operations in quick succession when it is throttled anyway.
        observable
            .observeOn(self.scheduler)
            .map { [weak self] (state: ConcreteState) -> [AnyComponent] in
                guard let s = self else { return [] }
                var array: ComponentsArray = ComponentsArray()
                s.components(&array, state: state)
                return array.components
            }
            .subscribeOn(self.scheduler)
            .bind(to: self._components)
            .disposed(by: self.disposeBag)
    }

    /**
     The ViewModel instance that manages the business logic of this instance of BaseComponentVC
    */
    public let viewModel: ConcreteViewModel

    /**
      This method is responsible for creating the [AnyComponent] array.
      This is where you create for logic to add Components to the ComponentsArray data structure. This method is called every time the State
      of the ViewModel changes.

      - Parameters:
         - state: The latest snapshot of the State object of the ViewModel
         - components: The ComponentsArray that is mutated by this method. It is always starts as an empty ComponentsArray.
    */
    open func components(_ components: inout ComponentsArray, state: ConcreteState) {
        fatalError("Override this.")
    }

}
