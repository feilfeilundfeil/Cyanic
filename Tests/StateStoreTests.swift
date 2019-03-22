//
//  StateStoreTests.swift
//  Tests
//
//  Created by Julio Miguel Alorro on 3/21/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import FFUFComponents

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

                expect(count).to(equal(1)) // Incremented due to the fact that BehaviorRelay replays it's current value on subscribe
                store.setState(with: { $0 = $0})
                expect(count).to(equal(1))
                store.setState(with: { $0.count = 1 })
                expect(count).toEventually(equal(2))
            }
        }
    }

}
