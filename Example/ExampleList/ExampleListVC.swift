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

        let isTrueButton: UIBarButtonItem = UIBarButtonItem(
            title: "isTrue",
            style: .plain,
            target: self,
            action: #selector(buttonTapped)
        )

        self.navigationItem.rightBarButtonItems = [navigationVCButton, isTrueButton]

        self.viewModel.selectSubscribe(
            keyPath1: \ExampleListState.hasTextInTextField,
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
    private weak var activeTextField: UITextField?

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
        let viewModel: ExampleListViewModel = self.viewModel
        Cyanic.withState(
            viewModel1: viewModel,
            viewModel2: self.childVCViewModel
        ) { [weak self] (state1: ExampleListState, state2: ChildVCState) -> Void in
            guard let self = self else { return }

            if state1.hasTextInTextField {
                
                components.textFieldComponent(configuration: { (component: inout TextFieldComponent) -> Void in
                    component.id = "TextField"
                    component.placeholder = "Hi"
                    if let value = state1.text.value {
                        component.text = value
                    }
                    component.configuration = { [weak self] (view: UITextField) -> Void in
                        guard let self = self, view.delegate !== self else {
                            return
                        }
                        view.delegate = self
                    }
                    component.editingChanged = { (view: UITextField) -> Void in
                        let hasTextInTextField: Bool = view.text?.isEmpty == false
                        viewModel.setState(with: {
                            $0.hasTextInTextField = hasTextInTextField
                        })
                    }
                })

                components.staticSpacingComponent {
                    $0.id = "Second"
                    $0.height = 50.0
                    $0.backgroundColor = UIColor.black
                }
            }

            if !state1.hasTextInTextField {
                components.staticSpacingComponent {
                    $0.id = "first"
                    $0.height = 50.0
                    $0.backgroundColor = UIColor.yellow
                }

                components.textFieldComponent(configuration: { (component: inout TextFieldComponent) -> Void in
                    component.id = "TextField"
                    component.placeholder = "Hi"
                    if let value = state1.text.value {
                        component.text = value
                    }

                    component.configuration = { [weak self] (view: UITextField) -> Void in
                        guard let self = self, view.delegate !== self else {
                            return
                        }
                        view.delegate = self
                    }
                    component.editingChanged = { (view: UITextField) -> Void in
                        let hasTextInTextField: Bool = view.text?.isEmpty == false
                        viewModel.setState(with: {
                            $0.hasTextInTextField = hasTextInTextField
                        })
                    }
                })
            }

            components.sizedComponent(configuration: { (component: inout SizedComponent) -> Void in
                component.id = "Fixed View"
                component.backgroundColor = UIColor.yellow
                component.viewClass = UILabel.self
                component.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
                component.height = 50.0
                component.configuration = { (view: UIView) -> Void in
                    guard let typedView = view as? UILabel else {
                        view.backgroundColor = UIColor.black
                        return
                    }
                    typedView.backgroundColor = UIColor.orange
                    print("Fixed View: \(typedView.bounds)")
                }
            })

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

            if state1.hasTextInTextField {
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
                    self?.viewModel.setState(with: { $0.hasTextInTextField = !$0.hasTextInTextField })
                }
            }

            if state1.hasTextInTextField {

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

extension ExampleListVC: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Did begin editting")
        self.activeTextField = textField
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        print("Did end editting")
        self.activeTextField = nil
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let text = textField.text, !text.isEmpty {

            self.viewModel.setState(with: { $0.text = .success(text) })

        } else {

            self.viewModel.setState(with: { $0.text = .uninitialized })

        }
        textField.resignFirstResponder()
        return true
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
