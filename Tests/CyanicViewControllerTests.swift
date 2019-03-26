//
//  CyanicViewController.swift
//  Tests
//
//  Created by Julio Miguel Alorro on 3/24/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import Cyanic

class CyanicViewControllerTests: QuickSpec {

    override func spec() {
        describe("BaseStateListeningVC functionality") {
            context("When BaseStateListeningVC is initialized and view is loaded") {
                let vc: TestVC = TestVC()
                vc.viewDidLoad()
                it("should call invalidate to get the intial state") {
                    expect(vc.count).toEventually(equal(1))
                }

                it("should call invalidate when any viewModel's state changes") {
                    vc.viewModelOne.setState(with: { $0.changeCount += 1 })
                    expect(vc.count).toEventually(equal(2))
                    expect(vc.viewModelOne.currentState.changeCount).toEventually(equal(1))

                    vc.viewModelTwo.setState(with: { $0.changeCount += 1})
                    expect(vc.count).toEventually(equal(3))
                    expect(vc.viewModelTwo.currentState.changeCount).toEventually(equal(1))
                }
            }
        }
    }

    class TestVC: CyanicViewController {

        var count: Int = 0
        let viewModelOne: TestViewModel1 = TestViewModel1(initialState: TestVC.TestState1.default)
        let viewModelTwo: TestViewModel2 = TestViewModel2(initialState: TestVC.TestState2.default)

        override var viewModels: [AnyViewModel] {
            return [
                self.viewModelOne.asAnyViewModel,
                self.viewModelTwo.asAnyViewModel
            ]
        }

        override func invalidate() {
            self.count += 1
        }

        class TestViewModel1: ViewModel<TestVC.TestState1> {}

        struct TestState1: State {

            static var `default`: TestState1 {
                return TestState1(changeCount: 0)
            }

            var changeCount: Int
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
