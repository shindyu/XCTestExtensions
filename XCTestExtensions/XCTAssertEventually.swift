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
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertEventually(_ expression: @escaping @autoclosure () throws -> Bool, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrueEventually(expression, message: message, timeout: timeout, pollInterval: pollInterval, file: file, line: line)
}

/// Asynchronously, Asserts that an expression is true.
///
/// - Parameters:
///   - expression: An expression of boolean type.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertTrueEventually(_ expression: @escaping @autoclosure () throws -> Bool, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()
    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            if (try! expression()) {
                expectation.fulfill()
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: "expected true, but false until the end - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is false.
///
/// - Parameters:
///   - expression: An expression of boolean type.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertFalseEventually(_ expression: @escaping @autoclosure () throws -> Bool, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            if !(try! expression()) {
                expectation.fulfill()
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
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
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertEqualEventually<T: Equatable>(_ expression1: @escaping @autoclosure () throws -> T, _ expression2: @escaping @autoclosure () throws -> T, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()
    var logs: [(expression1: T, expression2: T)] = []

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            let (value1, value2) = (try! expression1(), try! expression2())
            if value1 == value2 {
                expectation.fulfill()
            } else {
                logs.append((expression1: value1, expression2: value2))
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: """
        failed: (\"\(String(describing: try! expression1()))\") is not eventually equal to (\"\(String(describing: try! expression2()))\") - \(message)
        \(logs.map { "\($0)" }.joined(separator: "\n"))
        """,
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that two values are equal.
///
/// - Parameters:
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: An expression of type T, where T is Equatable.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertEqualEventually<T: Equatable>(_ expression1: @escaping @autoclosure () throws -> T?, _ expression2: @escaping @autoclosure () throws -> T?, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()
    var logs: [(expression1: T?, expression2: T?)] = []

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            let (value1, value2) = (try! expression1(), try! expression2())
            if value1 == value2 {
                expectation.fulfill()
            } else {
                logs.append((expression1: value1, expression2: value2))
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: """
        failed: (\"\(String(describing: try! expression1()))\") is not eventually equal to (\"\(String(describing: try! expression2()))\") - \(message)
        \(logs.map { "\($0)" }.joined(separator: "\n"))
        """,
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that two arrays are equal.
///
/// - Parameters:
///   - expression1: An Array expression that has the same element type as expression2.
///   - expression2: An Array expression that has the same element type as expression1.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertEqualEventually<T: Equatable>(_ expression1: @escaping @autoclosure () throws -> [T]?, _ expression2: @escaping @autoclosure () throws -> [T]?, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()
    var logs: [(expression1: [T]?, expression2: [T]?)] = []

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            let (value1, value2) = (try! expression1(), try! expression2())
            if value1 == nil && value2 == nil {
                expectation.fulfill()
            } else if let value1 = value1,
                let value2 = value2,
                value1 == value2 {
                expectation.fulfill()
            } else {
                logs.append((expression1: value1, expression2: value2))
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: """
        failed: (\"\(String(describing: try! expression1()))\") is not eventually equal to (\"\(String(describing: try! expression2()))\") - \(message)
        \(logs.map { "\($0)" }.joined(separator: "\n"))
        """,
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> T?, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            if (try! expression()) == nil {
                expectation.fulfill()
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: "XCTAssertNilEventually failed (\"\(String(describing: try! expression()))\")  - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> [T]?, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            if (try! expression()) == nil {
                expectation.fulfill()
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: "XCTAssertNilEventually failed (\"\(String(describing: try! expression()))\")  - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is not nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNotNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> T?, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            if (try! expression()) != nil {
                expectation.fulfill()
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: "XCTAssertNotNilEventually failed - \(message)",
        file: file,
        line: line
    )
}

/// Asynchronously, Asserts that an expression is not nil.
///
/// - Parameters:
///   - expression: An expression of type Any? to compare against nil.
///   - timeout: Timeout value
///   - pollInterval: poll interval
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNotNilEventually<T: Equatable>(_ expression: @escaping @autoclosure () throws -> [T]?, message: String = "", timeout: TimeInterval = 1.0, pollInterval: TimeInterval = 0.1, file: StaticString = #file, line: UInt = #line) {
    let expectation = XCTestExpectation()

    for i in 0..<Int(timeout/pollInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval * Double(i)) {
            if (try! expression()) != nil {
                expectation.fulfill()
            }
        }
    }

    switchProcess(
        by: XCTWaiter.wait(for: [expectation], timeout: timeout),
        timedOutMessage: "XCTAssertNotNilEventually failed - \(message)",
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
