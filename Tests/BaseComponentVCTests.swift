//
//  BaseComponentVCTests.swift
//  Tests
//
//  Created by Julio Miguel Alorro on 3/24/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Quick
import Nimble
import LayoutKit
import RxCocoa
@testable import Cyanic

class ComponentViewControllerTests: QuickSpec {

    override func spec() {
        describe("SingleSectionCollectionComponentViewController functionality") {
            context("When CyanicComponentViewController is initialized and view is loaded") {
                let vc: ComponentViewControllerTests.TestVC = ComponentViewControllerTests.TestVC()
                vc.loadView()
                vc.collectionView.dataSource = nil // Make this nil before calling viewDidLoad otherwise throws

                // Fake a width so buildComponents is called.
                vc._sizeObservable = BehaviorRelay<CGSize>(value: CGSize(width: 555.0, height: 675.0)).asObservable()

                vc.viewDidLoad()

                it("should call invalidate and buildComponents to get the intial state") {
                    expect(vc.invalidateCount).toEventually(equal(1))
                    expect(vc.buildComponentsCount).toEventually(equal(1))
                }

                it("should call invalidate and buildComponents when any viewModel's state changes") {
                    vc.viewModelOne.setState(with: { $0.changeCount += 1 })
                    expect(vc.invalidateCount).toEventually(equal(2))
                    expect(vc.buildComponentsCount).toEventually(equal(2))
                    expect(vc.viewModelOne.currentState.changeCount).toEventually(equal(1))

                    vc.viewModelTwo.setState(with: { $0.changeCount += 1})
                    expect(vc.invalidateCount).toEventually(equal(3))
                    expect(vc.buildComponentsCount).toEventually(equal(3))
                    expect(vc.viewModelTwo.currentState.changeCount).toEventually(equal(1))
                }

                it("should have 2 components displayed on its UICollectionView if viewModelOne's currentState.showStaticText == false") {
                    expect(vc.collectionView.numberOfItems(inSection: 0)).toEventually(equal(2))
                    expect(vc.viewModelOne.currentState.showStaticText).to(equal(false))
                }

                it("should have 3 components displayed on its UICollectionView if viewModelOne's currentState.showStaticText == true") {
                    vc.viewModelOne.setState(with: { $0.showStaticText = true })
                    expect(vc.collectionView.numberOfItems(inSection: 0)).toEventually(equal(3))
                    expect(
                        vc.viewModelOne.currentState.showStaticText)
                            .toEventually(
                                equal(true),
                                timeout: 0.5,
                                pollInterval: 0.5
                            )
                }
            }
        }
    }

    class TestVC: SingleSectionCollectionComponentViewController {

        var invalidateCount: Int = 0
        var buildComponentsCount: Int = 0
        let viewModelOne: TestViewModel1 = TestViewModel1(initialState: TestVC.TestState1.default)
        let viewModelTwo: TestViewModel2 = TestViewModel2(initialState: TestVC.TestState2.default)

        override var viewModels: [AnyViewModel] {
            return [
                self.viewModelOne.asAnyViewModel,
                self.viewModelTwo.asAnyViewModel
            ]
        }

        override func invalidate() {
            self.invalidateCount += 1
        }

        override func buildComponents(_ componentsController: inout ComponentsController) {
            self.buildComponentsCount += 1
            withState(
                viewModel1: self.viewModelOne,
                viewModel2: self.viewModelTwo
            ) { (stateOne: TestState1, stateTwo: TestState2) -> Void in
                componentsController.buttonComponent {
                    $0.id = "First Button"
                    $0.backgroundColor = UIColor.red
                }

                if stateOne.showStaticText {
                    componentsController.staticTextComponent {
                        $0.id = "Elusive static text"
                        $0.text = Text.unattributed("This is a test")
                    }
                }

                componentsController.staticSpacingComponent {
                    $0.id = "Spacing"
                    $0.backgroundColor = UIColor.yellow
                }
            }
        }

        class TestViewModel1: ViewModel<TestVC.TestState1> {}

        struct TestState1: State {

            static var `default`: TestState1 {
                return TestState1(changeCount: 0, showStaticText: false)
            }

            var changeCount: Int
            var showStaticText: Bool
        }

        class TestViewModel2: ViewModel<TestVC.TestState2> {}

        struct TestState2: State {

            static var `default`: TestState2 {
                return TestState2(changeCount: 0)
            }

            var changeCount: Int
        }
    }

}
