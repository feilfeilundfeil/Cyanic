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
        self.view = UIView()
        self.view.backgroundColor = UIColor.white

        self.label = UILabel()
        self.label.textAlignment = .center
        self.label.text = self.count.description

        self.view.addSubview(self.label)
        self.label.center = self.view.center
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.kio.setUpNavigationItem { (item: UINavigationItem) -> Void in
            item.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                target: self,
                action: #selector(TestVC.addButtonItemTapped)
            )
        }

//        if self.presentingViewController != nil {
            let button: UIButton = UIButton(type: UIButton.ButtonType.system)
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.setTitle("Back", for: UIControl.State.normal)
            button.addTarget(self, action: #selector(TestVC.cancelButtonItemTapped), for: UIControl.Event.touchUpInside)
            button.frame = CGRect(origin: CGPoint(x: 100.0, y: 100.0), size: CGSize(width: 100.0, height: 44.0))
            button.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(button)
            self.view.bringSubviewToFront(button)
//        }
    }

    // MARK: Stored Properties
    private var label: UILabel!
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
        self.label.text = self.count.description
    }

    // MARK: Target Action Methods
    @objc func addButtonItemTapped() {
        self.viewModel.setState(with: { $0.changeCount += 1 })
    }

    @objc func cancelButtonItemTapped() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
