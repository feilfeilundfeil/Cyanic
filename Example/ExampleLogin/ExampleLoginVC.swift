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

/**
 An example of a hypothetical login screen built in a SingleSectionComponentViewController. Example includes usage of UITextFieldDelegate.
*/
public final class ExampleLoginVC: SingleSectionComponentViewController {

    // MARK: Initializers
    /**
     An example custom initializer that demostrates dependency injection via initializer. One way to
     give a UIViewController its business logic controllers aka "ViewModels" in the context of Cyanic.
    */
    public init(viewModelOne: ExampleLoginViewModelA, viewModelTwo: ExampleLoginViewModelB) {
        self.viewModelOne = viewModelOne
        self.viewModelTwo = viewModelTwo
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("ExampleLoginVC Deallocated")
    }

    // MARK: UIViewController Lifecycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        self.kio.setUpNavigationItem {
            $0.rightBarButtonItems = [
                UIBarButtonItem(
                    title: "Second", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(ExampleLoginVC.secondButtonTapped)
                ),
                UIBarButtonItem(
                    title: "Third", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(ExampleLoginVC.thirdButtonTapped)
                )
            ].reversed()
        }
    }

    // MARK: Stored Properties
    private let viewModelOne: ExampleLoginViewModelA
    private let viewModelTwo: ExampleLoginViewModelB

    // MARK: TextFields
    private weak var userTextField: UITextField?
    private weak var passwordTextField: UITextField?
    private weak var activeTextField: UITextField?

    // MARK: Overridden SingleSectionComponentViewController Properties
    public override var throttleType: ThrottleType {
        return ThrottleType.debounce(0.1)
    }

    public override var viewModels: [AnyViewModel] {
        return [
            self.viewModelOne.asAnyViewModel,
            self.viewModelTwo.asAnyViewModel
        ]
    }

    // MARK: Overridden SingleSectionComponentViewController Methods
    public override func buildComponents(_ componentsController: inout ComponentsController) {

        withState(viewModel1: self.viewModelOne, viewModel2: self.viewModelTwo) { (state1: ExampleLoginStateA, state2: ExampleLoginStateB) -> Void in

            componentsController.staticSpacingComponent(configuration: { (component: inout StaticSpacingComponent) -> Void in
                component.height = 70.0
                component.id = "First Spacing"
            })

            componentsController.staticTextComponent(configuration: { (component: inout StaticTextComponent) -> Void in
                component.id = "Login Title"
                component.text = Text.unattributed("Login")
                component.alignment = Alignment.center
                component.font = UIFont.boldSystemFont(ofSize: 17.0)
            })

            componentsController.staticSpacingComponent(configuration: { (component: inout StaticSpacingComponent) -> Void in
                component.height = 70.0
                component.id = "Second Spacing"
            })

            componentsController.textFieldComponent(configuration: { (component: inout TextFieldComponent) -> Void in
                let id: String = "UserName TextField"
                component.id = id
                component.insets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
                component.placeholder = "Enter Username"

                if !state1.userName.isEmpty {
                    component.text = state1.userName
                }

                component.style = AlacrityStyle<UITextField> { [weak self] (textField: UITextField) -> Void in
                    textField.backgroundColor = UIColor.white
                    textField.kio.cornerRadius(of: 5.0)
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

            componentsController.staticSpacingComponent(configuration: { (component: inout StaticSpacingComponent) -> Void in
                component.height = 10.0
                component.id = "TextField interspacing"
            })

            componentsController.textFieldComponent(configuration: { (component: inout TextFieldComponent) -> Void in
                let id = "Password TextField"
                component.id = "Password TextField"
                component.insets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
                component.placeholder = "Enter Password"

                if !state2.password.isEmpty {
                    component.text = state2.password
                }

                component.style = AlacrityStyle<UITextField> { [weak self] (textField: UITextField) -> Void in
                    textField.backgroundColor = UIColor.white
                    textField.kio.cornerRadius(of: 5.0)
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

            componentsController.staticSpacingComponent(configuration: { (component: inout StaticSpacingComponent) -> Void in
                component.id = "Button to textField spacing"
                component.height = 20.0
            })

            componentsController.buttonComponent(configuration: { (component: inout ButtonComponent) -> Void in
                component.id = "Submit Button"
                component.alignment = Alignment.center
                component.height = 44.0
                component.title = "Submit"
                component.insets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)

                component.style = AlacrityStyle<UIButton> { (view: UIButton) -> Void in
                    view.backgroundColor = UIColor.red
                    view.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    view.kio.cornerRadius(of: 5.0)

                }

                component.onTap = {
                    print(
                        """
                        Username: \(state1.userName)
                        Password: \(state2.password)
                        """
                    )
                }
            })
        }
    }

}

// MARK: - Target Action Methods
private extension ExampleLoginVC {

    @objc func secondButtonTapped() {
        self.viewModelOne.secondButtonTapped()
        self.viewModelTwo.secondButtonTapped()
    }

    @objc func thirdButtonTapped() {
        self.viewModelOne.thirdButtonTapped()
        self.viewModelTwo.thirdButtonTapped()
    }

}

// MARK: - UITextFieldDelegate Methods
extension ExampleLoginVC: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        print("New Active TextField \(self.activeTextField!.tag.hashValue)")
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
        print("Removing Active TextField \(textField.tag.hashValue)")
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField.tag {
            case "UserName TextField".hashValue:
                self.userTextField?.resignFirstResponder()

                if self.passwordTextField?.text?.isEmpty == true {
                    self.passwordTextField?.becomeFirstResponder()
                }

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
        bounds.origin.x += 10.0
        return bounds
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var bounds: CGRect = super.editingRect(forBounds: bounds)
        bounds.origin.x += 10.0
        return bounds
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var bounds: CGRect = super.editingRect(forBounds: bounds)
        bounds.origin.x += 10.0
        return bounds
    }

    deinit {
        print("\(type(of: self)) was deallocated" )
    }

}
