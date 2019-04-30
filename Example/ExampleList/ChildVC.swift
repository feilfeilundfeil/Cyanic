//
//  ChildVC.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic
import LayoutKit
import RxSwift
import UIKit

class ChildVC: MultiSectionTableComponentViewController, CyanicChildVCType {

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
        print("ChildVC deallocated")
    }

    // MARK: UIViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.brown
        self.tableView.isScrollEnabled = false
    }

    // MARK: Stored Properties
    private let viewModel: ChildVCViewModel

    // MARK: Computed Properties
    override var viewModels: [AnyViewModel] {
        return [
            self.viewModel.asAnyViewModel
        ]
    }

    override func buildSections(_ sectionsController: inout MultiSectionController) {
        Cyanic.withState(of: self.viewModel) { (state: ChildVCState) -> Void in

            sectionsController.sectionController(with: { (sectionController: inout SectionController) -> Void in
                let expandable = sectionController.expandableComponent(configuration: { (component: inout ExpandableComponent) -> Void in
                    let id: String = "First"
                    component.id = id
                    component.height = 60.0
                    component.contentLayout = LabelContentLayout(
                        text: Text.unattributed("Super Test for Child")
                    )
                    component.backgroundColor = UIColor.gray
                    component.isExpanded = state.expandableDict[id] ?? false
                    component.setExpandableState = { (id: String, isExpanded: Bool) -> Void in
                        self.viewModel.setState { (state: inout ChildVCState) -> Void in
                            state.expandableDict[id] = isExpanded
                            switch isExpanded {
                                case true:
                                    state.height = 280.0
                                case false:
                                    state.height = 60.0
                            }
                        }
                    }
                })

                if expandable.isExpanded {

                    sectionController.buildComponents({ (componentsController: inout ComponentsController) -> Void in
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
                    })
                }
            })
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

class ChildVCViewModel: ViewModel<ChildVCState> {
}
