//
//  CompositeVC.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import FFUFComponents
import Alacrity
import LayoutKit
import RxCocoa
import RxSwift

struct StateA: State {

    static var `default`: StateA {
        return StateA(isTrue: true)
    }

    var isTrue: Bool

}

struct StateB: State {

    static var `default`: StateB {
        return StateB(isTrue: false)
    }

    var isTrue: Bool

}

class ViewModelA: BaseViewModel<StateA> {

}
class ViewModelB: BaseViewModel<StateB> {

}

class CompositeViewModel: BaseCompositeTwoViewModelType<
    StateA, ViewModelA,
    StateB, ViewModelB
> {

    func addButtonTapped() {
        self.first.setState(block: { $0.isTrue = true } )
        self.second.setState(block: { $0.isTrue = false })
    }

    func otherButtonTapped() {
        self.first.setState(block: { $0.isTrue = false } )
        self.second.setState(block: { $0.isTrue = true })
    }
    
}

class CompositeVC: BaseComponentVC<CompositeViewModel.CompositeState, CompositeViewModel> {

    deinit {
        print("CompositeVC Deallocated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.kio.setUpNavigationItem {
            $0.rightBarButtonItems = [
                UIBarButtonItem(
                    title: "Add", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(CompositeVC.addButtonTapped)
                ),
                UIBarButtonItem(
                    title: "Other", style: UIBarButtonItem.Style.plain,
                    target: self,
                    action: #selector(CompositeVC.otherButtonTapped)
                )
            ]
        }
    }

    @objc func addButtonTapped() {
        self.viewModel.addButtonTapped()
    }

    @objc func otherButtonTapped() {
        self.viewModel.otherButtonTapped()
    }

    override func buildModels(state: CompositeViewModel.CompositeState, components: inout ComponentsArray) {

        let isTrue: Bool = state.firstState.isTrue && state.secondState.isTrue

        components.add(
            StaticTextComponent(id: "First")
                .copy {
                    $0.text = Text.unattributed(isTrue ? "This should say true when both are true" : "False")
                    $0.backgroundColor = UIColor.red
                    $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                    $0.font = UIFont.systemFont(ofSize: 17.0)
                    $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                }
        )

        components.add(
            StaticTextComponent(id: "Second")
                .copy {
                    $0.text = Text.unattributed(state.firstState.isTrue ? "First state is true" : "False")
                    $0.backgroundColor = UIColor.gray
                    $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                    $0.font = UIFont.systemFont(ofSize: 17.0)
                    $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                }
        )

        components.add(
            StaticTextComponent(id: "Third")
                .copy {
                    $0.text = Text.unattributed(state.secondState.isTrue ? "Second state is true" : "False")
                    $0.backgroundColor = UIColor.green
                    $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                    $0.font = UIFont.systemFont(ofSize: 17.0)
                    $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                }
        )

    }

}
