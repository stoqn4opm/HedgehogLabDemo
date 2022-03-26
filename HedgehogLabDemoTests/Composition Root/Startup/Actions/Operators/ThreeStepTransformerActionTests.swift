//
//  ThreeStepTransformerActionTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import XCTest
@testable import HedgehogLabDemo

// MARK: - Tests

final class ThreeStepTransformerActionTests: XCTestCase {
    
    func testThatAllTransformClosuresAreInvokedOnExecute() {
        let action = ThreeStepTransformerAction<Int, String, String, String>(
            input: 3,
            step1: .init { "Step1: \($0)" },
            step2: .init { "Step2: \($0)" },
            step3: .init { "Step3: \($0)" }
        )
        
        action.execute()
        XCTAssertEqual(action.output, "Step3: Step2: Step1: 3")
    }
    
    func testThatTransformationDoesNotStopOnNilOutput() {
        let action = ThreeStepTransformerAction<Int, String, String?, String>(
            input: 3,
            step1: .init { "Step1: \($0)" },
            step2: .init { _ in nil },
            step3: .init { "Step3: \(String(describing: $0))" }
        )
        
        action.execute()
        XCTAssertNotNil(action.output)
    }
    
    func testThatTransformationDoesNotStartWithoutExecute() {
        let action = ThreeStepTransformerAction<Int, String, String?, String>(
            input: 3,
            step1: .init { "Step1: \($0)" },
            step2: .init { _ in nil },
            step3: .init { "Step3: \(String(describing: $0))" }
        )
        
        XCTAssertNil(action.output)
    }
}
