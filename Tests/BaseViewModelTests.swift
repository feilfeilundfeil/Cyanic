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

    // MARK: - Test Data Structures
    struct TestState: State {

        static var `default`: BaseViewModelTests.TestState {
            return BaseViewModelTests.TestState(
                string: "Hello, World",
                isTrue: false,
                double: 1337.0,
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

    // MARK: - Factory Method
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
                        onFailure: { (error: Error) -> Void in
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
                        onFailure: { (error: Error) -> Void in
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

            context("If the Async property is already .success/failure") {
                it("should not execute the onSuccess/Failure closure after subscribing") {
                    let viewModel: ViewModel = self.createViewModel()
                    let state: TestState = viewModel.currentState

                    // Set the asyncOnSuccess property to success synchronously
                    viewModel.stateStore.stateRelay
                        .accept(state.copy(with: {$0.asyncOnSuccess = .success(true) }))

                    viewModel.asyncSubscribe(
                        to: \TestState.asyncOnSuccess,
                        onSuccess: { (value: Bool) -> Void in
                            fail()
                        },
                        onFailure: { (error: Error) -> Void in
                            fail()
                        }
                    )

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        viewModel.setState(with: {
                            $0.asyncOnSuccess = .success(true)
                            $0.string = "This"
                        })
                    }

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                        viewModel.setState(with: {
                            $0.asyncOnSuccess = .success(true)
                            $0.string = "That"
                        })
                    }

                    expect(viewModel.currentState.string)
                        .toEventually(equal("That"), timeout: 3.0, pollInterval: 3.0, description: "")
                }
            }
        }

        describe("selectSubscribe single keyPath") {
            context("If the subscribed property changes to a different value") {
                it("should execute the onNewValue closure") {
                    let viewModel: ViewModel = self.createViewModel()
                    var newProperty: String = ""
                    let expectedValue: String = "FFUFComponents"

                    viewModel.selectSubscribe(
                        to: \TestState.string,
                        onNewValue: { (newValue: String) -> Void in
                            newProperty = newValue
                        }
                    )

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = expectedValue
                        })
                    }

                    expect(newProperty)
                        .toEventually(equal(expectedValue), timeout: 2.0, pollInterval: 1.0, description: "")
                }
            }

            context("If the subscribed property is mutated to the same value") {
                it("should not execute the onNewValue closure") {
                    let viewModel: ViewModel = self.createViewModel()
                    let initialString: String = viewModel.currentState.string

                    viewModel.selectSubscribe(
                        to: \TestState.string,
                        onNewValue: { (value: String) -> Void in
                            guard value != initialString
                                else { fail("\(value) is equal to \(initialString)"); return }
                        }
                    )

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString
                            state.double = 1339
                        })
                    }

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString
                            state.double = 1340
                        })
                    }

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hello"
                            state.double = 1341
                        })
                    }

                    expect(viewModel.currentState.string)
                        .toEventually(equal("Hello"), timeout: 5.0, pollInterval: 5.0, description: "")
                }
            }
        }

        describe("selectSubscribe multiple keyPaths") {
            context("If either ofthe subscribed properties change value") {
                it("should execute the onNewValue closure for two properties") {
                    let viewModel: ViewModel = self.createViewModel()
                    let currentString: String = viewModel.currentState.string
                    let currentDouble: Double = viewModel.currentState.double
                    var counter: Int = 0
                    viewModel.selectSubscribe(
                        keyPath1: \TestState.double,
                        keyPath2: \TestState.string,
                        onNewValue: { (double: Double, string: String) -> Void in
                            counter += 1
                        }
                    )

                    // Should not increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = currentString // Hello, World
                            state.double = currentDouble // 1337.0
                            state.isTrue = true
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = currentString // Hello, World
                            state.double = 1339.0        // 1339.0
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hello"       // Hello
                            state.double = 1339.0        // 1339.0
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hello" // Hello
                            state.double = 1341.0    // 1341.0
                        })
                    }

                    expect(counter)
                        .toEventually(equal(3), timeout: 3.0, pollInterval: 3.0, description: "")
                }

                it("should execute the onNewValue closure for two properties") {
                    let viewModel: ViewModel = self.createViewModel()
                    let initialString: String = viewModel.currentState.string // Hello, World
                    let initialDouble: Double = viewModel.currentState.double // 1337.0
                    let initialIsTrue: Bool = viewModel.currentState.isTrue   // false
                    var counter: Int = 0
                    viewModel.selectSubscribe(
                        keyPath1: \TestState.double,
                        keyPath2: \TestState.string,
                        keyPath3: \TestState.isTrue,
                        onNewValue: { (double: Double, string: String, isTrue: Bool) -> Void in
                            counter += 1
                        }
                    )

                    // Should not increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = initialDouble // 1337.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = 1339.0        // 1339.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = initialDouble // 1337.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should not increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = initialDouble // 1337.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.25) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hi" // Hi
                            state.double = 1340 // 1340
                            // state.isTrue     // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hi" // Hi
                            // state.double     // 1340
                            state.isTrue = true // true
                        })
                    }

                    expect(counter)
                        .toEventually(equal(4), timeout: 4.0, pollInterval: 4.0, description: "")
                }
            }
        }
    }
}

