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

    func addButtonTapped() {
        self.setState(block: { $0.isTrue = true } )
    }

    func otherButtonTapped() {
        self.setState(block: { $0.isTrue = false } )
    }

}
class ViewModelB: BaseViewModel<StateB> {
    func addButtonTapped() {
        self.setState(block: { $0.isTrue = false })
    }

    func otherButtonTapped() {
        self.setState(block: { $0.isTrue = true })
    }
}


class CompositeVC: TwoViewModelComponentVC<StateA, ViewModelA, StateB, ViewModelB> {

    deinit {
        print("CompositeVC Deallocated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    @objc func addButtonTapped() {
        self.viewModelOne.addButtonTapped()
        self.viewModelTwo.addButtonTapped()
    }

    @objc func otherButtonTapped() {
        self.viewModelOne.otherButtonTapped()
        self.viewModelTwo.otherButtonTapped()
    }

    override func components(_ components: inout ComponentsArray, state1: StateA, state2: StateB) {
        let isTrue: Bool = state1.isTrue && state2.isTrue

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
                    $0.text = Text.unattributed(state1.isTrue ? "First state is true" : "False")
                    $0.backgroundColor = UIColor.gray
                    $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                    $0.font = UIFont.systemFont(ofSize: 17.0)
                    $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                }
        )

        components.add(
            StaticTextComponent(id: "Third")
                .copy {
                    $0.text = Text.unattributed(state2.isTrue ? "Second state is true" : "False")
                    $0.backgroundColor = UIColor.green
                    $0.style = AlacrityStyle<UITextView> { $0.textColor = UIColor.black }
                    $0.font = UIFont.systemFont(ofSize: 17.0)
                    $0.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                }
        )

    }

}
