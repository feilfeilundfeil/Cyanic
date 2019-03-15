//
//  MvRx_iOSTests.swift
//  FFUFComponentsTests
//
//  Created by Julio Miguel Alorro on 2/6/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import FFUFComponents

class BaseViewModelTests: QuickSpec {

    struct TestState: State {

        static var `default`: BaseViewModelTests.TestState {
            return BaseViewModelTests.TestState(
                string: "Hello, World",
                isTrue: true, double: 1337.0,
                asyncOnSuccess: Async<Bool>.uninitialized,
                asyncOnFailure: Async<Bool>.uninitialized
            )
        }

        var string: String
        var isTrue: Bool
        var double: Double
        var asyncOnSuccess: Async<Bool>
        var asyncOnFailure: Async<Bool>
    }

    class ViewModel: BaseViewModel<TestState> {}

    enum AsyncError: Error {
        case failed

        var localizedDescription: String {
            return "Async Property failed"
        }
    }

    private func createViewModel() -> ViewModel {
        return ViewModel(initialState: TestState.default)
    }

    override func spec() {
        describe("asyncSubscribe method") {

            context("If the Async property is mutated to .success") {
                it("should execute the onSuccess closure") {

                    let viewModel: ViewModel = self.createViewModel()
                    var wasSuccess: Bool = false

                    viewModel.asyncSubscribe(
                        to: \TestState.asyncOnSuccess,
                        onSuccess: { (value: Bool) -> Void in
                            wasSuccess = value
                        },
                        onFail: { (error: Error) -> Void in
                            fail()
                        }
                    )

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.asyncOnSuccess = .success(true)
                        })
                    })

                    expect(wasSuccess).toEventually(equal(true), timeout: 2.0, pollInterval: 1.0, description: "")
                }
            }

            context("If the Async property is mutated to .failure") {
                it("should execute the onFailure closure") {
                    let viewModel: ViewModel = self.createViewModel()
                    var wasFailure: Bool = false

                    viewModel.asyncSubscribe(
                        to: \TestState.asyncOnFailure,
                        onSuccess: { (value: Bool) -> Void in
                            fail()
                        },
                        onFail: { (error: Error) -> Void in
                            wasFailure = true
                        }
                    )

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.asyncOnFailure = .failure(AsyncError.failed)
                        })
                    })

                    expect(wasFailure)
                        .toEventually(equal(true), timeout: 2.0, pollInterval: 1.0, description: "")
                    expect(viewModel.currentState.asyncOnFailure)
                        .toEventually(equal(Async.failure(AsyncError.failed)), timeout: 2.0, pollInterval: 1.0, description: "")
                }
            }
        }
    }

}




