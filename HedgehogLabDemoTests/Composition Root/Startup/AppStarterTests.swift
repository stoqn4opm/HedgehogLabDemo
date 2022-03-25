//
//  AppStarterTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import XCTest
@testable import HedgehogLabDemo

// MARK: - Class Definition

final class AppStarterTests: XCTestCase {

    private var executor: StartupActionExecutor!
    private var spyAction: SpyStartupAction!
    private var spyActions: [SpyStartupAction]!
    
    override func tearDown() {
        executor = nil
        spyAction = nil
        spyActions = nil
        super.tearDown()
    }
    
    func givenAStartupActionExecutor() {
        executor = AppStarter()
    }
    
    func whenSpyActionIsAppended() {
        spyAction = SpyStartupAction()
        executor.append(spyAction)
    }
    
    func whenSpyActionsAreAppended(count: Int) {
        spyActions = (0..<count).map { _ in SpyStartupAction() }
        executor.append(spyActions)
    }
}

// MARK: - Tests

extension AppStarterTests {
    
    func testThatActionsArrayIsInitiallyEmpty() {
        givenAStartupActionExecutor()
        XCTAssertTrue(executor.actions.isEmpty)
    }
    
    func testThatActionIsAppendedToActionsArray() {
        givenAStartupActionExecutor()
        executor.append(SpyStartupAction())
        XCTAssertEqual(executor.actions.count, 1)
    }
    
    func testThatActionsAreAppendedToActionsArray() {
        givenAStartupActionExecutor()
        executor.append([SpyStartupAction(), SpyStartupAction()])
        XCTAssertEqual(executor.actions.count, 2)
    }
    
    func testThatActionIsRemovedAfterExecution() {
        givenAStartupActionExecutor()
        executor.append(SpyStartupAction())
        executor.execute()
        XCTAssertTrue(executor.actions.isEmpty)
    }
    
    func testThatActionsAreRemovedAfterExecution() {
        givenAStartupActionExecutor()
        executor.append([SpyStartupAction(), SpyStartupAction()])
        executor.execute()
        XCTAssertTrue(executor.actions.isEmpty)
    }
    
    func testThatMultipleActionsCanBeAppendedSeparately() {
        givenAStartupActionExecutor()
        executor.append(SpyStartupAction())
        executor.append(SpyStartupAction())
        XCTAssertEqual(executor.actions.count, 2)
    }
    
    func testThatMultipleActionsCanBeAppendedTogether() {
        givenAStartupActionExecutor()
        executor.append([SpyStartupAction(), SpyStartupAction()])
        executor.append(SpyStartupAction())
        XCTAssertEqual(executor.actions.count, 3)
    }
    
    func testThatActionIsNotExecutedWhenAppended() {
        givenAStartupActionExecutor()
        whenSpyActionIsAppended()
        XCTAssertFalse(spyAction.hasExecuted)
    }
    
    func testThatActionIsExecutedAfterExecuteInvocation() {
        givenAStartupActionExecutor()
        whenSpyActionIsAppended()
        executor.execute()
        XCTAssertTrue(spyAction.hasExecuted)
    }
    
    func testThatAllActionsAreExecutedAfterExecuteInvocation() {
        givenAStartupActionExecutor()
        whenSpyActionsAreAppended(count: 5)
        executor.execute()
        XCTAssertTrue(spyActions.allSatisfy { $0.hasExecuted })
    }
    
    func testThatNoActionsAreExecutedBeforeExecuteInvocation() {
        givenAStartupActionExecutor()
        whenSpyActionsAreAppended(count: 5)
        XCTAssertTrue(spyActions.allSatisfy { $0.hasExecuted == false })
    }
}
