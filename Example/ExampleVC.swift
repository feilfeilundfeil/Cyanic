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
    let expandableMonitor: PublishRelay<(ExampleState.Expandable, Bool)> = PublishRelay<(ExampleState.Expandable, Bool)>()

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

        self.expandableMonitor
            .bind(onNext: { (section: ExampleState.Expandable, isExpanded: Bool) -> Void in
                self.viewModel.setState(block: { $0.expandableDict[section] = isExpanded })
            })
            .disposed(by: self.bag)
    }

    @objc
    public func buttonTapped() {
        self.viewModel.buttonWasTapped()
    }

    override func buildModels(state: ExampleState) -> [() -> [AnyComponent?]] {
        let s = self
        return [
            {
                guard state.isTrue else { return [] }
                return [StaticTextComponent(
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
                ).asAnyComponent()]
            },
            {
                var array: [AnyComponent] = []
                return self.resolveArray(&array, block: { (mutableArray: inout [AnyComponent]) -> Void in
                    let expandable = ExpandableComponent<ExampleState.Expandable>(
                        key: ExampleState.Expandable.first,
                        text: Text.unattributed("This is Expandable"),
                        height: 60.0,
                        insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0),
                        isExpanded: state.expandableDict[ExampleState.Expandable.first] ?? false,
                        relay: self.expandableMonitor
                    )

                    let randomColor: () -> UIColor = {
                        return UIColor.kio.color(red: UInt8.random(in: 0...255), green: UInt8.random(in: 0...255), blue: UInt8.random(in: 0...255))
                    }

                    let insets: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

                    mutableArray.append(expandable.asAnyComponent())

                    if expandable.isExpanded {
                        let items: [AnyComponent] = state.strings.enumerated()
                            .map {
                                return StaticTextComponent(
                                    id: "Text \($0.offset.description)",
                                    text: Text.unattributed($0.element),
                                    font: UIFont.systemFont(ofSize: 17.0),
                                    backgroundColor: randomColor(),
                                    insets: insets,
                                    style: AlacrityStyle<UITextView> { _ in }
                                ).asAnyComponent()
                            }

                        mutableArray.append(contentsOf: items)
                    }

                })
            },
            {
                return [StaticSpacingComponent(id: "Second", height: 50.0, backgroundColor: UIColor.lightGray).asAnyComponent()]
            },
            {
                let style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> {
                    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                    $0.setTitleColor(UIColor.black, for: UIControl.State.normal)
                }
                var components: [AnyComponent] = []
                return s.resolveArray(&components, block: { (array: inout [AnyComponent]) -> Void in

                    s.addComponent(to: &array, with: state, block: { (innerState: ExampleState) -> ButtonComponent? in
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

                    s.addComponent(to: &array, with: state, block: { (innerState) -> StaticSpacingComponent? in
                        return StaticSpacingComponent(
                            id: "Second",
                            height: 100.0,
                            backgroundColor: UIColor.brown
                        )
                    })

                    s.addComponents(to: &array, with: state, block: { (innerState: ExampleState) -> [ButtonComponent] in
                        return [

                            ButtonComponent(
                                title: "Second",
                                id: "Second",
                                height: 200.0,
                                backgroundColor: UIColor.orange,
                                style: style,
                                onTap: { print("Hello World, Second") }
                            ),
                            ButtonComponent(
                                title: "Third",
                                id: "Third",
                                height: 200.0,
                                backgroundColor: UIColor.yellow,
                                style: style,
                                onTap: { print("Hello World, Third") }
                            ),
                            ButtonComponent(
                                title: "Fourth",
                                id: "Fourth",
                                height: 200.0,
                                backgroundColor: UIColor.green,
                                style: style,
                                onTap: { print("Hello World, Fourth") }
                            ),
                            ButtonComponent(
                                title: "Fifth",
                                id: "Fifth",
                                height: 200.0,
                                backgroundColor: UIColor.blue,
                                style: style,
                                onTap: { print("Hello World, Fifth") }
                                ),
                            ButtonComponent(
                                title: "Sixth",
                                id: "Sixth",
                                height: 200.0,
                                backgroundColor: UIColor.purple,
                                style: style,
                                onTap: { print("Hello World, Sixth") }
                                ),
                            ButtonComponent(
                                title: "Seventh",
                                id: "Seventh",
                                height: 200.0,
                                backgroundColor: UIColor.brown,
                                style: style,
                                onTap: { print("Hello World, Seventh") }
                                ),
                            ButtonComponent(
                                title: "Eighth",
                                id: "Eighth",
                                height: 200.0,
                                backgroundColor: UIColor.white,
                                style: style,
                                onTap: { print("Hello World, Eighth") }
                                ),
                            ButtonComponent(
                                title: "Ninth",
                                id: "Ninth",
                                height: 200.0,
                                backgroundColor: UIColor.cyan,
                                style: style,
                                onTap: { print("Hello World, Ninth") }
                                ),
                            ButtonComponent(
                                title: "Tenth",
                                id: "Tenth",
                                height: 200.0,
                                backgroundColor: UIColor.gray,
                                style: style,
                                onTap: { print("Hello World, Tenth") }
                                ),
                        ]
                    })
                })
            }
        ]
    }
}

