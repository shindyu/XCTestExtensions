//
//  XCTAssertEventually.swift
//  XCTestExtensions
//
//  Created by shindyu on 2017/12/22.
//  Copyright © 2017年 shindyu. All rights reserved.
//
import Foundation
import XCTest

/// Asynchronously, Asserts that an expression is true.
///
/// - Parameters:
///   - expression: An expression of boolean type.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertEventually(_ expression: @escaping @autoclosure () throws -> Bool, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrueEventually(try expression(), message: message, pollTimeout: pollTimeout, pollCount: pollCount, pollInterval: pollInterval, file: file, line: line)
}

/// Asynchronously, Asserts that an expression is true.
///
/// - Parameters:
///   - expression: An expression of boolean type.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertTrueEventually(_ expression: @escaping @autoclosure () throws -> Bool, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            if (try! expression()) == true {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: "expected true, but false until the end - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is false.
///
/// - Parameters:
///   - expression: An expression of boolean type.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertFalseEventually(_ expression: @escaping @autoclosure () throws -> Bool, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            if (try! expression()) == false {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: "expected false, but true until the end - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that two values are equal.
///
/// - Parameters:
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: An expression of type T, where T is Equatable.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertEqualEventually<T: Equatable>(_ expression1: @escaping @autoclosure () throws -> T?, _ expression2: @escaping @autoclosure () throws -> T?, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var value1: T?
    var value2: T?
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            value1 = try! expression1()
            value2 = try! expression2()
            if value1 == value2 {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: " failed: (\"\(value1)\") is not eventually equal to (\"\(value2)\") - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that two arrays are equal.
///
/// - Parameters:
///   - expression1: An Array expression that has the same element type as expression2.
///   - expression2: An Array expression that has the same element type as expression1.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertEqualEventually<T: Equatable>(_ expression1: @escaping @autoclosure () throws -> [T]?, _ expression2: @escaping @autoclosure () throws -> [T]?, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var value1: [T]?
    var value2: [T]?
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            value1 = try! expression1()
            value2 = try! expression2()
            if value1 == value2 {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: " failed: (\"\(value1)\") is not eventually equal to (\"\(value2)\") - \(message)",
        file: file,
        line: line
    )

}

/// Asynchronously, Asserts that an expression is nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> T?, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var value: T?
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            value = try! expression()
            if value == nil {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: "XCTAssertNilEventually failed (\"\(value)\")  - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> [T]?, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var value: [T]?
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            value = try! expression()
            if value == nil {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: "XCTAssertNilEventually failed (\"\(value)\")  - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is not nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNotNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> T?, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var value: T?
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            value = try! expression()
            if value != nil {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: "XCTAssertNotNilEventually failed (\"\(value)\")  - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is not nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - message: An optional description of the failure.
///   - pollTimeout: Timeout of Polling.
///   - pollCount: Number of Polling.
///   - pollInterval: Polling interval.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNotNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> [T]?, message: String = "", pollTimeout: TimeInterval = 10.0, pollCount: Int = 10, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    var value: [T]?
    var result: XCTWaiter.Result = .timedOut

    for _ in 0..<pollCount {
        let expectation = XCTestExpectation()
        DispatchQueue.main.async() {
            value = try! expression()
            if value != nil {
                result = .completed
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + pollInterval) {
                    expectation.fulfill()
                }
            }
        }
        let pollResult = XCTWaiter.wait(for: [expectation], timeout: pollTimeout)
        switch pollResult {
        case .completed:
            if result == .completed {
                break
            }
        default:
            result = pollResult
            break
        }
    }

    switchProcess(
        by: result,
        timedOutMessage: "XCTAssertNilEventually failed (\"\(value)\")  - \(message)",
        file: file,
        line: line
    )
}

private func switchProcess(by result: XCTWaiter.Result, timedOutMessage: String, file: StaticString = #file, line: UInt = #line) {
    switch result {
    case .completed:
        break
    case .timedOut:
        XCTFail(timedOutMessage, file: file, line: line)
    default:
        XCTFail(result.desc(), file: file, line: line)
    }
}
