//
//  BaseComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class Foundation.NSCoder
import class RxCocoa.BehaviorRelay
import class RxDataSources.RxCollectionViewSectionedAnimatedDataSource
import class RxSwift.DisposeBag
import class RxSwift.MainScheduler
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
import struct Foundation.IndexPath
import struct Foundation.DispatchQoS
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat
import struct Kio.MetaType
import struct RxDataSources.AnimatableSectionModel
import struct RxDataSources.AnimationConfiguration

/**
 The serial scheduler where the ViewModel's state changes are observed on and mapped to the _components
*/
internal let BaseComponentVCScheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(
    qos: DispatchQoS.userInitiated,
    internalSerialQueueName: "Scheduler",
    leeway: DispatchTimeInterval.milliseconds(100)
)

/**
 BaseComponentVC is a UIViewController with a UICollectionView managed by RxDataSources. It has most of the boilerplate needed to
 have a reactive UICollectionView. It respondes to new elements emitted by its ViewModel's state.

 BaseComponentVC is the delegate of the UICollectionView it manages and serves as the data source as well.
*/
open class BaseComponentVC<ConcreteState, ConcreteViewModel: ViewModelType>: UIViewController, UICollectionViewDelegateFlowLayout where ConcreteViewModel.StateType == ConcreteState {
    // swiftlint:disable:previous line_length

    // MARK: Initializers
    public init(layout: UICollectionViewLayout, cellTypes: [ComponentCell.Type], viewModel: ConcreteViewModel) {
        self.layout = layout
        self._cellTypes = Set<MetaType<ComponentCell>>(cellTypes.map(MetaType<ComponentCell>.init))
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController Lifecycle Methods
    override open func loadView() {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view = collectionView
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Register the required ConfigurationCell subclasses
        self._cellTypes.forEach { self.collectionView.register($0.base.self, forCellWithReuseIdentifier: $0.base.identifier) }

        // Set up as the UICollectionView's UICollectionViewDelegateFlowLayout, UICollectionViewDelegate and UIScrollViewDelegate
        self.collectionView.delegate = self

        // Delegate the UICollectionViewDataSource management to RxDataSources
        // swiftlint:disable:next line_length
        let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>> = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>>(
            configureCell: { (_, cv: UICollectionView, indexPath: IndexPath, component: AnyComponent) -> UICollectionViewCell in
                guard let cell = component.dequeueReusableCell(in: cv, as: component.cellType, for: indexPath) as? ComponentCell
                    else { fatalError("Cell not registered to UICollectionView")}

                cell.configure(with: component)
//                print("Cell Subviews: \(cell.contentView.subviews)")
                return cell
            }
        )

        let s: BaseComponentVC = self

        // Call buildModels method when a new element in ViewModel's state is emitted
        // Bind the new AnyComponents array to the _components BehaviorRelay
        // RxCollectionViewSectionedAnimatedDataSource.swift line 56.
        // UICollectionView has problems with fast updates. No point in
        // in executing operations when it is throttled anyway.
        self.viewModel.state.asObservable()
            .throttle(0.5, scheduler: BaseComponentVCScheduler)
            .observeOn(BaseComponentVCScheduler)
            .map { (state: ConcreteState) -> [AnyComponent] in
                var array: ComponentsArray = ComponentsArray()
                s.buildModels(state: state, components: &array)
                return array.components
            }
            .bind(to: self._components)
            .disposed(by: self.disposeBag)

        // When _components emits a new element, bind the new element to the UICollectionView.
        self._components.asDriver()
            .debug("Components", trimOutput: false)
            .map { [AnimatableSectionModel(model: "Test", items: $0)] }
            .drive(self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.reloadData()
    }

    // MARK: Stored Properties
    /**
     The layout of the UICollectionView
    */
    public let layout: UICollectionViewLayout

    /**
     The ViewModel instance that manages the business logic of this instance of BaseComponentVC
    */
    public let viewModel: ConcreteViewModel

    /**
     The AnyComponent BehaviorRelay. Every time a new element is emitted by this Relay, the UICollectionView is refreshed.
    */
    private let _components: BehaviorRelay<[AnyComponent]> = BehaviorRelay<[AnyComponent]>(value: [])
    private var _cellTypes: Set<MetaType<ComponentCell>>
    private let disposeBag: DisposeBag = DisposeBag()

    /**
     A Set containing the different kinds of ComponentCell subclasses registered for this UICollectionView.
    */
    public var cellTypes: Set<MetaType<ComponentCell>> { return self._cellTypes }

    // MARK: Views
    /**
     The UICollectionView instance managed by this BaseComponentVC subclass.
    */
    open var collectionView: UICollectionView { return self.view as! UICollectionView } // swiftlint:disable:this force_cast

    // MARK: Functions
    /**
     Adds a new ComponentCell subclass to the cellTypes Set and registers it to the UICollectionView if it doesn't have it.
     Otherwise, does nothing.
     - parameters:
        - cellType: The ComponentCell.Type
    */
    public final func add(cellType: ComponentCell.Type) {
        let newMetaType: MetaType<ComponentCell> = MetaType<ComponentCell>(cellType)
        guard !self._cellTypes.contains(newMetaType) else { return }

        self.collectionView.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
        self._cellTypes.insert(MetaType<ComponentCell>(cellType))
    }

    /**
     This method is responsible for creating the [AnyComponent] array.
     This is where you create for logic to add Components to the ComponentsArray data structure. This method is called every time the State
     of the ViewModel changes.

     - parameters:
        - state: The latest snapshot of the State object of the ViewModel
        - components: The ComponentsArray that is mutated by this method. It is always starts as an empty ComponentsArray.
    */
    open func buildModels(state: ConcreteState, components: inout ComponentsArray) {
        fatalError("You must override this")
    }

    // MARK: UICollectionViewDelegateFlowLayout Methods
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if self._components.value.endIndex <= indexPath.item {
            return CGSize.zero
        }

        let layout: ComponentLayout = self._components.value[indexPath.item].layout

        let size: CGSize = CGSize(width: Constants.screenWidth, height: CGFloat.greatestFiniteMagnitude)

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
