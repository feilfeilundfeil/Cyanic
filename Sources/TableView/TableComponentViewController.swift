//
//  TableComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxDataSources.RxTableViewSectionedAnimatedDataSource
import class RxSwift.DisposeBag
import class RxSwift.MainScheduler
import class RxSwift.Observable
import class RxSwift.SerialDispatchQueueScheduler
import class UIKit.NSLayoutConstraint
import class UIKit.UITableView
import class UIKit.UITableViewCell
//import class UIKit.UICollectionViewFlowLayout
//import class UIKit.UICollectionViewLayout
import class UIKit.UIView
import class UIKit.UIViewController
import protocol UIKit.UITableViewDelegate
import protocol UIKit.UIViewControllerTransitionCoordinator
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct Foundation.DispatchQoS
import struct Foundation.IndexPath
import struct Foundation.UUID
import struct RxCocoa.KeyValueObservingOptions
import struct RxSwift.RxTimeInterval

/**
 TableComponentViewController is the base class of UIViewControllers that use Cyanic's state driven UI logic
 */
open class TableComponentViewController: UIViewController, StateObservableBuilder, UITableViewDelegate {

    // MARK: UIViewController Lifecycle Methods
    open override func loadView() {
        self.view = UIView()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)

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
        self.tableView.register(TableViewComponentCell.self, forCellReuseIdentifier: TableViewComponentCell.identifier)

        // Set up as the UICollectionView's UICollectionViewDelegateFlowLayout,
        // UICollectionViewDelegate, and UIScrollViewDelegate
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }

    // MARK: Constraints
    /**
     The top anchor NSLayoutConstraint of the UICollectionView in the root UIView.
     */
    public lazy var topAnchorConstraint: NSLayoutConstraint = {
        return self.tableView.topAnchor
            .constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0.0)
    }()

    /**
     The bottom anchor NSLayoutConstraint of the UICollectionView in the root UIView.
     */
    public lazy var bottomAnchorConstraint: NSLayoutConstraint = {
        return self.tableView.bottomAnchor
            .constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: 0.0)
    }()

    /**
     The leading anchor NSLayoutConstraint of the UICollectionView in the root UIView.
     */
    public lazy var leadingAnchorConstraint: NSLayoutConstraint = {
        return self.tableView.leadingAnchor
            .constraint(equalTo: self.view.leadingAnchor, constant: 0.0)
    }()

    /**
     The trailing anchor NSLayoutConstraint of the UICollectionView in the root UIView.
     */
    public lazy var trailingAnchorConstraint: NSLayoutConstraint = {
        return self.tableView.trailingAnchor
            .constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
    }()

    // MARK: Stored Properties
    /**
     When the collectionView is loaded, its width and height are initially all zero. When viewWillAppear is called, the views are sized.
     This Observable emits the nonzero sizes of UICollectionView when it changes. This may not work in some circumstances when this
     ComponentViewController is inside a custom container UIViewController. If that happens override **width** and use **.exactly**.
     */
    internal lazy var _sizeObservable: Observable<CGSize> = self.tableView.rx
        .observeWeakly(CGRect.self, "bounds", options: [KeyValueObservingOptions.new, KeyValueObservingOptions.initial])
        .filter({ (rect: CGRect?) -> Bool in
            return rect?.size != nil && rect?.size != CGSize.zero
        })
        .map({ (rect: CGRect?) -> CGSize in rect!.size })
        .distinctUntilChanged()

    internal var _size: CGSize = CGSize.zero

    /**
     The combined state of the ViewModels as a BehviorRelay for debugging purposes.
     */
    internal let state: BehaviorRelay<[Any]> = BehaviorRelay<[Any]>(value: [()])

    /**
     DisposeBag for Rx-related subscriptions.
     */
    internal let disposeBag: DisposeBag = DisposeBag()

    /**
     The serial scheduler where the ViewModel's state changes are observed on and mapped to the _components
     */
    internal let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(
        qos: DispatchQoS.userInitiated,
        internalSerialQueueName: "\(UUID().uuidString)"
    )

    // MARK: Computed Properties
    /**
     The ViewModels whose State is observed by this CyanicViewController.
     */
    open var viewModels: [AnyViewModel] { return [] }

    /**
     Limits the frequency of state updates.
     */
    open var throttleType: ThrottleType { return ThrottleType.none }

    /**
     The current state of the ViewModels from the state BehaviorRelay.
     */
    public var currentState: Any { return self.state.value }

    open var size: TableComponentViewController.Size { return TableComponentViewController.Size.automatic }

    // MARK: Views
    /**
     The UICollectionView instance managed by this ComponentViewController instance.
     */
    public private(set) lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)

    internal typealias CombinedState = (CGSize, [Any])

    // MARK: Methods
    /**
     Creates an Observables based on ThrottleType and binds it to the AnyComponents Observables.

     It creates a new Observables based on the ViewModels' States and  BaseComponenVC's ThrottleType and
     binds it to the AnyComponents Observable so any new State change creates a new AnyComponents array
     which in turn updates the UICollectionView.

     - Parameters:
     - viewModels: The ViewModels whose States will be observed.
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

        //        if self.viewModels.contains(where: { $0.isDebugMode }) {
        //            throttledStateObservable = throttledStateObservable
        //                .debug("\(type(of: self))", trimOutput: false)
        //        }

        throttledStateObservable = throttledStateObservable.share()

        throttledStateObservable
            .map({ (width: CGSize, states: [Any]) -> [Any] in
                let width: Any = width as Any
                return [width] + states
            })
            .bind(to: self.state)
            .disposed(by: self.disposeBag)

        throttledStateObservable
            .observeOn(MainScheduler.asyncInstance)
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
     The AnyComponent instance at the IndexPath.
     */
    open func component(at indexPath: IndexPath) -> AnyComponent? {
        fatalError("Override this!")
    }

    /**
     When the State of the ViewModel changes, invalidate is called, therefore, you should place logic here that
     should react to changes in state. This method is run on the main thread asynchronously.

     When overriding, no need to call super because the default implementation does nothing.
     */
    open func invalidate() {}

    // MARK: UITableViewDelegate Methods
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let component: AnyComponent = self.component(at: indexPath) else { return }
        guard let selectable = component.identity.base as? Selectable else { return }
        selectable.onSelect()
    }
}

// MARK: - Size Enum
public extension TableComponentViewController {

    /**
     In cases where ComponentViewController is a childViewController, it is sometimes necessary to have an exact size.
     This enum allows the the programmer to specify if there's an exact size for the ComponentViewController or if it
     should be taken cared of by UIKit.
     */
    enum Size {
        /**
         Size is defined by UIKit automatically. It is calculated by taking the UICollectionView's frame.
         */
        case automatic

        /**
         Size is defined by a constant value.
         */
        case exactly(CGSize)
    }

}
