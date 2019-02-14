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
        self.requestBuildModels()


    }

    override func buildModels() -> [AnyComponent] {

        let style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        }



        return [
            ButtonComponent(title: "First", id: "First", height: 1000.0, backgroundColor: UIColor.blue, style: style, onTap: { print("Hello World, First") }),
            ButtonComponent(title: "Second", id: "Second", height: 200.0, backgroundColor: UIColor.yellow, style: style, onTap: { print("Hello World, Second") })
        ]
            .map(AnyComponent.init)
    }

}


