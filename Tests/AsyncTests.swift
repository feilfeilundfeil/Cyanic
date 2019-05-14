//
//  AsyncTests.swift
//  Tests
//
//  Created by Julio Miguel Alorro on 5/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import Cyanic

class AsyncTests: QuickSpec {

    enum Error: CyanicError {

        case invalidThis(String)
        case invalidThat(String)

        var errorDescription: String {
            switch self {
                case .invalidThat(let value):
                    return "That" + value
                case .invalidThis(let value):
                    return "This" + value
            }
        }

    }

    override func spec() {
        describe("Async failures") {
            it("Should equal when values are equal") {
                let failOne: Async<String> = .failure(AsyncTests.Error.invalidThis("This"))
                let failTwo: Async<String> = .failure(AsyncTests.Error.invalidThis("This"))

                expect(failOne).to(equal(failTwo))
            }

            it("Should not equal when values are different") {
                let failOne: Async<String> = .failure(AsyncTests.Error.invalidThis("This"))
                let failTwo: Async<String> = .failure(AsyncTests.Error.invalidThis("That"))

                expect(failOne).toNot(equal(failTwo))
            }
        }
    }
}
