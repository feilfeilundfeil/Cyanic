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

    let relay: BehaviorRelay = BehaviorRelay(value: "Test")
    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.components = [
            ExampleButtonComponent(model: relay, viewModelType: ExampleButtonVM.self).asAnyComponent(),
            ExampleButtonComponent(model: relay, viewModelType: ExampleButtonVM.self).asAnyComponent(),
            ExampleButtonComponent(model: relay, viewModelType: ExampleButtonVM.self).asAnyComponent(),
            ExampleButtonComponent(model: relay, viewModelType: ExampleButtonVM.self).asAnyComponent(),
        ]

        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: nil)

        button.rx.tap.map { () -> String in
            let rand = Int.random(in: 1...10)

            switch rand {
                case 1...5:
                    return "Hello"

                default:
                    return "World"
            }
        }
        .bind(to: self.relay)
        .disposed(by: self.bag)


        self.navigationItem.leftBarButtonItem = button
    }

    @objc func doneButtonTapped() {

    }


}

class ExampleButtonComponent: ButtonComponent<String> {

    override var layout: ComponentLayout {
        let state = self.identity as! ButtonComponentState
        return ButtonComponentLayout(
            type: ButtonLayoutType.custom,
            title: state.title.value,
            height: 44.0,
            contentEdgeInsets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 0.0, right: 5.0),
            flexibility: Flexibility.inflexible,
            viewReuseId: "Example Button",
            style: AlacrityStyle<UIButton> {
                $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                $0.setTitleColor(UIColor.black, for: UIControl.State.normal)
            },
            onTap: {
                print("Hello")
            },
            state: state
        )
    }

}

class ExampleButtonVM: ButtonComponentVM<String> {

    override open var title: String {
        return self.model
    }

    override open var color: UIColor {
        return UIColor.blue
    }

    override open var isEnabled: Bool {
        return true
    }

}
