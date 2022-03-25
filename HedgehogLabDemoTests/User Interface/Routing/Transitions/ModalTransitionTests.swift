//
//  ModalTransitionTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import XCTest
@testable import HedgehogLabDemoUI

class ModalTransitionTests: XCTestCase {

    func testThatModalTransitionPresentsControllersWithCoverVerticalTransitionStyleAndCurrentContextPresentationStyle() throws {
        // given
        let sut = ModalTransition(isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .currentContext)
        let openedController = UIViewController(nibName: nil, bundle: nil)
        let fromController = UIViewController(nibName: nil, bundle: nil)
        
        // when
        sut.open(openedController, from: fromController, completion: nil)
        
        // then
        XCTAssertEqual(openedController.modalPresentationStyle, .currentContext)
        XCTAssertEqual(openedController.modalTransitionStyle, .coverVertical)
    }
    
    func testThatModalTransitionPresentsControllersWithCrossDissolveTransitionStyleAndFormSheetPresentationStyle() throws {
        // given
        let sut = ModalTransition(isAnimated: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .formSheet)
        let openedController = UIViewController(nibName: nil, bundle: nil)
        let fromController = UIViewController(nibName: nil, bundle: nil)
        
        // when
        sut.open(openedController, from: fromController, completion: nil)
        
        // then
        XCTAssertEqual(openedController.modalPresentationStyle, .formSheet)
        XCTAssertEqual(openedController.modalTransitionStyle, .crossDissolve)
    }
}
