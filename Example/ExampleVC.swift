//
//  ViewController.swift
//  Example
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import FFUFComponents
import Alacrity
import LayoutKit
import RxCocoa
import RxSwift

class ExampleVC: BaseCollectionVC<Bool, ExampleViewModel> {

    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = button
        button.rx.tap
            .map { () -> Bool in
                return !self.viewModel.currentState
            }
            .bind(to: self.viewModel.state)
            .disposed(by: self.bag)
    }

    override func buildModels(state: Bool) -> [AnyComponent] {

        let style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        }

        return [
            ButtonComponent(
                title: "First",
                id: "First",
                height: 200.0,
                backgroundColor: UIColor.blue,
                style: style,
                onTap: { print("Hello World, First") },
                isShown: { [weak self] () -> Bool in
                    guard let s = self else { return true }
                    return s.viewModel.currentState
                }
            ),
            ButtonComponent(
                title: "Second",
                id: "Second",
                height: 200.0,
                backgroundColor: UIColor.yellow,
                style: style,
                onTap: { print("Hello World, Second") },
                isShown: { [weak self] () -> Bool in
                    guard let s = self else { return true }
                    return s.viewModel.currentState == false
                }
            ),
            ButtonComponent(
                title: "Third",
                id: "Third",
                height: 200.0,
                backgroundColor: UIColor.orange,
                style: style,
                onTap: { print("Hello World, First") },
                isShown: { [weak self] () -> Bool in
                    guard let s = self else { return true }
                    return s.viewModel.currentState == false
                }
            ),
            ButtonComponent(
                title: "Fourth",
                id: "Fourth",
                height: 200.0,
                backgroundColor: UIColor.green,
                style: style,
                onTap: { print("Hello World, First") },
                isShown: { [weak self] () -> Bool in
                    guard let s = self else { return true }
                    return s.viewModel.currentState == false
                }
            ),
        ]
            .map(AnyComponent.init)
    }

}

class ExampleViewModel: BaseViewModel<Bool> {

}


