//
//  MultiSectionComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import class RxDataSources.CollectionViewSectionedDataSource
import class RxDataSources.RxCollectionViewSectionedAnimatedDataSource
import class RxSwift.Observable
import class RxSwift.MainScheduler
import class UIKit.UICollectionView
import class UIKit.UICollectionReusableView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionViewLayout
import enum RxDataSources.ViewTransition
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct Foundation.IndexPath
import struct RxDataSources.AnimatableSectionModel

open class MultiSectionComponentViewController: ComponentViewController {

    // MARK: Overridden UIViewController Lifecycle Methods
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(
            ComponentSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ComponentSupplementaryView.identifier
        )

        // When _components emits a new element, bind the new element to the UICollectionView.
        self._sections
//            .observeOn(self.scheduler)
//            .subscribeOn(self.scheduler)
//            .observeOn(MainScheduler.asyncInstance)
//            .subscribeOn(MainScheduler.asyncInstance)
            .map({ (sections: MultiSectionController) -> [AnimatableSectionModel<AnyComponent, AnyComponent>] in
                let models: [AnimatableSectionModel<AnyComponent, AnyComponent>] = sections.sectionControllers
                    .map({ (section: SectionController) -> AnimatableSectionModel<AnyComponent, AnyComponent> in
                        return AnimatableSectionModel<AnyComponent, AnyComponent>(
                            model: section.sectionComponent,
                            items: section.componentsController.components
                        )
                    })
                return models
            })
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    // MARK: Stored Properties
    /**
     The SectionController BehaviorRelay. Every time a new element is emitted by this Relay, the UICollectionView is refreshed.
     */
    internal let _sections: BehaviorRelay<MultiSectionController> = BehaviorRelay<MultiSectionController>(
        value: MultiSectionController(size: CGSize.zero)
    )

    public let dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<AnyComponent, AnyComponent>> =
        RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<AnyComponent, AnyComponent>>(
            decideViewTransition: { _, _, _ in .animated },
            configureCell: { (_, cv: UICollectionView, indexPath: IndexPath, component: AnyComponent) -> UICollectionViewCell in
                guard let cell = cv.dequeueReusableCell(
                    withReuseIdentifier: ComponentCell.identifier,
                    for: indexPath
                ) as? ComponentCell
                    else { fatalError("Cell not registered to UICollectionView")}

                cell.configure(with: component)
                return cell
            },
            // swiftlint:disable:next line_length
            configureSupplementaryView: { (dataSource: CollectionViewSectionedDataSource<AnimatableSectionModel<AnyComponent, AnyComponent>>, cv: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView in
                let sectionModel: AnimatableSectionModel<AnyComponent, AnyComponent> = dataSource[indexPath.section]
                guard let view = cv.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ComponentSupplementaryView.identifier,
                    for: indexPath
                ) as? ComponentSupplementaryView
                    else { fatalError("Cell not registered to UICollectionView")}

                print("ID: \(sectionModel.model.id), IndexPath: \(indexPath)")

                print("DataSource: \(dataSource.sectionModels.map { $0.model.id }.joined(separator: ", ") )")

                view.configure(with: sectionModel.model)
                return view
            }
        )

    // MARK: Methods
    open override func component(at indexPath: IndexPath) -> AnyComponent? {
        guard let sectionController = self.sectionController(at: indexPath.section)
            else { return nil }

        guard indexPath.item < sectionController.componentsController.components.count
            else { return nil }

        let component: AnyComponent = sectionController.componentsController.components[indexPath.item]
        return component
    }
    /**
     Gets the SectionController at the specified index.
     - Parameters:
        - section: The index of the SectionController.
     - Returns:
        A SectionController or nil if the index is out of range.
    */
    public final func sectionController(at section: Int) -> SectionController? {
        guard section < self._sections.value.sectionControllers.count  else {
            return nil
        }

        let sectionController: SectionController = self._sections.value.sectionControllers[section]
        return sectionController
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
            .map({ [weak self] (size: CGSize, _: [Any]) -> MultiSectionController in
                guard let s = self else { return MultiSectionController(size: CGSize.zero) }
                s._size = size
                let controller: MultiSectionController = MultiSectionController(size: size)
                s.buildSections(controller)
                return controller
            })
            .bind(to: self._sections)
            .disposed(by: self.disposeBag)

        return throttledStateObservable
    }

    /**
     Builds the SectionController array.

     This is where you create the logic to add Components to the MultiSectionController data structure. This method is
     called every time the State(s) of your ViewModel(s) change. You can access the State(s) via the global withState methods.
     - Parameters:
        - sections: The MultiSectionController that is mutated by this method. It always
                    starts as an empty MultiSectionController.
    */
    open func buildSections(_ sectionsController: MultiSectionController) {}

    // MARK: UICollectionViewDelegateFlowLayout Methods
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if self._sections.value.sectionControllers.count < indexPath.section {
            return CGSize.zero
        }

        guard let layout = self.component(at: indexPath)?.layout
            else { return CGSize.zero }

        let size: CGSize = CGSize(width: self._size.width, height: CGFloat.greatestFiniteMagnitude)

        let cellSize: CGSize = layout.measurement(within: size).size
        return cellSize
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if self._sections.value.sectionControllers.count < section {
            return CGSize.zero
        }

        guard let layout = self.sectionController(at: section)?.sectionComponent?.layout
            else { return CGSize.zero }

        let size: CGSize = CGSize(width: self._size.width, height: CGFloat.greatestFiniteMagnitude)

        let headerSize: CGSize = layout.measurement(within: size).size
        return headerSize

    }
}
