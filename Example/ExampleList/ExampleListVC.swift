//
//  ViewController.swift
//  Example
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import Cyanic
import Alacrity
import LayoutKit
import RxCocoa
import RxDataSources
import RxSwift
import SideMenu

public final class ExampleListVC: SingleSectionCollectionComponentViewController {

    // MARK: Initializer
    public init(viewModel: ExampleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController Lifecycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white

        let navigationVCButton: UIBarButtonItem = UIBarButtonItem(
            title: "MultiSectionVC",
            style: .plain,
            target: self,
            action: #selector(showMultiSectionVC)
        )

        self.navigationItem.rightBarButtonItems = [navigationVCButton]

        self.viewModel.selectSubscribe(
            keyPath1: \ExampleListState.isTrue,
            keyPath2: \ExampleListState.expandableDict,
            onNewValue: {
                print("from a different subscription: \($0)")
            }
        )
    
    }

    // MARK: Stored Properties
    private let viewModel: ExampleListViewModel
    private let childVCViewModel: ChildVCViewModel = ChildVCViewModel(initialState: ChildVCState.default)
    private lazy var childVC: ChildVC = ChildVC(viewModel: self.childVCViewModel)

    // MARK: Overridden SingleSectionComponentViewController Properties
    public override var viewModels: [AnyViewModel] {
        return [
            self.viewModel.asAnyViewModel,
            self.childVCViewModel.asAnyViewModel
        ]
    }

    // MARK: Overridden CollectionComponentViewController Methods
    public override func createUICollectionViewLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = CyanicNoFadeFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        return layout
    }

    public override func buildComponents(_ components: inout ComponentsController) {
        let childVC: ChildVC = self.childVC
        Cyanic.withState(
            viewModel1: self.viewModel,
            viewModel2: self.childVCViewModel
        ) { (state1: ExampleListState, state2: ChildVCState) -> Void in
            components.staticSpacingComponent {
                $0.id = "Second"
                $0.height = 50.0
                $0.backgroundColor = UIColor.black
            }

            let style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> {
                $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                $0.setTitleColor(UIColor.black, for: UIControl.State.normal)
            }

            let buttonConfiguration: (String, UIColor, inout ButtonComponent) -> Void = { id, color, button in
                button.id = id
                button.title = "This is a UIButton"
                button.height = 44.0
                button.configuration = style.modifying(with: { $0.backgroundColor = color }).style
                button.onTap = { print("Hello World, \(id)") }
            }

            if state1.isTrue {
                components.buttonComponent {
                    buttonConfiguration("First", UIColor.red, &$0)
                }
            }

            components.staticSpacingComponent {
                $0.id = "Second"
                $0.height = 100.0
                $0.backgroundColor = UIColor.brown
            }

            components.buttonComponent { (component: inout ButtonComponent) -> Void in
                component.id = "Show"
                component.title = "Show side menu"
                component.height = 44.0
                component.configuration = { (view: UIButton) -> Void in
                    view.backgroundColor = UIColor.orange
                    view.setTitleColor(UIColor.black, for: UIControl.State.normal)
                }
                component.onTap = { [weak self] () -> Void in
                    guard
                        let vc = SideMenuManager.default.menuRightNavigationController,
                        let s = self
                    else { return }
                    s.present(vc, animated: true, completion: nil)
                }
            }

            components.buttonComponent { (component: inout ButtonComponent) -> Void in
                component.id = "Toggle"
                component.title = "Toggle isTrue"
                component.height = 44.0
                component.configuration = { (view: UIButton) -> Void in
                    view.backgroundColor = UIColor.yellow
                    view.setTitleColor(UIColor.black, for: UIControl.State.normal)
                }
                component.onTap = { [weak self] () -> Void in
                    self?.viewModel.setState(with: { $0.isTrue = !$0.isTrue })
                }
            }

            if state1.isTrue {

                components.childVCComponent { [weak self] in
                    guard let s = self else { return }
                    $0.id = "Child"
                    $0.childVC = childVC
                    $0.parentVC = s
                    $0.height = state2.height
                }
            }

            components.staticSpacingComponent {
                $0.id = "blah"
                $0.height = 500.0
                $0.backgroundColor = UIColor.cyan
            }
        }
    }

}

// MARK: - Target Action Methods
private extension ExampleListVC {
    @objc func buttonTapped() {
        self.viewModel.buttonWasTapped()
    }

    @objc func sideMenuButtonTapped() {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }

    @objc func showMultiSectionVC() {
        let vc: ExampleSectionedVC = ExampleSectionedVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
