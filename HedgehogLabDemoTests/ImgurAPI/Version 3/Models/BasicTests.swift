//
//  BasicTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import XCTest
@testable import ImgurAPI

// MARK: - Imgur Model Definition

final class BasicTests: XCTestCase {
    
    func testThatTheImgurModelsFilesHaventChangedInAWayThatWontParseServerResponse() {
        XCTAssertNoThrow(try Basic<[Image]>.from(fileName: "basic_response"))
    }
}
