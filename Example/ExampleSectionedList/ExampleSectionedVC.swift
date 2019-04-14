//
//  ExampleSectionedVC.swift
//  Example
//
//  Created by Julio Miguel Alorro on 4/12/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import Cyanic
import Alacrity
import LayoutKit
import RxCocoa
import RxSwift

public final class ExampleSectionedVC: MultiSectionComponentViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white
    }

    // MARK: Stored Properties
    public let viewModel: ExampleSectionedViewModel = ExampleSectionedViewModel(initialState: ExampleSectionedState.default)

    // MARK: Overridden Properties
    public override var viewModels: [AnyViewModel] {
        return [self.viewModel.asAnyViewModel]
    }

    // MARK: Methods
    public override func createUICollectionViewLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }

    public override func buildSections(_ sectionsController: MultiSectionController) {

        withState(of: self.viewModel) { (state: ExampleSectionedState) -> Void in

            sectionsController.sectionController(with: { (sectionController: SectionController) -> Void in
                let expandableComponent: ExpandableComponent = sectionController.expandableComponent(
                    configuration: { (component: inout ExpandableComponent) -> Void in
                        let id: String = "First Section"
                        component.id = id

                        component.contentLayout = LabelContentLayout(
                            text: Text.unattributed(id),
                            font: UIFont.boldSystemFont(ofSize: 17.0),
                            alignment: Alignment.centerLeading,
                            style: AlacrityStyle<UILabel>{ (view: UILabel) -> Void in
                                view.textColor = UIColor.black
                            }
                        )
                        component.insets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 5.0)
                        component.backgroundColor = UIColor.lightGray
                        component.isExpanded = state.expandableDict[id] == true
                        component.setExpandableState =  { (id: String, isExpanded: Bool) -> Void in
                            self.viewModel.setExpandableState(id: id, isExpanded: isExpanded)

                            if state.expandableDict[id] == true {
                                if let attributes = self.collectionView.layoutAttributesForSupplementaryElement(
                                    ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
                                    self.collectionView.setContentOffset(
                                        CGPoint(x: 0, y: attributes.frame.origin.y - self.collectionView.contentInset.top),
                                        animated: true
                                    )
                                }
                            }
                        }
                    }
                )

                if expandableComponent.isExpanded {

                    sectionController.buildComponents({ (components:  ComponentsController) -> Void in
                        state.strings.enumerated().forEach { (offset: Int, value: String) -> Void in
                            components.staticTextComponent(configuration: { (component: inout StaticTextComponent) -> Void in
                                component.id = "First \(offset.description)"
                                component.text = Text.unattributed(value)
                                component.font = UIFont.systemFont(ofSize: 17.0)
                                component.backgroundColor = .white
                                component.insets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
                            })
                        }
                    })
                }
            })

            sectionsController.sectionController(with: { (sectionController: SectionController) -> Void in
                let expandableComponent: ExpandableComponent = sectionController.expandableComponent(
                    configuration: { (component: inout ExpandableComponent) -> Void in
                        let id: String = "Second Section"
                        component.id = id

                        component.contentLayout = LabelContentLayout(
                            text: Text.unattributed(id),
                            font: UIFont.boldSystemFont(ofSize: 17.0),
                            alignment: Alignment.centerLeading,
                            style: AlacrityStyle<UILabel>{ (view: UILabel) -> Void in
                                view.textColor = UIColor.black
                            }
                        )
                        component.insets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 5.0)
                        component.backgroundColor = UIColor.lightGray
                        component.isExpanded = state.expandableDict[id] == true
                        component.setExpandableState = { (id, isExpanded) in
                            self.viewModel.setExpandableState(id: id, isExpanded: isExpanded)

                            if state.expandableDict[id] == true {
                                if let attributes = self.collectionView.layoutAttributesForSupplementaryElement(
                                    ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) {
                                    self.collectionView.setContentOffset(
                                        CGPoint(x: 0, y: attributes.frame.origin.y - self.collectionView.contentInset.top),
                                        animated: true
                                    )
                                }
                            }
                        }
                    }
                )

                if expandableComponent.isExpanded {

                    sectionController.buildComponents({ (components:  ComponentsController) -> Void in
                        state.otherStrings.enumerated().forEach { (offset: Int, value: String) -> Void in
                            components.staticTextComponent(configuration: { (component: inout StaticTextComponent) -> Void in
                                component.id = "Second \(offset.description)"
                                component.text = Text.unattributed(value)
                                component.font = UIFont.systemFont(ofSize: 17.0)
                                component.backgroundColor = .white
                                component.insets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
                            })
                        }
                    })
                }
            })
        }
    }

}

public struct ExampleSectionedState: ExpandableState {

    public static var `default`: ExampleSectionedState {
        return ExampleSectionedState(
            expandableDict: [:],
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
            ],
            otherStrings: [
                """
                Godfather ipsum dolor sit amet. You can act like a man! I don't trust a doctor who can hardly speak English. What's wrong with being a lawyer? Te salut, Don Corleone. That's my family Kay, that's not me.
                """,
                """
                Do me this favor. I won't forget it. Ask your friends in the neighborhood about me. They'll tell you I know how to return a favor. Why did you go to the police? Why didn't you come to me first? I'm your older brother, Mike, and I was stepped over! It's not personal. It's business. Just when I thought I was out... they pull me back in.
                """,
                """
                It's an old habit. I spent my whole life trying not to be careless. Women and children can afford to be careless, but not men. What's the matter with you? Is this what you've become, a Hollywood finocchio who cries like a woman? "Oh, what do I do? What do I do?" What is that nonsense? Ridiculous! You talk about vengeance. Is vengeance going to bring your son back to you? Or my boy to me? I don't like violence, Tom. I'm a businessman; blood is a big expense.
                """
            ]
        )
    }

    public var expandableDict: [String: Bool]
    public var strings: [String]
    public var otherStrings: [String]
}

public final class ExampleSectionedViewModel: ExampleViewModel<ExampleSectionedState> {}
