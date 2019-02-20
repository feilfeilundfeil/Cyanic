//
//  BaseComponentVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct Foundation.IndexPath
import class Foundation.NSCoder
import struct Foundation.DispatchQoS
import enum Foundation.DispatchTimeInterval
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat
import struct Kio.MetaType
import class RxCocoa.BehaviorRelay
import struct RxDataSources.AnimatableSectionModel
import class RxDataSources.RxCollectionViewSectionedAnimatedDataSource
import struct RxDataSources.AnimationConfiguration
import enum RxDataSources.UITableViewRowAnimation
import class RxSwift.DisposeBag
import class RxSwift.MainScheduler
import class RxSwift.SerialDispatchQueueScheduler
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionViewLayout
import class UIKit.UICollectionViewFlowLayout
import protocol UIKit.UICollectionViewDelegateFlowLayout
import class UIKit.UIViewController
import RxDataSources

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
open class BaseComponentVC<ConcreteState: Equatable, ConcreteViewModel: BaseViewModel<ConcreteState>>: UIViewController, UICollectionViewDelegateFlowLayout {

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

    // MARK:  UIViewController Lifecycle Methods
    override open func loadView() {
        self.view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Register the required ConfigurationCell subclasses
        self._cellTypes.forEach { self.collectionView.register($0.base.self, forCellWithReuseIdentifier: $0.base.identifier) }

        // Set up as the UICollectionView's UICollectionViewDelegateFlowLayout, UICollectionViewDelegate and UIScrollViewDelegate
        self.collectionView.delegate = self

        // Delegate the UICollectionViewDataSource management to RxDataSources
        let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>> = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>>(
            configureCell: { (_, cv: UICollectionView, indexPath: IndexPath, component: AnyComponent) -> UICollectionViewCell in
                guard let cell = component.dequeueReusableCell(in: cv, as: component.cellType, for: indexPath) as? ComponentCell
                    else { fatalError("Cell not registered to UICollectionView")}

                cell.configure(with: component)
//                print("Cell Subviews: \(cell.contentView.subviews)")
                return cell
            }
        )

        let s = self

        // Call buildModels method when a new element in ViewModel's state is emitted
        // Bind the new AnyComponents array to the _components BehaviorRelay
        self.viewModel.state
            .throttle(0.5, latest: true, scheduler: BaseComponentVCScheduler)  // RxCollectionViewSectionedAnimatedDataSource.swift line 56.
            .observeOn(BaseComponentVCScheduler)                               // UICollectionView has problems with fast updates. No point in
            .map {                                                             // in executing operations when it is throttled anyway.
                var array: ComponentsArray = ComponentsArray()
                s.buildModels(state: $0, components: &array)
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

    // MARK: Stored Properties
    public let layout: UICollectionViewLayout
    public let viewModel: ConcreteViewModel
    private let _components: BehaviorRelay<[AnyComponent]> = BehaviorRelay<[AnyComponent]>(value: [])
    private var _cellTypes: Set<MetaType<ComponentCell>>
    private let disposeBag: DisposeBag = DisposeBag()    

    public var cellTypes: Set<MetaType<ComponentCell>> {
        return self._cellTypes
    }

    // MARK: Views
    open var collectionView: UICollectionView { return self.view as! UICollectionView }

    // MARK: Functions
    public final func add(cellType: ComponentCell.Type) {
        self.collectionView.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
        self._cellTypes.insert(MetaType<ComponentCell>(cellType))
    }

    open func buildModels(state: ConcreteState, components: inout ComponentsArray) {
        fatalError("Override")
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if self._components.value.endIndex <= indexPath.item {
            return CGSize.zero
        }

        let layout: ComponentLayout = self._components.value[indexPath.item].layout
        return layout.measurement(within: CGSize(width: Constants.screenWidth, height: CGFloat.greatestFiniteMagnitude)).size
    }

}
