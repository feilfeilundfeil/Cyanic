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

class ExampleVC: BaseCollectionVC<ExampleState, ExampleViewModel> {

    let bag: DisposeBag = DisposeBag()

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
    }

    @objc
    public func buttonTapped() {
        let newValue: Bool = !self.viewModel.currentState.isTrue
        self.viewModel.setState(block: { $0.isTrue = newValue })
    }

    override func buildModels(state: ExampleState) -> [AnyComponent] {
        print("Current State: \(state.isTrue)")
        let style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            $0.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }

        let randomColor: () -> UIColor = {
            let randomInt: () -> UInt8 = {
                return UInt8.random(in: 0...255)
            }

            return UIColor.kio.color(red: randomInt(), green: randomInt(), blue: randomInt())
        }

        return [
             // You must call asAnyComponent here otherwise Swift's compiler gets confused
            StaticTextComponent(
                id: "First",
                text: Text.unattributed(
                    """
                    Bacon ipsum dolor amet short ribs jerky spare ribs jowl, ham hock t-bone turkey capicola pork tenderloin. Rump t-bone ground round short loin ribeye alcatra pork chop spare ribs pancetta sausage chuck. Turducken pork sausage landjaeger t-bone. Kevin ground round tail ribeye pig drumstick alcatra bacon sausage.

                    Brisket shank pork loin filet mignon, strip steak landjaeger bacon. Fatback swine bresaola frankfurter sausage, bacon venison jowl salami pork loin beef ribs chuck. Filet mignon corned beef pig frankfurter short loin cow pastrami cupim ham. Turducken pancetta kevin salami, shank boudin pastrami meatball flank filet mignon kielbasa spare ribs.

                    Doner ham pancetta sausage beef ribs flank tail filet mignon. Turducken leberkas jerky sirloin, tongue doner shank pastrami cupim. Alcatra pork loin prosciutto brisket meatloaf, beef ribs cow pork belly burgdoggen. Corned beef tail pork belly short loin chuck drumstick.

                    Salami landjaeger pork chop, burgdoggen beef hamburger short loin alcatra filet mignon capicola tail. Swine cow pork ham hock turkey shoulder short loin porchetta tail buffalo meatloaf shank ham frankfurter. Shoulder pork belly tenderloin turkey ball tip drumstick porchetta. Meatball bresaola spare ribs porchetta shoulder andouille pork buffalo picanha swine beef ribs. T-bone meatloaf chicken capicola, strip steak doner turducken pancetta tenderloin short ribs jerky drumstick brisket.

                    Shankle cow beef, rump buffalo short loin sirloin t-bone. Bresaola capicola pork pork loin drumstick turkey pig ball tip strip steak sausage landjaeger biltong short loin. Turkey rump shoulder tri-tip landjaeger, corned beef drumstick flank t-bone. Burgdoggen meatloaf pastrami spare ribs pork loin ham hock turkey.
                    """
                ),
                font: UIFont.systemFont(ofSize: 17.0),
                insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                style: AlacrityStyle<UITextView> {
                    $0.backgroundColor = UIColor.gray
                },
                isShown: { () -> Bool in
                    return state.isTrue
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "First",
                id: "First",
                height: 200.0,
                backgroundColor: UIColor.red,
                style: style,
                onTap: { print("Hello World, First") },
                isShown: { () -> Bool in
                    return state.isTrue
                }
            ).asAnyComponent(),
            StaticSpacingComponent(
                id: "Second",
                height: 20.0,
                isShown: { () -> Bool in
                    return state.isTrue == false
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Second",
                id: "Second",
                height: 200.0,
                backgroundColor: UIColor.orange,
                style: style,
                onTap: { print("Hello World, Second") },
                isShown: { () -> Bool in
                    return state.isTrue == false
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Third",
                id: "Third",
                height: 200.0,
                backgroundColor: UIColor.yellow,
                style: style,
                onTap: { print("Hello World, Third") },
                isShown: { () -> Bool in
                    return state.isTrue
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Fourth",
                id: "Fourth",
                height: 200.0,
                backgroundColor: UIColor.green,
                style: style,
                onTap: { print("Hello World, Fourth") },
                isShown: { [weak self] () -> Bool in
                    guard let s = self else { return true }
                    return s.viewModel.currentState.isTrue == false
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Fifth",
                id: "Fifth",
                height: 200.0,
                backgroundColor: UIColor.blue,
                style: style,
                onTap: { print("Hello World, Fifth") },
                isShown: { () -> Bool in
                    return state.isTrue
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Sixth",
                id: "Sixth",
                height: 200.0,
                backgroundColor: UIColor.purple,
                style: style,
                onTap: { print("Hello World, Sixth") },
                isShown: { () -> Bool in
                    return state.isTrue == false
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Seventh",
                id: "Seventh",
                height: 200.0,
                backgroundColor: UIColor.brown,
                style: style,
                onTap: { print("Hello World, Seventh") },
                isShown: { () -> Bool in
                    return state.isTrue
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Eighth",
                id: "Eighth",
                height: 200.0,
                backgroundColor: UIColor.white,
                style: style,
                onTap: { print("Hello World, Eighth") },
                isShown: { () -> Bool in
                    return state.isTrue == false
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Ninth",
                id: "Ninth",
                height: 200.0,
                backgroundColor: UIColor.cyan,
                style: style,
                onTap: { print("Hello World, Ninth") },
                isShown: { () -> Bool in
                    return state.isTrue
                }
            ).asAnyComponent(),
            ButtonComponent(
                title: "Tenth",
                id: "Tenth",
                height: 200.0,
                backgroundColor: UIColor.gray,
                style: style,
                onTap: { print("Hello World, Tenth") },
                isShown: { () -> Bool in
                    return state.isTrue == false
                }
            ).asAnyComponent(),
        ]
    }

}

class ExampleViewModel: BaseViewModel<ExampleState> {

}

struct ExampleState: State {

    var isTrue: Bool

}


