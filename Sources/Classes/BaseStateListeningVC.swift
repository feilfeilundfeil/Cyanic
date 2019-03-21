//
//  BaseStateListeningVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/21/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxCocoa.BehaviorRelay
import class RxSwift.DisposeBag
import class RxSwift.Observable
import class RxSwift.SerialDispatchQueueScheduler
import class UIKit.UIViewController
import struct Foundation.DispatchQoS
import struct Foundation.UUID

open class BaseStateListeningVC: UIViewController {

    // MARK: Stored Properties
    /**
     The serial scheduler where the ViewModel's state changes are observed on and mapped to the _components
     */
    internal let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(
        qos: DispatchQoS.userInitiated,
        internalSerialQueueName: "\(UUID().uuidString)"
    )

    internal let disposeBag: DisposeBag = DisposeBag()

    // MARK: Computed Properties
    open var throttleType: ThrottleType { return ThrottleType.none }

    // MARK: Methods
    /**
     When the State of the ViewModel changes, invalidate is called, therefore, you should place logic here that
     should react to changes in state.
    */
    open func invalidate() {}

}

open class OneViewModelStateListeningVC<
    ConcreteState: State,
    ConcreteViewModel: BaseViewModel<ConcreteState>
    >: BaseStateListeningVC {

    // MARK: Initializers
    public init(viewModel: ConcreteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController Lifecycle Methods
    open override func viewDidLoad() {
        super.viewDidLoad()

        var observable: Observable<ConcreteState> = self.viewModel.state.observeOn(self.scheduler)

        switch self.throttleType {
            case .debounce(let interval):
                observable = observable
                    .debounce(interval, scheduler: self.scheduler)

            case .throttle(let interval):
                observable = observable
                    .throttle(interval, latest: true, scheduler: self.scheduler)

            case .none:
                break
        }

        observable
            .subscribeOn(self.scheduler)
            .bind(
                onNext: { [weak self] (_: ConcreteState) -> Void in
                    self?.invalidate()
                }
            )
            .disposed(by: self.disposeBag)
    }

    // MARK: Stored Properties
    public let viewModel: ConcreteViewModel

}
