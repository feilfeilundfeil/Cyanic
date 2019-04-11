//
//  ComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxCocoa.BehaviorRelay
import class RxCocoa.PublishRelay
import class RxDataSources.RxCollectionViewSectionedAnimatedDataSource
import class RxSwift.DisposeBag
import class RxSwift.MainScheduler
import class RxSwift.Observable
import class RxSwift.SerialDispatchQueueScheduler
import class UIKit.NSLayoutConstraint
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionViewFlowLayout
import class UIKit.UICollectionViewLayout
import class UIKit.UIView
import class UIKit.UIViewController
import enum Foundation.DispatchTimeInterval
import enum RxDataSources.UITableViewRowAnimation
import protocol UIKit.UICollectionViewDelegateFlowLayout
import protocol UIKit.UIViewControllerTransitionCoordinator
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct Foundation.DispatchQoS
import struct Foundation.IndexPath
import struct Foundation.UUID
import struct RxCocoa.KeyValueObservingOptions
import struct RxDataSources.AnimatableSectionModel
import struct RxDataSources.AnimationConfiguration
import struct RxSwift.RxTimeInterval
import struct UIKit.UIEdgeInsets

/**
 ComponentViewController is a UIViewController with a UICollectionView managed by RxDataSources. It has most of the
 boilerplate needed to have a reactive UICollectionView. It responds to new elements emitted by its ViewModel's state.
 ComponentViewController is the delegate of the UICollectionView and serves as the UICollectionViewDataSource as well.
*/
open class ComponentViewController: CyanicViewController, UICollectionViewDelegateFlowLayout {

