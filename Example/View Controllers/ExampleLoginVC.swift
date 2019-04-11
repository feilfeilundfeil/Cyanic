//
//  CompositeVC.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic
import Alacrity
import LayoutKit
import RxCocoa
import RxSwift

class ExampleLoginVC: ComponentViewController, UITextFieldDelegate {

    init(viewModelOne: ViewModelA, viewModelTwo: ViewModelB) {
        self.viewModelOne = viewModelOne
        self.viewModelTwo = viewModelTwo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("ExampleLoginVC Deallocated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.green

        self.kio.setUpNavigationItem {
            $0.rightBarButtonItems = [
                UIBarButtonItem(
                    title: "Second", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(ExampleLoginVC.addButtonTapped)
                ),
                UIBarButtonItem(
                    title: "Third", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(ExampleLoginVC.otherButtonTapped)
                )
            ].reversed()
        }
    }

    let viewModelOne: ViewModelA
    let viewModelTwo: ViewModelB
    private weak var userTextField: UITextField?
    private weak var passwordTextField: UITextField?
    private weak var activeTextField: UITextField?

    override var throttleType: ThrottleType { return ThrottleType.debounce(0.1) }
    override var viewModels: [AnyViewModel] {
        return [self.viewModelOne.asAnyViewModel, self.viewModelTwo.asAnyViewModel]
    }

    @objc func addButtonTapped() {
        self.viewModelOne.addButtonTapped()
        self.viewModelTwo.addButtonTapped()
    }

    @objc func otherButtonTapped() {
        self.viewModelOne.otherButtonTapped()
        self.viewModelTwo.otherButtonTapped()
    }

    override func buildComponents(_ componentsController: inout ComponentsController) {

        withState(
            viewModel1: self.viewModelOne,
            viewModel2: self.viewModelTwo
        ) { (state1: StateA, state2: StateB) -> Void in
            componentsController.staticSpacingComponent(configuration: { (component: inout StaticSpacingComponent) -> Void in
                component.height = 100.0
                component.backgroundColor = UIColor.white
                component.id = "First Spacing"
            })

            componentsController.textFieldComponent(configuration: { (component: inout TextFieldComponent) -> Void in
                let id: String = "UserName TextField"
                component.id = id
                component.insets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
                component.placeholder = "Enter Username"

                if !state1.userName.isEmpty {
                    component.text = state1.userName
                }

                component.backgroundColor = UIColor.red
                component.style = AlacrityStyle<UITextField> { [weak self] (textField: UITextField) -> Void in
                    textField.backgroundColor = UIColor.cyan
                    textField.tag = id.hashValue
                    guard let self = self else { return }
                    textField.delegate = self
                    self.userTextField = textField
                }

                component.textDidChange = { [weak self] (textField: UITextField) -> Void in
                    guard let self = self, let text = textField.text, text != state1.userName else { return }
                    self.viewModelOne.setUserName(text)
                }

                component.textFieldType = TestTextField.self
            })

            componentsController.textFieldComponent(configuration: { (component: inout TextFieldComponent) -> Void in
                let id = "Password TextField"
                component.id = "Password TextField"
                component.insets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
                component.placeholder = "Enter Password"

                if !state2.password.isEmpty {
                    component.text = state2.password
                }

                component.backgroundColor = UIColor.red
                component.style = AlacrityStyle<UITextField> { [weak self] (textField: UITextField) -> Void in
                    textField.backgroundColor = UIColor.cyan
                    textField.tag = id.hashValue

                    guard let self = self else { return }
                    textField.delegate = self
                    self.passwordTextField = textField
                }

                component.textDidChange = { [weak self] (textField: UITextField) -> Void in
                    guard let self = self, let text = textField.text, text != state2.password else { return }
                    self.viewModelTwo.setPassword(text)
                }

                component.textFieldType = TestTextField.self
            })
        }
    }

    // MARK: UITextFieldDelegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        print("New Active TextField \(self.activeTextField!.tag.hashValue)")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
        print("Removing Active TextField \(textField.tag.hashValue)")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
            case "UserName TextField".hashValue:
                self.userTextField?.resignFirstResponder()
                self.passwordTextField?.becomeFirstResponder()

            case "Password TextField".hashValue:
                self.passwordTextField?.resignFirstResponder()

            default:
                return true
        }

        return true
    }

}

public class TestTextField: UITextField {

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        var bounds: CGRect = super.textRect(forBounds: bounds)
        bounds.origin.x += 15.0
        return bounds
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var bounds: CGRect = super.editingRect(forBounds: bounds)
        bounds.origin.x += 15.0
        return bounds
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var bounds: CGRect = super.editingRect(forBounds: bounds)
        bounds.origin.x += 15.0
        return bounds
    }

}
