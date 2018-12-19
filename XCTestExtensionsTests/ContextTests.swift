//
//  ContextTests.swift
//  XCTestExtensionsTests
//
//  Created by shindyu on 2018/12/12.
//  Copyright © 2018年 shindyu. All rights reserved.
//

import XCTest
@testable import XCTestExtensions

class ContextTests: XCTestCase {
    var contextTests_calledCount: Int!

    override func setUp() {
        super.setUp()
        contextTests_calledCount = 0
    }

    override func tearDown() {
        contextTests_calledCount -= 1
        super.tearDown()
    }

    private func countUp() {
        contextTests_calledCount += 1
    }

    func test_context_Execute_SetupAndTearDown() {
        XCTAssertEqual(contextTests_calledCount, 0)

        countUp()

        XCTAssertEqual(contextTests_calledCount, 1)

        context("test-1") {
            XCTAssertEqual(contextTests_calledCount, 0)

            countUp()
            countUp()

            XCTAssertEqual(contextTests_calledCount, 2)
        }

        XCTAssertEqual(contextTests_calledCount, 1)

        context("test-1") {
            XCTAssertEqual(contextTests_calledCount, 0)
            countUp()
            countUp()

            XCTAssertEqual(contextTests_calledCount, 2)
        }

        XCTAssertEqual(contextTests_calledCount, 1)
    }

    func test_context_shouldSetUp() {
        XCTAssertEqual(contextTests_calledCount, 0)

        countUp()

        XCTAssertEqual(contextTests_calledCount, 1)

        context("test-1", shouldSetUp: false) {
            XCTAssertEqual(contextTests_calledCount, 1)

            countUp()
            countUp()

            XCTAssertEqual(contextTests_calledCount, 3)
        }

        XCTAssertEqual(contextTests_calledCount, 2)
    }
    
    func test_context_shouldTearDown() {
        XCTAssertEqual(contextTests_calledCount, 0)

        countUp()

        XCTAssertEqual(contextTests_calledCount, 1)

        context("test-1", shouldTearDown: false) {
            XCTAssertEqual(contextTests_calledCount, 0)

            countUp()
            countUp()

            XCTAssertEqual(contextTests_calledCount, 2)
        }

        XCTAssertEqual(contextTests_calledCount, 2)
    }
}
