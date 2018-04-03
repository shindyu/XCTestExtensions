//
//  XCTAssertEventuallyTests.swift
//  XCTestExtensionsTests
//
//  Created by shindyu on 2017/12/22.
//  Copyright © 2017年 shindyu. All rights reserved.
//
import XCTest
@testable import XCTestExtensions

class XCTAssertEventuallyTests: XCTestCase {
    func test_XCTAssertEventually() {
        XCTContext.runActivity(named: "default") {_ in
            XCTAssertEventually(true)
        }

        XCTContext.runActivity(named: "async") {_ in
            var value = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                value = true
            }

            XCTAssertEventually(value)
        }
    }

    func test_XCTAssertTrueEventually() {
        XCTContext.runActivity(named: "default") {_ in
            XCTAssertTrueEventually(true)
        }

        XCTContext.runActivity(named: "async") {_ in
            var value = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                value = true
            }

            XCTAssertTrueEventually(value)
        }
    }

    func test_XCTAssertFalseEventually() {
        XCTContext.runActivity(named: "default") {_ in
            XCTAssertFalseEventually(false)
        }

        XCTContext.runActivity(named: "async") {_ in
            var value = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                value = false
            }

            XCTAssertFalseEventually(value)
        }
    }

    func test_XCTAssertEqualEventually() {
        XCTContext.runActivity(named: "default") {_ in
            let value1 = true
            let value2 = true

            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "async") {_ in
            let value1 = true
            var value2 = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                value2 = true
            }

            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "floating point") {_ in
            let value1 = 1.0000000000000000001
            var value2 = 2.0

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                value2 = 1.0000000000000000002
            }

            // Usually, you rarely care about floating point errors.
            // So I dont implement more accurate assertion.
            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "optional") {_ in
            let value1: String? = "fujiyama"
            let value2: String? = "fujiyama"

            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "neither") {_ in
            let value1: String? = nil
            let value2: String? = nil

            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "array default") {_ in
            let value1 = [1, 2]
            let value2 = [1, 2]

            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "array async") {_ in
            let value1 = [1, 2]
            var value2 = [3, 4]

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                value2 = [1, 2]
            }

            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "optionalArray default") {_ in
            let value1: [Int]? = [1, 2]
            let value2: [Int]? = [1, 2]

            XCTAssertEqualEventually(value1, value2)
        }

        XCTContext.runActivity(named: "optionalArray async") {_ in
            let value1: [Int]? = [1, 2]
            var value2: [Int]? = nil

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                value2 = [1, 2]
            }

            XCTAssertEqualEventually(value1, value2)
        }
    }

    func test_XCTAssertNilEventually() {
        XCTContext.runActivity(named: "default") {_ in
            let optional: Bool? = nil

            XCTAssertNilEventually(optional)
        }

        XCTContext.runActivity(named: "async") {_ in
            var optional: Bool? = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                optional = nil
            }

            XCTAssertNilEventually(optional)
        }

        XCTContext.runActivity(named: "array") {_ in
            var optional: [Int]? = [1, 2, 3]

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                optional = nil
            }

            XCTAssertNilEventually(optional)
        }
    }

    func test_XCTAssertNotNilEventually() {
        XCTContext.runActivity(named: "default") {_ in
            let optional: Bool? = true

            XCTAssertNotNilEventually(optional)
        }

        XCTContext.runActivity(named: "async") {_ in
            var optional: Bool? = nil

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                optional = true
            }

            XCTAssertNotNilEventually(optional)
        }

        XCTContext.runActivity(named: "array default") {_ in
            let optional: [Int]? = [1, 2, 3]

            XCTAssertNotNilEventually(optional)
        }

        XCTContext.runActivity(named: "array async") {_ in
            var optional: [Int]? = nil

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                optional = [1, 2, 3]
            }

            XCTAssertNotNilEventually(optional)
        }
    }
}
