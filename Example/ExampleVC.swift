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

    let relay: BehaviorRelay<Void> = BehaviorRelay<Void>(value: ())
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

        button.rx.tap
//            .map {
//                _ = self.components.removeFirst()
//            }
            .bind(to: self.relay)
            .disposed(by: self.bag)

        self.navigationItem.leftBarButtonItem = button

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.components.remove(at: 1)
            self.components.remove(at: 0)
        }
    }

}

class ExampleButtonComponent: ButtonComponent<Void> {

    override var layout: ComponentLayout {
        let state = self.identity as! ButtonComponentState
        return ButtonComponentLayout(
            type: ButtonLayoutType.custom,
            title: state.title.value,
            height: 100.0,
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

class ExampleButtonVM: ButtonComponentVM<Void> {

    override open var title: String {
        return UUID().uuidString
    }

    override open var color: UIColor {
        let int: Int = Int.random(in: 1...3)

        switch int {
            case 1:
                return .green
            case 2:
                return .orange
            default:
                return .yellow
        }
    }

    override open var isEnabled: Bool {
        return true
    }

}
