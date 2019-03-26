//
//  ComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxCocoa.BehaviorRelay
import class RxDataSources.RxCollectionViewSectionedAnimatedDataSource
import class RxSwift.DisposeBag
import class RxSwift.MainScheduler
import class RxSwift.Observable
import class RxSwift.SerialDispatchQueueScheduler
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionViewFlowLayout
import class UIKit.UICollectionViewLayout
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
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view = collectionView
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(ComponentCell.self, forCellWithReuseIdentifier: ComponentCell.identifier)

        // Set up as the UICollectionView's UICollectionViewDelegateFlowLayout,
        // UICollectionViewDelegate, and UIScrollViewDelegate
        self.collectionView.delegate = self

        // Delegate the UICollectionViewDataSource management to RxDataSources
        // swiftlint:disable:next line_length
        let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>> = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>>(
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

        // When _components emits a new element, bind the new element to the UICollectionView.
        self._components.asDriver()
            .map({ (components: [AnyComponent]) -> [AnimatableSectionModel<String, AnyComponent>] in
                return [AnimatableSectionModel(model: "Test", items: components)]
            })
            .drive(self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: Stored Properties
    /**
     The AnyComponent BehaviorRelay. Every time a new element is emitted by this Relay, the UICollectionView is refreshed.
    */
    internal let _components: BehaviorRelay<[AnyComponent]> = BehaviorRelay<[AnyComponent]>(value: [])

    /**
     When the view is loaded, its width and height are initially all zero. It is useful to observe these changes to
     determine the max width of the content inside the UICollectionView.
     The _width Observable listens to changes in the root UIVIew's bounds. It is used as the width when sizing the
     ComponentCell.

     This Observable is filtered so it doesn't repeat the duplicate values.
    */
    internal lazy var _width: Observable<CGFloat> = self.view.rx
        .observeWeakly(CGRect.self, "bounds", options: [KeyValueObservingOptions.new, KeyValueObservingOptions.initial])
        .filter({ (rect: CGRect?) -> Bool in rect?.width != nil && rect?.width != 0.0 })
        .map({ (rect: CGRect?) -> CGFloat in rect!.width })
        .distinctUntilChanged()

    internal private(set) var width: CGFloat = 0.0

    // MARK: Computed Properties
    /**
     The layout of the UICollectionView. This is not the exact instance as the one used in the UICollectionView but a copy.
     The instance used by the UICollectionView was injected via initializer in the loadView method.
    */
    open var layout: UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        return layout
    }

    // MARK: Views
    /**
     The UICollectionView instance managed by this ComponentViewController subclass.
    */
    open var collectionView: UICollectionView { return self.view as! UICollectionView } // swiftlint:disable:this force_cast

    // MARK: Functions
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
        let allObservables: Observable<(CGFloat, [Any])> = Observable.combineLatest(
            self._width, combinedStatesObservables
        )

        let throttledStateObservable: Observable<(CGFloat, [Any])> = self.setUpThrottleType(
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
            .map({ [weak self] (width: CGFloat, _: [Any]) -> [AnyComponent] in
                guard let s = self else { return [] }
                s.width = width
                var controller: ComponentsController = ComponentsController(width: width)
                s.buildComponents(&controller)
                return controller.components
            })
            .bind(to: self._components)
            .disposed(by: self.disposeBag)

        throttledStateObservable
            .map({ (width: CGFloat, states: [Any]) -> [Any] in
                let width: Any = width as Any
                return [width] + states
            })
            .bind(to: self.state)
            .disposed(by: self.disposeBag)

        throttledStateObservable
            .observeOn(MainScheduler.asyncInstance)
            .bind(
                onNext: { [weak self] (_: CGFloat, _: [Any]) -> Void in
                    self?.invalidate()
                }
            )
            .disposed(by: self.disposeBag)

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

        let size: CGSize = CGSize(width: self.width, height: CGFloat.greatestFiniteMagnitude)

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
