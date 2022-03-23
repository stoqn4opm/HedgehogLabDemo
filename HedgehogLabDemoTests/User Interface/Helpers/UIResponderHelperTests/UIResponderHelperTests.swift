//
//  UIResponderHelperTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import XCTest
@testable import HedgehogLabDemo

class UIResponderHelperTests: XCTestCase {
    
    func testThatClassNameIsCorrect() {
        XCTAssertEqual(TestViewController.className, "TestViewController")
    }
}
