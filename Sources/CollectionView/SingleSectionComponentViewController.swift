//
//  SingleSectionComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxDataSources.RxCollectionViewSectionedAnimatedDataSource
import class RxSwift.Observable
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionViewLayout
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct Foundation.IndexPath
import struct RxDataSources.AnimatableSectionModel

/**
 SingleSectionComponentViewController is a UIViewController with a UICollectionView managed by RxDataSources. It has most of the
 boilerplate needed to have a reactive UICollectionView. It responds to new elements emitted by its ViewModel's state.
 SingleSectionComponentViewController is the delegate of the UICollectionView and serves as the UICollectionViewDataSource as well.
*/
open class SingleSectionComponentViewController: ComponentViewController {

    // MARK: Overridden UIViewController Lifecycle Methods
    open override func viewDidLoad() {
        super.viewDidLoad()

        // When _components emits a new element, bind the new element to the UICollectionView.
        self._components
            .map({ (components: [AnyComponent]) -> [AnimatableSectionModel<String, AnyComponent>] in
                return [AnimatableSectionModel<String, AnyComponent>(model: "Cyanic", items: components)]
            })
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

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

    // MARK: Methods
    open override func component(at indexPath: IndexPath) -> AnyComponent {
        let component: AnyComponent = self._components.value[indexPath.item]
        return component
    }

    internal typealias Element = (CGSize, [Any])

    internal override func setUpObservables(with viewModels: [AnyViewModel]) -> Observable<(CGSize, [Any])> {
        let throttledStateObservable: Observable<(CGSize, [Any])> = super.setUpObservables(with: viewModels)

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
                let controller: ComponentsController = ComponentsController(size: size)
                s.buildComponents(controller)
                return controller.components
            })
            .bind(to: self._components)
            .disposed(by: self.disposeBag)

        return throttledStateObservable
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
    open func buildComponents(_ componentsController: ComponentsController) {}

    // MARK: UICollectionViewDelegateFlowLayout Methods
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if self._components.value.endIndex <= indexPath.item {
            return CGSize.zero
        }

        let layout: ComponentLayout = self.component(at: indexPath).layout

        let size: CGSize = CGSize(width: self._size.width, height: CGFloat.greatestFiniteMagnitude)

        let cellSize: CGSize = layout.measurement(within: size).size
        return cellSize
    }

}
