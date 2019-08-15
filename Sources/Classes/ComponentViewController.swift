//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.04.19.
//  Licensed under the MIT license. See LICENSE file
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

/**
 ComponentViewController contains all the logic that is shared between the CollectionComponentViewController and
 TableComponentViewController.

 Most of the logic sets up the UITableView / UICollectionView constraints and setting up the combined State observable.
 This class contains the necessary properties and methods shared by both subclasses.

 The goal of sharing parent classes between a UICollectionView Controller and UITableView Controller means
 they can be interchangable.
*/
open class ComponentViewController: UIViewController, StateObservableBuilder {

    deinit {
        if self.viewModels.contains(where: { $0.isDebugMode }) {
            print("\(type(of: self)) was deallocated")
        }
    }

    open override func loadView() {
        self.view = UIView()
        self._listView = self.setUpListView()
        self._listView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self._listView)

        // The reason why the UITableView/UICollectionView is not the root UIView, is because there are times
        // where you'd want other subviews in the UIViewController other than a UITableView/UICollectionView.
        NSLayoutConstraint.activate([
            self.topAnchorConstraint,
            self.bottomAnchorConstraint,
            self.leadingAnchorConstraint,
            self.trailingAnchorConstraint
        ])
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpObservables(with: self.viewModels)
    }

    // MARK: Constraints
    /**
     The top anchor NSLayoutConstraint of the UICollectionView/UITableView in the root UIView.
    */
    public lazy var topAnchorConstraint: NSLayoutConstraint = {
        return self._listView.topAnchor
            .constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0.0)
    }()

    /**
     The bottom anchor NSLayoutConstraint of the UICollectionView/UITableView in the root UIView.
    */
    public lazy var bottomAnchorConstraint: NSLayoutConstraint = {
        return self._listView.bottomAnchor
            .constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: 0.0)
    }()

    /**
     The leading anchor NSLayoutConstraint of the UICollectionView/UITableView in the root UIView.
    */
    public lazy var leadingAnchorConstraint: NSLayoutConstraint = {
        return self._listView.leadingAnchor
            .constraint(equalTo: self.view.leadingAnchor, constant: 0.0)
    }()

    /**
     The trailing anchor NSLayoutConstraint of the UICollectionView/UITableView in the root UIView.
    */
    public lazy var trailingAnchorConstraint: NSLayoutConstraint = {
        return self._listView.trailingAnchor
            .constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
    }()

    // MARK: Stored Properties
    /**
     This UIView should either be a UICollectionView or UITableView instance, depending on the subclass used.
    */
    internal var _listView: UIView! // swiftlint:disable:this implicitly_unwrapped_optional

    /**
     The CGSize of this UIViewController.
    */
    public var _size: CGSize = CGSize.zero

    /**
     When the UITableView/UICollectionView is loaded, its width and height are initially all zero. When viewWillAppear
     is called, the views are sized. This Observable emits the nonzero sizes of the UICollectionView/UITableView when
     it changes. This may not work in some circumstances where ComponentViewController is inside a custom
     container UIViewController such as the numerous side menu libraries out there. If that happens
     override **size** and use **.exactly**.
    */
    internal lazy var _sizeObservable: Observable<CGSize> = self._listView.rx
        .observeWeakly(CGRect.self, "bounds", options: [KeyValueObservingOptions.new, KeyValueObservingOptions.initial])
        .filter({ (rect: CGRect?) -> Bool in
            return rect?.size != nil && rect?.size.height != 0.0 && rect?.size.width != 0.0
        })
        .map({ (rect: CGRect?) -> CGSize in rect!.size })
        .distinctUntilChanged()

    /**
     The combined States of the ViewModels as a BehviorRelay for debugging purposes.
    */
    internal let state: BehaviorRelay<[Any]> = BehaviorRelay<[Any]>(value: [()])

    /**
     DisposeBag for Rx-related subscriptions.
    */
    public let disposeBag: DisposeBag = DisposeBag()

    /**
     The serial scheduler where the ViewModel's state changes are observed on and mapped to the _components
    */
    public let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(
        qos: DispatchQoS.userInitiated,
        internalSerialQueueName: "\(UUID().uuidString)"
    )

    // MARK: Computed Properties
    /**
     The ViewModels whose States is observed by this ComponentViewController.
    */
    open var viewModels: [AnyViewModel] { return [] }

    /**
     Limits the frequency of state updates. There are some cases where this is necessary. The default value is
     ThrottleType.none.
    */
    open var throttleType: ThrottleType { return ThrottleType.none }

    /**
     The current States of the ViewModels from the state BehaviorRelay.
    */
    public var currentState: Any { return self.state.value }

    /**
     In cases where ComponentViewController is a childViewController, it is sometimes necessary to have an exact size.
     This enum allows the the programmer to specify if there's an exact size for the ComponentViewController or if it
     should be taken cared of by UIKit.

     Most of the time, you don't need to override this.
    */
    open var size: Size { return Size.automatic }

    // MARK: Methods
    /**
     Creates the UICollectionView or UITableView.
     - Returns:
        - This method should reutrn either a UICollectionView or UITableView.
    */
    open func setUpListView() -> UIView { fatalError("Override this") }

    internal typealias CombinedState = (CGSize, [Any])

    /**
     Creates an Observable that combines all Observables that will drive the changes in the UICollectionView/UITableView.

     This method creates a new Observable based on the ViewModels' States and **_sizeObservable**. The combined Observable is
     throttled base on **throttleType** and is observed and subscribed on the **scheduler**.

     If any of the ViewModels are in debug mode, the observable will emit RxSwift debug messages.

     The Observable is then shared, binded to the **state**  relay and binded to the **invalidate** method.

     - Parameters:
        - viewModels: The ViewModels whose States will be observed.
     - Returns:
        - Observable that monitors the size of the UICollectionView/UITableView and the States of the ViewModels
          inside the **viewModels** array.
    */
    @discardableResult
    internal func setUpObservables(with viewModels: [AnyViewModel]) -> Observable<(CGSize, [Any])> {
        guard !viewModels.isEmpty else { return Observable<(CGSize, [Any])>.empty() }
        let combinedStatesObservables: Observable<[Any]> = viewModels.combineStateObservables()

        let filteredSize: Observable<CGSize>

        switch self.size {
            case .automatic:
                filteredSize = self._sizeObservable

            case .exactly(let size):
                filteredSize = Observable<CGSize>.just(size)
        }

        let allObservables: Observable<(CGSize, [Any])> = Observable.combineLatest(
            filteredSize, combinedStatesObservables
        )

        var throttledStateObservable: Observable<(CGSize, [Any])> = self.setUpThrottleType(
            on: allObservables,
            throttleType: self.throttleType,
            scheduler: self.scheduler
        )
            .observeOn(self.scheduler)
            .subscribeOn(self.scheduler)

        if self.viewModels.contains(where: { $0.isDebugMode }) {
            throttledStateObservable = throttledStateObservable.debug(
                "\(type(of: self))",
                trimOutput: false
            )
        }

        throttledStateObservable = throttledStateObservable.share()

        throttledStateObservable
            .map({ (width: CGSize, states: [Any]) -> [Any] in
                let width: Any = width as Any
                return [width] + states
            })
            .bind(to: self.state)
            .disposed(by: self.disposeBag)

        throttledStateObservable
            .observeOn(MainScheduler.instance)
            .bind(
                onNext: { [weak self] (_: CGSize, _: [Any]) -> Void in
                    self?.invalidate()
                }
            )
            .disposed(by: self.disposeBag)

        return throttledStateObservable
    }

    /**
     Gets the AnyComponent instance at the specified indexPath.
     - Parameters:
        - indexPath: The IndexPath of the AnyComponent.
     - Returns:
        The AnyComponent instance at the IndexPath, if there is one.
    */
    open func component(at indexPath: IndexPath) -> AnyComponent? {
        fatalError("Override this!")
    }

    /**
     When the State of a ViewModel in the viewModels array changes, invalidate is called, therefore, you should
     place logic here that should react to changes in State. This method is run on the main thread asynchronously.

     When overriding, no need to call super because the default implementation does nothing.
    */
    open func invalidate() {}

}
