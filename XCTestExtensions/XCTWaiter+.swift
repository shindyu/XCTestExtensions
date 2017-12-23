//
//  XCTWaiter+.swift
//  XCTestExtensions
//
//  Created by shindyu on 2017/12/22.
//  Copyright © 2017年 shindyu. All rights reserved.
//
import Foundation
import XCTest

extension XCTWaiter.Result {
    func desc() -> String {
        switch self {
        case .completed:
            return "completed"
        case .timedOut:
            return "timedOut"
        case .incorrectOrder:
            return "incorrectOrder"
        case .invertedFulfillment:
            return "invertedFulfillment"
        case .interrupted:
            return "interrupted"
        }
    }
}
