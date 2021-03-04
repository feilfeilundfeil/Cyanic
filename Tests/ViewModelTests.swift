//
//  ViewModelTests.swift
//  Tests
//
//  Created by Julio Miguel Alorro on 2/6/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import Cyanic

class ViewModelTests: QuickSpec {

    // MARK: - Test Data Structures
    struct TestState: State {

        static var `default`: ViewModelTests.TestState {
            return ViewModelTests.TestState(
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

    class TestViewModel: ViewModel<TestState> {}

    enum AsyncError: CyanicError {
        case failed

        var errorDescription: String {
            return "Async Property failed"
        }
    }

    // MARK: - Factory Method
    private func createViewModel() -> TestViewModel {
        return TestViewModel(initialState: TestState.default)
    }

    override func spec() {
        describe("withState and setState methods") {
            it("setState closure should be executed before withState closures even if withState is called first.") {
                let viewModel: TestViewModel = self.createViewModel()

                var currentState: TestState = viewModel.currentState
                var isCurrentState: Bool = false
                var value: Double = -1000.0

                let finalValue: Double = 5.0

                viewModel.withState(block: { (state: TestState) -> Void in
                    currentState = state
                })
                var isEqual: Bool = false

                viewModel.setState(with: {
                    $0.double = 0.0
                    value = 0.0
                })

                viewModel.withState(block: { (state: TestState) -> Void in
                    print("Double: \(state.double), FinalValue: \(finalValue)")
                    isEqual = state.double == finalValue
                })

                viewModel.withState(block: { (state: TestState) -> Void in
                    print("CurrentState: \(currentState)")
                    print("State: \(state)")
                    isCurrentState = currentState == state
                })

                viewModel.setState(with: {
                    $0.double = 1.0
                    value = 1.0
                })

                viewModel.setState(with: {
                    $0.double = finalValue
                    value = finalValue
                })

                expect(isCurrentState).toEventually(equal(true), description: "isCurrentState is \(isCurrentState)")
                expect(isEqual).toEventually(equal(true), description: "Value is \(value).")
            }
        }

        describe("asyncSubscribe method") {
            context("If the Async property is mutated to .success") {
                it("should execute the onSuccess closure") {

                    let viewModel: TestViewModel = self.createViewModel()
                    var wasSuccess: Bool = false

                    viewModel.asyncSubscribe(
                        to: \TestState.asyncOnSuccess,
                        postInitialValue: false,
                        onSuccess: { (value: Bool) -> Void in
                            wasSuccess = value
                        },
                        onFailure: { (error: Error) -> Void in
                            fail()
                        }
                    )

                    viewModel.setState(with: { (state: inout TestState) -> Void in
                        state.asyncOnSuccess = .success(true)
                    })

                    expect(wasSuccess).toEventually(equal(true))
                }
            }

            context("If the Async property is mutated to .failure") {
                it("should execute the onFailure closure") {
                    let viewModel: TestViewModel = self.createViewModel()
                    var wasFailure: Bool = false

                    viewModel.asyncSubscribe(
                        to: \TestState.asyncOnFailure,
                        postInitialValue: false,
                        onSuccess: { (value: Bool) -> Void in
                            fail()
                        },
                        onFailure: { (error: Error) -> Void in
                            wasFailure = true
                        }
                    )

                    viewModel.setState(with: { (state: inout TestState) -> Void in
                        state.asyncOnFailure = .failure(AsyncError.failed)
                    })

                    expect(wasFailure).toEventually(equal(true))
                    expect(viewModel.currentState.asyncOnFailure).toEventually(equal(Async.failure(AsyncError.failed)))
                }
            }

            context("If the Async property is already .success/failure") {
                it("should not execute the onSuccess/Failure closure after subscribing") {
                    let viewModel: TestViewModel = self.createViewModel()
                    let state: TestState = viewModel.currentState

                    // Set the asyncOnSuccess property to success synchronously
                    viewModel.stateStore.stateRelay
                        .accept(state.copy(with: {$0.asyncOnSuccess = .success(true) }))

                    viewModel.asyncSubscribe(
                        to: \TestState.asyncOnSuccess,
                        postInitialValue: false,
                        onSuccess: { (value: Bool) -> Void in
                            fail()
                        },
                        onFailure: { (error: Error) -> Void in
                            fail()
                        }
                    )

                    viewModel.setState(with: {
                        $0.asyncOnSuccess = .success(true)
                        $0.string = "This"
                    })

                    viewModel.setState(with: {
                        $0.asyncOnSuccess = .success(true)
                        $0.string = "That"
                    })

                    expect(viewModel.currentState.string).toEventually(equal("That"))
                }
            }
        }

        describe("selectSubscribe single keyPath") {
            context("If the subscribed property changes to a different value") {
                it("should execute the onNewValue closure") {
                    let viewModel: TestViewModel = self.createViewModel()
                    var newProperty: String = ""
                    let expectedValue: String = "Cyanic"

                    viewModel.selectSubscribe(
                        to: \TestState.string,
                        postInitialValue: false,
                        onNewValue: { (newValue: String) -> Void in
                            newProperty = newValue
                        }
                    )

                    viewModel.setState(with: { (state: inout TestState) -> Void in
                        state.string = expectedValue
                    })

                    expect(newProperty).toEventually(equal(expectedValue))
                }
            }

            context("If the subscribed property is mutated to the same value") {
                it("should not execute the onNewValue closure") {
                    let viewModel: TestViewModel = self.createViewModel()
                    let initialString: String = viewModel.currentState.string

                    viewModel.selectSubscribe(
                        to: \TestState.string,
                        postInitialValue: false,
                        onNewValue: { (value: String) -> Void in
                            guard value != initialString
                                else { fail("\(value) is equal to \(initialString)"); return }
                        }
                    )

                    viewModel.setState(with: { (state: inout TestState) -> Void in
                        state.string = initialString
                        state.double = 1339
                    })

                    viewModel.setState(with: { (state: inout TestState) -> Void in
                        state.string = initialString
                        state.double = 1340
                    })

                    viewModel.setState(with: { (state: inout TestState) -> Void in
                        state.string = "Hello"
                        state.double = 1341
                    })

                    expect(viewModel.currentState.string).toEventually(equal("Hello"))
                }
            }
        }

        describe("selectSubscribe multiple keyPaths") {
            context("If either ofthe subscribed properties change value") {
                it("should execute the onNewValue closure for two properties") {
                    let viewModel: TestViewModel = self.createViewModel()
                    let currentString: String = viewModel.currentState.string
                    let currentDouble: Double = viewModel.currentState.double
                    var counter: Int = 0
                    viewModel.selectSubscribe(
                        keyPath1: \TestState.double,
                        keyPath2: \TestState.string,
                        postInitialValue: false,
                        onNewValue: { (double: Double, string: String) -> Void in
                            counter += 1
                        }
                    )

                    // Should not increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = currentString // Hello, World
                            state.double = currentDouble // 1337.0
                            state.isTrue = true
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = currentString // Hello, World
                            state.double = 1339.0        // 1339.0
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hello"       // Hello
                            state.double = 1339.0        // 1339.0
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hello" // Hello
                            state.double = 1341.0    // 1341.0
                        })
                    }

                    expect(counter).toEventually(equal(3), timeout: .milliseconds(500), pollInterval: .milliseconds(500), description: "")
                }

                it("should execute the onNewValue closure for two properties") {
                    let viewModel: TestViewModel = self.createViewModel()
                    let initialString: String = viewModel.currentState.string // Hello, World
                    let initialDouble: Double = viewModel.currentState.double // 1337.0
                    let initialIsTrue: Bool = viewModel.currentState.isTrue   // false
                    var counter: Int = 0

                    viewModel.selectSubscribe(
                        keyPath1: \TestState.double,
                        keyPath2: \TestState.string,
                        keyPath3: \TestState.isTrue,
                        postInitialValue: false,
                        onNewValue: { (double: Double, string: String, isTrue: Bool) -> Void in
                            counter += 1
                        }
                    )

                    // Should not increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = initialDouble // 1337.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = 1339.0        // 1339.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = initialDouble // 1337.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should not increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = initialString // Hello, World
                            state.double = initialDouble // 1337.0
                            state.isTrue = initialIsTrue // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hi" // Hi
                            state.double = 1340 // 1340
                            // state.isTrue     // false
                        })
                    }

                    // Should increment
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                        viewModel.setState(with: { (state: inout TestState) -> Void in
                            state.string = "Hi" // Hi
                            // state.double     // 1340
                            state.isTrue = true // true
                        })
                    }

                    expect(counter)
                        .toEventually(equal(4), timeout: .milliseconds(500), pollInterval: .milliseconds(500), description: "")
                }
            }
        }
    }
}
