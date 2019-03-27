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

class TestVC: CyanicViewController {

    // MARK: UIViewController Lifecycle Methods
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

    // MARK: Stored Properties
    private var count: Int = 0
    private let viewModel: TestViewModel = TestViewModel(initialState: TestState.default)

    // MARK: Computed Properties
    override var viewModels: [AnyViewModel] {
        return [
            self.viewModel.asAnyViewModel
        ]
    }

    // MARK: Methods
    override func invalidate() {
        self.count += 1
        (self.view as! UILabel).text = self.count.description
    }

    // MARK: Target Action Methods
    @objc func addButtonItemTapped() {
        self.viewModel.setState(with: { $0.changeCount += 1 })
    }
}