class ExampleViewModel: BaseViewModel<ExampleState> {

    func buttonWasTapped() {
        self.setState { $0.isTrue = !$0.isTrue }
    }

}

struct ExampleState: State {
    static var `default`: ExampleState {
        return ExampleState(
            isTrue: true,
            expandableDict: ExampleState.Expandable.allCases
                .reduce(into: [Expandable: Bool](), { (current, element) -> Void in
                    current[element] = false
                }
            ),
            strings: [
                """
                Bacon ipsum dolor amet short ribs jerky spare ribs jowl, ham hock t-bone turkey capicola pork tenderloin. Rump t-bone ground round short loin ribeye alcatra pork chop spare ribs pancetta sausage chuck. Turducken pork sausage landjaeger t-bone. Kevin ground round tail ribeye pig drumstick alcatra bacon sausage.
                """,
                """
                Brisket shank pork loin filet mignon, strip steak landjaeger bacon. Fatback swine bresaola frankfurter sausage, bacon venison jowl salami pork loin beef ribs chuck. Filet mignon corned beef pig frankfurter short loin cow pastrami cupim ham. Turducken pancetta kevin salami, shank boudin pastrami meatball flank filet mignon kielbasa spare ribs.

                Doner ham pancetta sausage beef ribs flank tail filet mignon. Turducken leberkas jerky sirloin, tongue doner shank pastrami cupim. Alcatra pork loin prosciutto brisket meatloaf, beef ribs cow pork belly burgdoggen. Corned beef tail pork belly short loin chuck drumstick.
                """,
                """
                Doner ham pancetta sausage beef ribs flank tail filet mignon. Turducken leberkas jerky sirloin, tongue doner shank pastrami cupim. Alcatra pork loin prosciutto brisket meatloaf, beef ribs cow pork belly burgdoggen. Corned beef tail pork belly short loin chuck drumstick.

                Salami landjaeger pork chop, burgdoggen beef hamburger short loin alcatra filet mignon capicola tail. Swine cow pork ham hock turkey shoulder short loin porchetta tail buffalo meatloaf shank ham frankfurter. Shoulder pork belly tenderloin turkey ball tip drumstick porchetta. Meatball bresaola spare ribs porchetta shoulder andouille pork buffalo picanha swine beef ribs. T-bone meatloaf chicken capicola, strip steak doner turducken pancetta tenderloin short ribs jerky drumstick brisket.

                Shankle cow beef, rump buffalo short loin sirloin t-bone. Bresaola capicola pork pork loin drumstick turkey pig ball tip strip steak sausage landjaeger biltong short loin. Turkey rump shoulder tri-tip landjaeger, corned beef drumstick flank t-bone. Burgdoggen meatloaf pastrami spare ribs pork loin ham hock turkey.
                """
            ]
        )
    }

    var isTrue: Bool
    var expandableDict: [ExampleState.Expandable: Bool]
    var strings: [String]

}

extension ExampleState {
    enum Expandable: String, CaseIterable {
        case first = "First Expandable"
    }
}


