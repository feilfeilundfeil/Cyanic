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

class ExampleVC: BaseCollectionVC {

    let relay: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: nil)
        let relay: BehaviorRelay<Bool> = self.relay
        button.rx.tap
            .map { () -> Bool in
                return !relay.value
            }
            .do(onNext: { [weak self] (value: Bool) -> Void in
                guard let s = self else { return }
                s.requestBuildModels()
            })
            .bind(to: relay)
            .disposed(by: self.bag)

        self.navigationItem.leftBarButtonItem = button
    }

    override func buildModels() -> [AnyComponent] {

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
                    return s.relay.value
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
                    return s.relay.value == false
                }
            )
        ]
            .map(AnyComponent.init)
    }

}


