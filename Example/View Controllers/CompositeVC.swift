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

class CompositeVC: ComponentViewController {

    init(viewModelOne: ViewModelA, viewModelTwo: ViewModelB) {
        self.viewModelOne = viewModelOne
        self.viewModelTwo = viewModelTwo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("CompositeVC Deallocated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white

        self.kio.setUpNavigationItem {
            $0.rightBarButtonItems = [
                UIBarButtonItem(
                    title: "Second", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(CompositeVC.addButtonTapped)
                ),
                UIBarButtonItem(
                    title: "Third", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(CompositeVC.otherButtonTapped)
                )
            ].reversed()
        }

        self.topConstraint.constant = -20.0
        self.view.layoutIfNeeded()
    }

    let viewModelOne: ViewModelA
    let viewModelTwo: ViewModelB

    override var throttleType: ThrottleType { return ThrottleType.debounce(0.1) }
    override var viewModels: [AnyViewModel] {
        return [AnyViewModel(self.viewModelOne), AnyViewModel(self.viewModelTwo)]
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
        let width: CGFloat = componentsController.width

        withState(
            viewModel1: self.viewModelOne,
            viewModel2: self.viewModelTwo
        ) { (state1: StateA, state2: StateB) -> Void in
            let isTrue: Bool = state1.isTrue && state2.isTrue
            componentsController.staticTextComponent {
                $0.id = "First"
                $0.text = Text.unattributed(isTrue ? "This should say true when both are true" : "False")
                $0.backgroundColor = UIColor.red
                $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                $0.font = UIFont.systemFont(ofSize: 17.0)
                $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                $0.width = width
            }

            componentsController.add(
                StaticTextComponent(id: "Second")
                    .copy {
                        $0.text = Text.unattributed(state1.isTrue ? "First state is true" : "False")
                        $0.backgroundColor = UIColor.gray
                        $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                        $0.font = UIFont.systemFont(ofSize: 17.0)
                        $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                        $0.width = width
                    }
            )

            componentsController.add(
                StaticTextComponent(id: "Third")
                    .copy {
                        $0.text = Text.unattributed(state2.isTrue ? "Second state is true" : "False")
                        $0.backgroundColor = UIColor.green
                        $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                        $0.font = UIFont.systemFont(ofSize: 17.0)
                        $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                        $0.width = width
                    }
            )

            componentsController.staticSpacingComponent {
                $0.id = "Blah"
                $0.backgroundColor = UIColor.yellow
                $0.height = 44.0
            }
        }
    }

}
