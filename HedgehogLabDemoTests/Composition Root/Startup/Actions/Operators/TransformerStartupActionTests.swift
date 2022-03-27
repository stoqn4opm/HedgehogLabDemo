//
//  TransformerStartupActionTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import XCTest
@testable import HedgehogLabDemo

// MARK: - Tests

final class TransformerStartupActionTests: XCTestCase {
    
    func testThatTransformClosureIsInvokedOnExecute() {
        let action = TransformerStartupAction(input: 3) { "\($0)" }
        action.execute()
        XCTAssertEqual(action.output, "3")
    }
    
    func testThatTransformClosureIsNotInvokedWithoutExecute() {
        let action = TransformerStartupAction(input: 3) { "\($0)" }
        XCTAssertNil(action.output)
    }
    
    func testThatOutputIsNilAfterExecuteWhenThereIsNoInput() {
        let action = TransformerStartupAction<Int, String>() { "\($0)" }
        XCTAssertNil(action.output)
    }
    
    func testThatTransformClosureIsNotInvokedOnExecuteWhenThereIsNoInput() {
        var invoked = false
        let action = TransformerStartupAction<Int, String>() { invoked = true; return "\($0)" }
        action.execute()
        XCTAssertFalse(invoked)
    }
}
