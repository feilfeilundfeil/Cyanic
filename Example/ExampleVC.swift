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

class ExampleVC: BaseComponentVC<ExampleState, ExampleViewModel> {

    let bag: DisposeBag = DisposeBag()
    let expandableRelay: BehaviorRelay<(String, Bool)> = BehaviorRelay<(String, Bool)>(value: ("", false))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.purple

        let button: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.done,
            target: self,
            action: #selector(buttonTapped)
        )
        self.navigationItem.leftBarButtonItem = button

        self.expandableRelay
            .bind(onNext: { (arg: (String, Bool)) -> Void in
                let (name, isExpanded) = arg
                self.viewModel.setState(block: { $0.expandableDict[name] = isExpanded })
            })
            .disposed(by: self.bag)
    }

    @objc
    public func buttonTapped() {
        let newValue: Bool = !self.viewModel.currentState.isTrue
        self.viewModel.setState(block: { $0.isTrue = newValue })
    }

    override func buildModels(state: ExampleState) -> [ComponentResult] {
        let s = self
        return [
            ComponentResult.component({
                guard state.isTrue else { return nil }
                return StaticTextComponent(
                    id: "First",
                    text: Text.unattributed(
                        """
                        Bacon
                        """
                    ),
                    font: UIFont.systemFont(ofSize: 17.0),
                    backgroundColor: UIColor.gray,
                    insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                    style: AlacrityStyle<UITextView> {
                        $0.backgroundColor = UIColor.gray
                    }
                ).asAnyComponent()
            }),
            ComponentResult.components({
                var array: [AnyComponent] = []
                let expandable = ExpandableComponent(
                    text: Text.unattributed("This is Expandable"),
                    height: 60.0,
                    insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0),
                    isExpanded: state.expandableDict["This is Expandable"] ?? false,
                    subComponents: [
                        StaticTextComponent(
                            id: "1st sub",
                            text: Text.unattributed("Bacon ipsum dolor amet short ribs jerky spare ribs jowl, ham hock t-bone turkey capicola pork tenderloin. Rump t-bone ground round short loin ribeye alcatra pork chop spare ribs pancetta sausage chuck. Turducken pork sausage landjaeger t-bone. Kevin ground round tail ribeye pig drumstick alcatra bacon sausage."),
                            font: UIFont.systemFont(ofSize: 15.0),
                            backgroundColor: UIColor.gray,
                            insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0),
                            style: AlacrityStyle<UITextView>({ _ in })
                        ).asAnyComponent(),
                        StaticTextComponent(
                            id: "2nd sub",
                            text: Text.unattributed(
                                """
                                Brisket shank pork loin filet mignon, strip steak landjaeger bacon. Fatback swine bresaola frankfurter sausage, bacon venison jowl salami pork loin beef ribs chuck. Filet mignon corned beef pig frankfurter short loin cow pastrami cupim ham. Turducken pancetta kevin salami, shank boudin pastrami meatball flank filet mignon kielbasa spare ribs.

                                Doner ham pancetta sausage beef ribs flank tail filet mignon. Turducken leberkas jerky sirloin, tongue doner shank pastrami cupim. Alcatra pork loin prosciutto brisket meatloaf, beef ribs cow pork belly burgdoggen. Corned beef tail pork belly short loin chuck drumstick.
                                """
                            ),
                            font: UIFont.systemFont(ofSize: 15.0),
                            backgroundColor: UIColor.green,
                            insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0),
                            style: AlacrityStyle<UITextView>({ _ in })
                        ).asAnyComponent(),
                        StaticTextComponent(
                            id: "3rd sub",
                            text: Text.unattributed(
                                """
                                Doner ham pancetta sausage beef ribs flank tail filet mignon. Turducken leberkas jerky sirloin, tongue doner shank pastrami cupim. Alcatra pork loin prosciutto brisket meatloaf, beef ribs cow pork belly burgdoggen. Corned beef tail pork belly short loin chuck drumstick.

                                Salami landjaeger pork chop, burgdoggen beef hamburger short loin alcatra filet mignon capicola tail. Swine cow pork ham hock turkey shoulder short loin porchetta tail buffalo meatloaf shank ham frankfurter. Shoulder pork belly tenderloin turkey ball tip drumstick porchetta. Meatball bresaola spare ribs porchetta shoulder andouille pork buffalo picanha swine beef ribs. T-bone meatloaf chicken capicola, strip steak doner turducken pancetta tenderloin short ribs jerky drumstick brisket.

                                Shankle cow beef, rump buffalo short loin sirloin t-bone. Bresaola capicola pork pork loin drumstick turkey pig ball tip strip steak sausage landjaeger biltong short loin. Turkey rump shoulder tri-tip landjaeger, corned beef drumstick flank t-bone. Burgdoggen meatloaf pastrami spare ribs pork loin ham hock turkey.
                                """
                            ),
                            font: UIFont.systemFont(ofSize: 15.0),
                            backgroundColor: UIColor.blue,
                            insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0),
                            style: AlacrityStyle<UITextView>({ _ in })
                        ).asAnyComponent(),
                    ],
                    relay: self.expandableRelay
                )

                array.append(expandable.asAnyComponent())

                if let value = state.expandableDict["This is Expandable"], value {
                    array.append(contentsOf: expandable.subComponents)
                }

                return array
            }),
            ComponentResult.components({
                let style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> {
                    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                    $0.setTitleColor(UIColor.black, for: UIControl.State.normal)
                }
//                guard state.isTrue == false else { return [] }

                var componentsOnlyWhenisTrue: [AnyComponent] = []

                s.add(to: &componentsOnlyWhenisTrue, with: state, block: { (innerState: ExampleState) -> ButtonComponent? in
                    guard innerState.isTrue == false else { return nil }

                    return ButtonComponent(
                        title: "First",
                        id: "First",
                        height: 200.0,
                        backgroundColor: UIColor.red,
                        style: style,
                        onTap: { print("Hello World, First") }
                    )
                })

                return componentsOnlyWhenisTrue + [
                    StaticSpacingComponent(
                        id: "Second",
                        height: 100.0
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Second",
                        id: "Second",
                        height: 200.0,
                        backgroundColor: UIColor.orange,
                        style: style,
                        onTap: { print("Hello World, Second") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Third",
                        id: "Third",
                        height: 200.0,
                        backgroundColor: UIColor.yellow,
                        style: style,
                        onTap: { print("Hello World, Third") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Fourth",
                        id: "Fourth",
                        height: 200.0,
                        backgroundColor: UIColor.green,
                        style: style,
                        onTap: { print("Hello World, Fourth") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Fifth",
                        id: "Fifth",
                        height: 200.0,
                        backgroundColor: UIColor.blue,
                        style: style,
                        onTap: { print("Hello World, Fifth") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Sixth",
                        id: "Sixth",
                        height: 200.0,
                        backgroundColor: UIColor.purple,
                        style: style,
                        onTap: { print("Hello World, Sixth") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Seventh",
                        id: "Seventh",
                        height: 200.0,
                        backgroundColor: UIColor.brown,
                        style: style,
                        onTap: { print("Hello World, Seventh") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Eighth",
                        id: "Eighth",
                        height: 200.0,
                        backgroundColor: UIColor.white,
                        style: style,
                        onTap: { print("Hello World, Eighth") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Ninth",
                        id: "Ninth",
                        height: 200.0,
                        backgroundColor: UIColor.cyan,
                        style: style,
                        onTap: { print("Hello World, Ninth") }
                    ).asAnyComponent(),
                    ButtonComponent(
                        title: "Tenth",
                        id: "Tenth",
                        height: 200.0,
                        backgroundColor: UIColor.gray,
                        style: style,
                        onTap: { print("Hello World, Tenth") }
                    ).asAnyComponent(),
                ]
            })
        ]
    }
}

class ExampleViewModel: BaseViewModel<ExampleState> {

}

struct ExampleState: State {

    var isTrue: Bool
    var expandableDict: [String: Bool]

}


