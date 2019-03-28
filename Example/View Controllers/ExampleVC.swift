//
//  ViewController.swift
//  Example
//
//  Created by Julio Miguel Alorro on 2/7/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import Cyanic
import Alacrity
import LayoutKit
import RxCocoa
import RxSwift
import SideMenu

class ExampleVC: ComponentViewController {

    // MARK: Initializer
    init(viewModel: ExampleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white

        let button: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.done,
            target: self,
            action: #selector(buttonTapped)
        )
        self.navigationItem.leftBarButtonItem = button

        let navigationVCButton: UIBarButtonItem = UIBarButtonItem(
            title: "Nav",
            style: .plain,
            target: self,
            action: #selector(navButtonTapped)
        )

        let sideMenuButton: UIBarButtonItem = UIBarButtonItem(
            title: "Side",
            style: .plain,
            target: self,
            action: #selector(sideMenuButtonTapped)
        )

        self.navigationItem.rightBarButtonItems = [sideMenuButton, navigationVCButton]

        self.viewModel.selectSubscribe(
            keyPath1: \ExampleState.isTrue,
            keyPath2: \ExampleState.expandableDict,
            onNewValue: { print("from a different subscription: \($0)") }
        )

        let rightVC: UISideMenuNavigationController = UISideMenuNavigationController(
            rootViewController: CompositeVC(
                viewModelOne: ViewModelA(initialState: StateA.default),
                viewModelTwo: ViewModelB(initialState: StateB.default)
            )
        )

        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuRightNavigationController = rightVC
        SideMenuManager.default.menuLeftNavigationController = nil
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    
    }

    // MARK: Stored Properties
    let viewModel: ExampleViewModel

    // MARK: Computed Properties
    override var throttleType: ThrottleType { return ThrottleType.none }

    override var viewModels: [AnyViewModel] { return [self.viewModel.asAnyViewModel] }

    // MARK: Methods
    override func buildComponents(_ components: inout ComponentsController) {
        print("BUILD")
        let width: CGFloat = components.width

        withState(of: self.viewModel) { (state: ExampleState) -> Void in

            components.staticTextComponent {
                $0.id = "First"
                $0.text = Text.unattributed("Bacon")
                $0.font = UIFont.systemFont(ofSize: 17.0)
                $0.backgroundColor = UIColor.gray
                $0.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
                $0.style = AlacrityStyle<UITextView> {
                    $0.backgroundColor = UIColor.gray
                }
            }

            if state.isTrue {
                components.childVCComponent { [weak self] in
                    guard let s = self else { return }
                    $0.id = "Child"
                    $0.childVC = ChildVC()
                    $0.parentVC = s
                    $0.height = 200.0
                }
            }

            let expandableContentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            let insets: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            let firstID: String = ExampleState.Expandable.first.rawValue
            let firstExpandable: ExpandableComponent = components.expandableComponent { [weak self] in
                guard let s = self else { return }
                $0.id = firstID
                $0.contentLayout = ImageLabelContentLayout(
                    text: Text.unattributed("First Expandable"),
                    labelStyle: AlacrityStyle<UILabel> { $0.textColor = .green },
                    image: UIImage(),
                    imageSize: CGSize(width: 30.0, height: 30.0),
                    imageStyle: AlacrityStyle<UIImageView> { $0.backgroundColor = UIColor.green },
                    spacing: 16.0
                )
                $0.isExpanded = state.expandableDict[firstID] ?? false
                $0.setExpandableState = s.viewModel.setExpandableState
                $0.backgroundColor = UIColor.white
                $0.height = 55.0
                $0.width = 999_999_999.0
                $0.insets = expandableContentInsets
                $0.style = AlacrityStyle<UIView> { (view: UIView) -> Void in
                    let divider: UIView = UIView().avd.apply { $0.backgroundColor = UIColor.green }
                    view.addSubview(divider)
                    divider.frame = CGRect(x: 20.0, y: view.bounds.height - 5.0, width: view.bounds.width - 20.0, height: 5.0)
                    print("Subviews: \(view.subviews)")
                }
            }

            let randomColor: () -> UIColor = {
                return UIColor.kio.color(red: UInt8.random(in: 0...255), green: UInt8.random(in: 0...255), blue: UInt8.random(in: 0...255))
            }

            if firstExpandable.isExpanded {
                state.strings.enumerated().forEach { (offset: Int, element: String) -> Void in
                    components.staticTextComponent {
                        $0.id = "Text \(offset.description)"
                        $0.text = Text.unattributed(element)
                        $0.font = UIFont.systemFont(ofSize: 17.0)
                        $0.backgroundColor = randomColor()
                        $0.insets = insets
                        $0.width = width
                    }
                }
            }
            components.staticSpacingComponent {
                $0.id = "Second"
                $0.height = 50.0
                $0.backgroundColor = UIColor.black
            }

            let secondId: String = ExampleState.Expandable.second.rawValue

            let secondExpandable = components.expandableComponent { [weak self] in
                guard let s = self else { return }
                $0.id = secondId
                $0.contentLayout = LabelContentLayout(
                    text: Text.unattributed(
                        "This is also Expandable \(!state.isTrue ? "a dsio adsiopd aisopda sipo dsaiopid aosoipdas iopdas iop dasiopdasiods apopid asiodpai opdaiopdisa poidasopi dpoiad sopidsopi daspoi dapsoid opais dopiaps podai podaisop disaopi dposai dpodsa opidspoai saopid opaisdo aspodi paosjckaj jxknyjknj n" : "")"
                    )
                )
                $0.isExpanded = state.expandableDict[secondId] ?? false
                $0.setExpandableState = s.viewModel.setExpandableState
                $0.insets = expandableContentInsets
                $0.backgroundColor = UIColor.lightGray
                $0.height = 55.0
            }

            if secondExpandable.isExpanded {
                state.otherStrings.enumerated().forEach { (offset: Int, value: String) -> Void in
                    components.staticTextComponent {
                        $0.id = "Other \(offset.description)"
                        $0.text = Text.unattributed(value)
                        $0.font = UIFont.systemFont(ofSize: 17.0)
                        $0.backgroundColor = randomColor()
                        $0.insets = insets
                        $0.width = width
                    }
                }
            }

            let style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> {
                $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                $0.setTitleColor(UIColor.black, for: UIControl.State.normal)
                $0.layer.cornerRadius = 10.0
                $0.layer.backgroundColor = $0.backgroundColor?.cgColor
            }

            let buttonConfiguration: (String, UIColor, inout ButtonComponent) -> Void = { id, color, button in
                button.id = id
                button.title = id
                button.height = 200.0
                button.style = style.modifying(with: { $0.backgroundColor = color })
                button.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
                button.onTap = { print("Hello World, \(id)") }
            }

            if state.isTrue {
                components.buttonComponent {
                    buttonConfiguration("First", UIColor.red, &$0)
                }
            }

            components.staticSpacingComponent {
                $0.id = "Second"
                $0.height = 100.0
                $0.backgroundColor = UIColor.brown
            }

            components.buttonComponent {
                buttonConfiguration("Second", UIColor.orange, &$0)
            }

            components.buttonComponent {
                buttonConfiguration("Third", .yellow, &$0)
            }

            components.buttonComponent {
                buttonConfiguration("Fourth",.green, &$0)
            }

            components.buttonComponent {
                buttonConfiguration("Fifth", .blue, &$0)
            }
            components.buttonComponent {
                buttonConfiguration("Sixth",.purple, &$0)
            }
            components.buttonComponent {
               buttonConfiguration("Seventh",.brown, &$0)
            }
            components.buttonComponent {
                buttonConfiguration("Eighth",.white, &$0)
            }
            components.buttonComponent {
                buttonConfiguration("Ninth",.cyan, &$0)
            }
            components.buttonComponent {
                buttonConfiguration("Tenth", .gray, &$0)
            }
        }
    }

    // MARK: Target Action Methods
    @objc func buttonTapped() {
        self.viewModel.buttonWasTapped()
    }

    @objc func sideMenuButtonTapped() {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }

    @objc func navButtonTapped() {
        let vc: TestVC = TestVC()

        self.navigationController?.pushViewController(vc, animated: true)
    }
}