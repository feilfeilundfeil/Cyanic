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
import Kio

class ExampleCounterVC: CyanicViewController {

    // MARK: UIViewController Lifecycle Methods
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)

        self.label = UILabel()
        self.label.textAlignment = .center
        self.label.text = self.count.description

        self.view.addSubview(self.label)
        self.label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.label.heightAnchor.constraint(equalToConstant: 50.0),
            self.label.widthAnchor.constraint(equalToConstant: 100.0),
            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.kio.setUpNavigationItem { (item: UINavigationItem) -> Void in
            item.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                target: self,
                action: #selector(ExampleCounterVC.addButtonItemTapped)
            )
        }

//        if self.presentingViewController != nil {
            let button: UIButton = UIButton(type: UIButton.ButtonType.system)
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.setTitle("Back", for: UIControl.State.normal)
            button.addTarget(self, action: #selector(ExampleCounterVC.cancelButtonItemTapped), for: UIControl.Event.touchUpInside)
            button.frame = CGRect(origin: CGPoint(x: 100.0, y: 100.0), size: CGSize(width: 100.0, height: 44.0))
            button.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(button)
            self.view.bringSubviewToFront(button)
//        }
    }

    // MARK: Stored Properties
    private var label: UILabel!
    private var count: Int = 0
    private let viewModel: ExampleCounterViewModel = ExampleCounterViewModel(initialState: ExampleCounterState.default)

    // MARK: Computed Properties
    override var viewModels: [AnyViewModel] {
        return [
            self.viewModel.asAnyViewModel
        ]
    }

    // MARK: Methods
    override func invalidate() {
        self.label.text = self.count.description
    }

    // MARK: Target Action Methods
    @objc func addButtonItemTapped() {
        self.count += 1
        let count: Int = self.count
        self.viewModel.setState(with: { $0.changeCount = count })
    }

    @objc func cancelButtonItemTapped() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
