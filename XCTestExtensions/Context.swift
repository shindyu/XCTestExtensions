//
//  Context.swift
//  XCTestExtensions
//
//  Created by shindyu on 2018/12/12.
//  Copyright © 2018年 shindyu. All rights reserved.
//

import XCTest

public protocol ContextExecutable {
    func context(_ named: String, shouldSetUp: Bool, shouldTearDown: Bool, block: ()->())
}

extension XCTestCase: ContextExecutable {
    /// Execute runActivity with setup, teardown
    ///
    /// - Parameters:
    ///   - named: Name of runActivity.
    ///   - shouldSetUp: Flag for execute setup
    ///   - shouldTearDown: Flag for execute tearDown
    ///   - block: Contents of the test to be executed
    public func context(_ named: String, shouldSetUp: Bool = true, shouldTearDown: Bool = true, block: ()->()) {
        if shouldSetUp {
            self.setUp()
        }
        XCTContext.runActivity(named: named, block: { _ in block() })
        if shouldTearDown {
            self.tearDown()
        }
    }
}
