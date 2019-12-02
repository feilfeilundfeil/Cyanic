//
//  ChildVC.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic
import Differentiator
import LayoutKit
import RxCocoa
import RxSwift
import RxRelay
import RxDataSources
import UIKit

class ChildVC: SingleSectionTableComponentViewController, CyanicChildVCType {

    // MARK: Initializers
    init(viewModel: ChildVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("ChildVC Initlialized")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.cleanUp()
    }

    // MARK: UIViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.brown
        self.tableView.isScrollEnabled = false

        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.tableFooterView = UIView(
            frame: CGRect(
                origin: CGPoint.zero,
                size: CGSize(width: UIView.noIntrinsicMetric, height: 1.0)
            )
        )

        self.height
            .bind(onNext: { [weak self] (height: CGFloat) -> Void in
                self?.viewModel.setState(with: { $0.height = height })
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: Stored Properties
    private let viewModel: ChildVCViewModel
    private lazy var height = self.tableView.rx
        .observeWeakly(CGSize.self, "contentSize")
        .filter { $0 != nil && $0!.height != 0.0 && $0!.width != 0.0 }
        .map { $0!.height }
        .distinctUntilChanged()
        .debounce(RxTimeInterval.milliseconds(250), scheduler: self.scheduler)

    // MARK: Computed Properties
    override var viewModels: [AnyViewModel] {
        return [
            self.viewModel.asAnyViewModel
        ]
    }

    // MARK: Methods
    override func setUpDataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>> {
        let dataSource = super.setUpDataSource()
        dataSource.animationConfiguration = AnimationConfiguration(
            insertAnimation: UITableView.RowAnimation.fade,
            reloadAnimation: UITableView.RowAnimation.fade,
            deleteAnimation: UITableView.RowAnimation.fade
        )
        return dataSource
    }

    override func buildComponents(_ componentsController: inout ComponentsController) {
        Cyanic.withState(of: self.viewModel) { (state: ChildVCState) -> Void in
            let first = componentsController.expandableComponent(configuration: { (component: inout ExpandableComponent) -> Void in
                let id: String = "First"
                component.id = id
                component.height = 60.0
                component.contentLayout = LabelContentLayout(
                    text: Text.unattributed("Super Test for Child")
                )
                component.backgroundColor = UIColor.yellow
                component.isExpanded = state.expandableDict[id] ?? false
                component.setExpandableState = { [weak self] (id: String, isExpanded: Bool) -> Void in
                    self?.viewModel.setState { (state: inout ChildVCState) -> Void in
                        state.expandableDict[id] = isExpanded
                    }
                }
            })

            if first.isExpanded {
                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "0"
                    component.height = 44.0
                    component.backgroundColor = UIColor.green
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "1"
                    component.height = 44.0
                    component.backgroundColor = UIColor.blue
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "2"
                    component.height = 44.0
                    component.backgroundColor = UIColor.red
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "3"
                    component.height = 44.0
                    component.backgroundColor = UIColor.yellow
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "3"
                    component.height = 44.0
                    component.backgroundColor = UIColor.cyan
                }
            }

            let second = componentsController.expandableComponent(configuration: { (component: inout ExpandableComponent) -> Void in
                let id: String = "Second"
                component.id = id
                component.height = 60.0
                component.contentLayout = LabelContentLayout(
                    text: Text.unattributed("Super Test for Child")
                )
                component.backgroundColor = UIColor.yellow
                component.isExpanded = state.expandableDict[id] ?? false
                component.setExpandableState = { [weak self] (id: String, isExpanded: Bool) -> Void in
                    self?.viewModel.setState { (state: inout ChildVCState) -> Void in
                        state.expandableDict[id] = isExpanded
                    }
                }
            })

            if second.isExpanded {
                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "4"
                    component.height = 44.0
                    component.backgroundColor = UIColor.green
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "5"
                    component.height = 44.0
                    component.backgroundColor = UIColor.blue
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "6"
                    component.height = 44.0
                    component.backgroundColor = UIColor.red
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "7"
                    component.height = 44.0
                    component.backgroundColor = UIColor.yellow
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "8"
                    component.height = 44.0
                    component.backgroundColor = UIColor.cyan
                }
            }

            let third = componentsController.expandableComponent(configuration: { (component: inout ExpandableComponent) -> Void in
                let id: String = "Third"
                component.id = id
                component.height = 60.0
                component.contentLayout = LabelContentLayout(
                    text: Text.unattributed("Super Test for Child")
                )
                component.backgroundColor = UIColor.yellow
                component.isExpanded = state.expandableDict[id] ?? false
                component.setExpandableState = { [weak self] (id: String, isExpanded: Bool) -> Void in
                    self?.viewModel.setState { (state: inout ChildVCState) -> Void in
                        state.expandableDict[id] = isExpanded
                    }
                }
            })

            if third.isExpanded {
                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "9"
                    component.height = 44.0
                    component.backgroundColor = UIColor.green
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "10"
                    component.height = 44.0
                    component.backgroundColor = UIColor.blue
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "11"
                    component.height = 44.0
                    component.backgroundColor = UIColor.red
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "12"
                    component.height = 44.0
                    component.backgroundColor = UIColor.yellow
                }

                componentsController.staticSpacingComponent { (component: inout StaticSpacingComponent) -> Void in
                    component.id = "13"
                    component.height = 44.0
                    component.backgroundColor = UIColor.cyan
                }
            }
        }
    }
}

struct ChildVCState: ExpandableState {

    static var `default`: ChildVCState {
        return ChildVCState(height: 60.0, expandableDict: [:])
    }

    var height: CGFloat
    var expandableDict: [String: Bool]


}

class ChildVCViewModel: ExampleViewModel<ChildVCState> {
}
