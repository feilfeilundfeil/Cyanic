//
//  ModifiedRxDataSource.swift
//  Example
//
//  Created by Julio Miguel Alorro on 5/6/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Differentiator
import RxCocoa
import RxDataSources
import RxSwift

/**
 A subclass of RxTableViewSectionedAnimatedDataSource where the logic is mostly the same BUT performing the batch updates
 is different. In RxDatSources, the Diff alogorithm creates an array of ChangeSet objects that represents the changes to
 the collection, so in the original implementation, for each ChangeSet element, the UITableView is updated. In this
 modified subclass, the changes are looped through INSIDE the performBatchUpdate closure which means the UITableView
 is updated only once.

 This subclass exists because there's a weird UI bug where when you use collapsible headers and you do specific actions,
 the headers appear duplicated. The underlying data source is correct, but somewhere along the translation to UI,
 the update isn't reflected correctly.
*/
internal class ModifiedRxTableViewSectionedAnimatedDataSource<Section: AnimatableSectionModelType>
    // swiftlint:disable:previous type_name
: RxTableViewSectionedAnimatedDataSource<Section> {

    internal var dataSet = false

    // swiftlint:disable:next function_body_length
    internal override func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { (dataSource: ModifiedRxTableViewSectionedAnimatedDataSource<Section>, newSections: [Section]) -> Void in
            if !dataSource.dataSet {
                dataSource.dataSet = true
                dataSource.setSections(newSections)
                tableView.reloadData()
            } else {
                // if view is not in view hierarchy, performing batch updates will crash the app
                if tableView.window == nil {
                    dataSource.setSections(newSections)
                    tableView.reloadData()
                    return
                }

                let oldSections = dataSource.sectionModels
                do {
                    let differences: [Changeset<Section>] = try Diff
                        .differencesForSectionedView(initialSections: oldSections, finalSections: newSections)

                    switch dataSource.decideViewTransition(dataSource, tableView, differences) {
                    case .animated:
                        // each difference must be run in a separate 'performBatchUpdates', otherwise it crashes.
                        // this is a limitation of Diff tool

                        // This modification is from https://github.com/RxSwiftCommunity/RxDataSources/issues/271
                        if #available(iOS 11.0, *) {
                            tableView.performBatchUpdates({
                                for difference in differences {
                                    dataSource.setSections(difference.finalSections)
                                    performBatchUpdates(
                                        tableView,
                                        changes: difference,
                                        animationConfiguration: dataSource.animationConfiguration
                                    )

                                }
                            }, completion: nil)
                        } else {
                            tableView.beginUpdates()
                            for difference in differences {
                                dataSource.setSections(difference.finalSections)
                                performBatchUpdates(
                                    tableView,
                                    changes: difference,
                                    animationConfiguration: dataSource.animationConfiguration
                                )
                            }
                            tableView.endUpdates()
                        }

                    case .reload:
                        dataSource.setSections(newSections)
                        tableView.reloadData()
                        return
                    }
                } catch let e {
                    #if DEBUG
                    fatalError("\(e)")
                    #else
                    print(e)
                    #endif
                    dataSource.setSections(newSections)
                    tableView.reloadData()
                }
            }
            }.on(observedEvent)
    }
}
/**
 Duplicate of _performBatchUpdates in the UI+SectionedViewType.swift file in the RxDataSources library due to internal access level of
 method.
 */
fileprivate func performBatchUpdates<V: SectionedViewType, S>( // swiftlint:disable:this private_over_fileprivate
    _ view: V,
    changes: Changeset<S>,
    animationConfiguration: AnimationConfiguration
    ) {
    typealias I = S.Item // swiftlint:disable:this type_name

    view.deleteSections(changes.deletedSections, animationStyle: animationConfiguration.deleteAnimation)
    // Updated sections doesn't mean reload entire section, somebody needs to update the section view manually
    // otherwise all cells will be reloaded for nothing.
    //view.reloadSections(changes.updatedSections, animationStyle: rowAnimation)
    view.insertSections(changes.insertedSections, animationStyle: animationConfiguration.insertAnimation)
    for (from, to) in changes.movedSections {
        view.moveSection(from, to: to)
    }

    view.deleteItemsAtIndexPaths(
        changes.deletedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
        animationStyle: animationConfiguration.deleteAnimation
    )
    view.insertItemsAtIndexPaths(
        changes.insertedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
        animationStyle: animationConfiguration.insertAnimation
    )
    view.reloadItemsAtIndexPaths(
        changes.updatedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
        animationStyle: animationConfiguration.reloadAnimation
    )

    for (from, to) in changes.movedItems {
        view.moveItemAtIndexPath(
            IndexPath(item: from.itemIndex, section: from.sectionIndex),
            to: IndexPath(item: to.itemIndex, section: to.sectionIndex)
        )
    }
}
