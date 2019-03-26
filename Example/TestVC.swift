//
//  TestVC.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/24/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import Cyanic
import RxCocoa

class TestVC: BaseStateListeningVC {

    override func loadView() {
        let view = UILabel()
        view.backgroundColor = UIColor.white
        view.textAlignment = .center
        view.text = self.count.description
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.kio.setUpNavigationItem { (item: UINavigationItem) -> Void in
            item.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                target: self,
                action: #selector(TestVC.addButtonItemTapped))
        }

    }

    var count: Int = 0 {
        didSet {
            (self.view as! UILabel).text = self.count.description
        }
    }
    let viewModel: TestViewModel = TestViewModel(initialState: TestVC.TestState.default)

    override var viewModels: [AnyViewModel] {
        return [
            self.viewModel.asAnyViewModel
        ]
    }

    override func invalidate() {
        self.count += 1
    }

    @objc func addButtonItemTapped() {
        self.viewModel.setState(with: { $0.changeCount += 1 })
    }

    class TestViewModel: BaseViewModel<TestVC.TestState> {}

    struct TestState: State {

        static var `default`: TestState {
            return TestState(changeCount: 0)
        }

        var changeCount: Int

    }
}
