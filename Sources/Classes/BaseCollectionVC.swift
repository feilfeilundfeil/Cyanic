//
//  BaseCollectionVC.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct Foundation.IndexPath
import class Foundation.NSCoder
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct Kio.MetaType
import class RxCocoa.BehaviorRelay
import struct RxDataSources.AnimatableSectionModel
import class RxDataSources.RxCollectionViewSectionedReloadDataSource
import class RxSwift.DisposeBag
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionViewLayout
import class UIKit.UIViewController

open class BaseCollectionVC: UIViewController {

    public init(layout: UICollectionViewLayout) {
        self.layout = layout
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
        self.cellTypes.forEach { self.collectionView.register($0.base.self, forCellWithReuseIdentifier: $0.base.identifier) }

        let dataSource: RxCollectionViewSectionedReloadDataSource<AnimatableSectionModel<String, AnyComponent>> = RxCollectionViewSectionedReloadDataSource<AnimatableSectionModel<String, AnyComponent>>(
            configureCell: { (_, cv: UICollectionView, indexPath: IndexPath, viewModel: AnyComponent) -> UICollectionViewCell in
                guard let cell = viewModel.dequeueReusableCell(in: cv, to: viewModel.cellType, for: indexPath) as? ConfigurableCell
                    else { fatalError("Cell not registered to UICollectionView")}

                cell.configure(with: viewModel)
                return cell
            }
        )

        self._components.asDriver()
            .map { [AnimatableSectionModel(model: "Test", items: $0)] }
            .drive(self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }

    // MARK: Stored Properties
    public let layout: UICollectionViewLayout
    private var _components: BehaviorRelay<[AnyComponent]> = BehaviorRelay<[AnyComponent]>(value: [])
    private var cellTypes: Set<MetaType<ConfigurableCell>> = []
    private let disposeBag: DisposeBag = DisposeBag()

    public var components: [AnyComponent] {
        get { return self._components.value }
        set { self._components.accept(newValue) }
    }

    // MARK: Views
    open var collectionView: UICollectionView { return self.view as! UICollectionView }

}
