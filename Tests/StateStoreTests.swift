//
//  StateStoreTests.swift
//  Tests
//
//  Created by Julio Miguel Alorro on 3/21/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import Cyanic

class StateStoreTests: QuickSpec {

    struct TestState: State {

        static var `default`: StateStoreTests.TestState {
            return TestState(count: 0, string: "Hello, World")
        }

        var count: Int
        var string: String
    }

    func createStore() -> StateStore<TestState> {
        return StateStore<TestState>(initialState: TestState.default)
    }

    override func spec() {
        describe("getState method") {
            let store: StateStore<TestState> = self.createStore()
            it("should be asynchronous") {
                var count: Int = 0
                store.getState(with: { _ in count += 1})
                expect(count).to(equal(0))
                expect(count).toEventually(equal(1))
            }
        }

        describe("setState method") {
            let store: StateStore<TestState> = self.createStore()
            it("should be asynchronous and setState should be resolved before getState") {
                var count: Int = 0
                store.getState(with: { count = $0.count })
                store.setState(with: { $0.count = 2})
                expect(count).to(equal(0))
                expect(count).toEventually(equal(2))
            }
        }

        describe("state observable") {
            let store: StateStore<TestState> = self.createStore()
            it("should only change if the new State is different from the old State") {
                var count: Int = 0
                _ = store.state
                    .bind(onNext: { _ in count += 1})

                expect(count).to(equal(1)) // Incremented due to the fact that BehaviorRelay
                                           // replays it's current value on subscribe
                store.setState(with: { $0 = $0})
                expect(count).to(equal(1))
                store.setState(with: { $0.count = 1 })
                expect(count).toEventually(equal(2))
            }
        }

        describe("stress test") {
            let store: StateStore<TestState> = self.createStore()
            it("should be able to handle concurrency") {
                var concurrentQueue1Count: [Int] = []
                var concurrentQueue2Count: [Int] = []

                let concurrentQueue: DispatchQueue = DispatchQueue(
                    label: "Concurrent1",
                    qos: DispatchQoS.default,
                    attributes: .concurrent
                )

                let firstLoopStart: Int = 0
                let firstLoopEnd: Int = 100

                let secondLoopStart: Int = firstLoopEnd + 1
                let secondLoopEnd: Int = firstLoopEnd * 2

                var finalCount: Int = 0

                concurrentQueue.async {
                    for num in secondLoopStart...secondLoopEnd {
                        store.setState(with: {
                            $0.count = num
                            print("Async Num from Second Loop: \(num)")
                            concurrentQueue2Count.append(num)
                        })
                    }
                }

                concurrentQueue.async {
                    for _ in firstLoopStart...firstLoopEnd {
                        store.getState(with: {
                            finalCount = $0.count
                        })
                    }
                }

                concurrentQueue.async {
                    for num in firstLoopStart...firstLoopEnd {
                        store.setState(with: {
                            $0.count = num
                            print("Async Num from First Loop: \(num)")
                            concurrentQueue1Count.append(num)
                        })
                    }
                }

                expect(concurrentQueue1Count).toEventually(contain(firstLoopEnd), description: "Stress count for async loop")
                expect(concurrentQueue2Count).toEventually(contain(secondLoopEnd), description: "Stress count for async loop")
                expect(finalCount).toEventually(satisfyAnyOf(equal(firstLoopEnd), equal(secondLoopEnd)), description: "\(finalCount) should equal \(firstLoopEnd) or \(secondLoopEnd)")

            }
        }
    }
}
