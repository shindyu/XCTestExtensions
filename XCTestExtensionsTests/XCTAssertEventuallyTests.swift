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
        var value = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            value = true
        }

        XCTAssertEventually(value)
    }

    func test_XCTAssertEventually_valueNotChange() {
        XCTAssertEventually(true)
    }

    func test_XCTAssertTrueEventually() {
        var value = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            value = true
        }

        XCTAssertTrueEventually(value)
    }

    func test_XCTAssertTrueEventually_valueNotChange() {
        XCTAssertTrueEventually(true)
    }

    func test_XCTAssertFalseEventually() {
        var value = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            value = false
        }

        XCTAssertFalseEventually(value)
    }

    func test_XCTAssertFalseEventually_valueNotChange() {
        XCTAssertFalseEventually(false)
    }

    func test_XCTAssertEqualEventually() {
        let value1 = true
        var value2 = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            value2 = true
        }

        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertEqualEventually_valueNotChange() {
        let value1 = true
        let value2 = true

        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertEqualEventually_floatingPoint() {
        let value1 = 1.0000000000000000001
        var value2 = 2.0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            value2 = 1.0000000000000000002
        }

        // Usually, you rarely care about floating point errors.
        // So I dont implement more accurate assertion.
        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertEqualEventually_optional_1() {
        let value1: String? = "fujiyama"
        let value2: String? = "fujiyama"

        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertEqualEventually_optional_2() {
        let value1: String? = nil
        let value2: String? = nil

        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertEqualEventually_array() {
        let value1 = [1, 2]
        var value2 = [3, 4]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            value2 = [1, 2]
        }

        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertEqualEventually_array_valueNotChange() {
        let value1 = [1, 2]
        let value2 = [1, 2]

        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertEqualEventually_optionalArray() {
        let value1: [Int]? = [1, 2]
        let value2: [Int]? = [1, 2]

        XCTAssertEqualEventually(value1, value2)
    }

    func test_XCTAssertNilEventually_equatable() {
        var optional: Bool? = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            optional = nil
        }

        XCTAssertNilEventually(optional)
    }

    func test_XCTAssertNilEventually_equatable_valueNotChange() {
        let optional: Bool? = nil

        XCTAssertNilEventually(optional)
    }

    func test_XCTAssertNilEventually_array() {
        var optional: [Int]? = [1, 2, 3]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            optional = nil
        }

        XCTAssertNilEventually(optional)
    }

    func test_XCTAssertNotNilEventually_equatble() {
        var optional: Bool? = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            optional = true
        }

        XCTAssertNotNilEventually(optional)
    }

    func test_XCTAssertNotNilEventually_equatble_valueNotChange() {
        let optional: Bool? = true

        XCTAssertNotNilEventually(optional)
    }

    func test_XCTAssertNotNilEventually_array() {
        var optional: [Int]? = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            optional = [1, 2, 3]
        }

        XCTAssertNotNilEventually(optional)
    }

    func test_XCTAssertNotNilEventually_array_valueNotChange() {
        let optional: [Int]? = [1, 2, 3]

        XCTAssertNotNilEventually(optional)
    }
}