    // MARK: UIViewController Lifecycle Methods
    override open func loadView() {
        self.view = UIView()
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.topAnchorConstraint,
            self.bottomAnchorConstraint,
            self.leadingAnchorConstraint,
            self.trailingAnchorConstraint
        ])
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(ComponentCell.self, forCellWithReuseIdentifier: ComponentCell.identifier)

        // Set up as the UICollectionView's UICollectionViewDelegateFlowLayout,
        // UICollectionViewDelegate, and UIScrollViewDelegate
        self.collectionView.delegate = self

        // When _components emits a new element, bind the new element to the UICollectionView.
        self._components.asDriver()
            .map({ (components: [AnyComponent]) -> [AnimatableSectionModel<String, AnyComponent>] in
                return [AnimatableSectionModel(model: "Test", items: components)]
            })
            .drive(self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: Constraints
    /**
     The top anchor NSLayoutConstraint of the UICollectionView in the root UIView.
    */
    public lazy var topAnchorConstraint: NSLayoutConstraint = {
        return self.collectionView.topAnchor
            .constraint(equalTo: self.view.topAnchor, constant: 0.0)
    }()

    /**
     The bottom anchor NSLayoutConstraint of the UICollectionView in the root UIView.
    */
    public lazy var bottomAnchorConstraint: NSLayoutConstraint = {
        return self.collectionView.bottomAnchor
            .constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
    }()

    /**
     The leading anchor NSLayoutConstraint of the UICollectionView in the root UIView.
    */
    public lazy var leadingAnchorConstraint: NSLayoutConstraint = {
        return self.collectionView.leadingAnchor
            .constraint(equalTo: self.view.leadingAnchor, constant: 0.0)
    }()

    /**
     The trailing anchor NSLayoutConstraint of the UICollectionView in the root UIView.
    */
    public lazy var trailingAnchorConstraint: NSLayoutConstraint = {
        return self.collectionView.trailingAnchor
            .constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
    }()

    // MARK: Stored Properties
    // swiftlint:disable:next line_length
    public let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>> = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>>(
        configureCell: { (_, cv: UICollectionView, indexPath: IndexPath, component: AnyComponent) -> UICollectionViewCell in
            guard let cell = cv.dequeueReusableCell(
                withReuseIdentifier: ComponentCell.identifier,
                for: indexPath
            ) as? ComponentCell
                else { fatalError("Cell not registered to UICollectionView")}

            cell.configure(with: component)
            return cell
        }
    )

    /**
     The AnyComponent BehaviorRelay. Every time a new element is emitted by this Relay, the UICollectionView is refreshed.
    */
    internal let _components: BehaviorRelay<[AnyComponent]> = BehaviorRelay<[AnyComponent]>(value: [])

    /**
     When the collectionView is loaded, its width and height are initially all zero. When viewWillAppear is called, the views are sized.
     This Observable emits the nonzero sizes of UICollectionView when it changes. This may not work in some circumstances when this
     ComponentViewController is inside a custom Container UIViewController. If that happens override **width** and use **.exactly**.
    */
    internal lazy var _sizeObservable: Observable<CGSize> = self.collectionView.rx
        .observeWeakly(CGRect.self, "bounds", options: [KeyValueObservingOptions.new, KeyValueObservingOptions.initial])
        .filter({ (rect: CGRect?) -> Bool in
            return rect?.size != nil && rect?.size != CGSize.zero
        })
        .map({ (rect: CGRect?) -> CGSize in rect!.size })
        .distinctUntilChanged()

    internal private(set) var _size: CGSize = CGSize.zero

    // MARK: Computed Properties
    open var size: ComponentViewController.Size { return ComponentViewController.Size.automatic }

    // MARK: Views
    /**
     The UICollectionView instance managed by this ComponentViewController subclass.
    */
    public private(set) lazy var collectionView: UICollectionView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: self.createUICollectionViewLayout()
    )

    // MARK: Methods
    /**
     Creates an Observables based on ThrottleType and binds it to the AnyComponents Observables.

     It creates a new Observables based on the ViewModels' States and  BaseComponenVC's ThrottleType and
     binds it to the AnyComponents Observable so any new State change creates a new AnyComponents array
     which in turn updates the UICollectionView.

     - Parameters:
        - viewModels: The ViewModels whose States will be observed.
    */
    internal override func setUpObservables(with viewModels: [AnyViewModel]) {
        guard !viewModels.isEmpty else { return }
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

        let throttledStateObservable: Observable<(CGSize, [Any])> = self.setUpThrottleType(
            on: allObservables,
            throttleType: self.throttleType,
            scheduler: self.scheduler
        )
        .observeOn(self.scheduler)
        .subscribeOn(self.scheduler)
        .debug("\(type(of: self))", trimOutput: false)
        .share()

        // Call buildComponents method when a new element in combinedObservable is emitted
        // Bind the new AnyComponents array to the _components BehaviorRelay.
        // NOTE:
        // RxCollectionViewSectionedAnimatedDataSource.swift line 56.
        // UICollectionView has problems with fast updates. So, there is no point in
        // in executing operations in quick succession when it is throttled anyway.
        throttledStateObservable
            .map({ [weak self] (size: CGSize, _: [Any]) -> [AnyComponent] in
                guard let s = self else { return [] }
                s._size = size
                var controller: ComponentsController = ComponentsController(size: size)
                s.buildComponents(&controller)
                return controller.components
            })
            .bind(to: self._components)
            .disposed(by: self.disposeBag)

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

    }

    /**
     Creates the UICollectionViewLayout to be used by the UICollectionView managed by this ComponentViewController
     - Returns:
        A UICollectionViewLayout instance.
    */
    open func createUICollectionViewLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        return layout
    }

    /**
     Builds the AnyComponents array.

     This is where you create for logic to add Components to the ComponentsController data structure. This method is
     called every time the State of your ViewModels change. You can access the State(s) via the FFUFComponent enum's
     static functions.

     - Parameters:
        - componentsController: The ComponentsController that is mutated by this method. It is always
                                starts as an empty ComponentsController.
    */
    open func buildComponents(_ componentsController: inout ComponentsController) {}

    // MARK: UICollectionViewDelegateFlowLayout Methods
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if self._components.value.endIndex <= indexPath.item {
            return CGSize.zero
        }

        let layout: ComponentLayout = self._components.value[indexPath.item].layout

        let size: CGSize = CGSize(width: self._size.width, height: CGFloat.greatestFiniteMagnitude)

        let cellSize: CGSize = layout.measurement(within: size).size
        return cellSize
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let component: AnyComponent = self._components.value[indexPath.item]
        guard let selectable = component.identity.base as? Selectable else { return }
        selectable.onSelect()
    }

}

// MARK: - Size Enum
public extension ComponentViewController {

    /**
     In cases where ComponentViewController is a childViewController. It is sometimes necessary to have an exact size.
     This enum allows the the programmer to specify if there's an exact size for the ComponentViewController or if it should be taken
     cared of by UIKit.
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
