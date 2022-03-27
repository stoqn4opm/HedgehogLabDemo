//
//  ThumbnailsLinkCoordinatorTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import XCTest
@testable import ImgurAPI

// MARK: - Class Definition

final class ThumbnailsLinkCoordinatorTests: XCTestCase {
    
    private var coordinator: ThumbnailsLinkCoordinator!
    
    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }
}

// MARK: - Tests

extension ThumbnailsLinkCoordinatorTests {
    
    private func whenCoordinatorIsLoaded(withURL url: String) {
        coordinator = .init(originalLink: URL(string: url)!)
    }
    
    func testThatCoordinatorAssemblesProperlySmallSquare() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_.png")
        let size = ThumbnailsLinkCoordinator.ThumbnailSize.smallSquare
        let url = coordinator.url(withSize: size)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.absoluteString, "https://static.remove.bg/remove-bg-web/image_\(size.rawValue).png")
    }
    
    func testThatCoordinatorAssemblesProperlyBigSquare() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_.png")
        let size = ThumbnailsLinkCoordinator.ThumbnailSize.bigSquare
        let url = coordinator.url(withSize: size)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.absoluteString, "https://static.remove.bg/remove-bg-web/image_\(size.rawValue).png")
    }
    
    func testThatCoordinatorAssemblesProperlySmallThumbnail() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_.png")
        let size = ThumbnailsLinkCoordinator.ThumbnailSize.smallThumbnail
        let url = coordinator.url(withSize: size)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.absoluteString, "https://static.remove.bg/remove-bg-web/image_\(size.rawValue).png")
    }
    
    func testThatCoordinatorAssemblesProperlyMediumThumbnail() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_.png")
        let size = ThumbnailsLinkCoordinator.ThumbnailSize.mediumThumbnail
        let url = coordinator.url(withSize: size)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.absoluteString, "https://static.remove.bg/remove-bg-web/image_\(size.rawValue).png")
    }
    
    func testThatCoordinatorAssemblesProperlyLargeThumbnail() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_.png")
        let size = ThumbnailsLinkCoordinator.ThumbnailSize.largeThumbnail
        let url = coordinator.url(withSize: size)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.absoluteString, "https://static.remove.bg/remove-bg-web/image_\(size.rawValue).png")
    }
    
    func testThatCoordinatorAssemblesProperlyHugeThumbnail() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_.png")
        let size = ThumbnailsLinkCoordinator.ThumbnailSize.hugeThumbnail
        let url = coordinator.url(withSize: size)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.absoluteString, "https://static.remove.bg/remove-bg-web/image_\(size.rawValue).png")
    }
    
    func testThatCoordinatorGivesNoURLWhenThereIsNoPathExtension() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_")
        let url = coordinator.url(withSize: .hugeThumbnail)
        XCTAssertNil(url)
    }
    
    func testThatCoordinatorGivesNoURLWhenThereIsNoPathComponents() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg")
        let url = coordinator.url(withSize: .hugeThumbnail)
        XCTAssertNil(url)
    }
    
    func testThatCoordinatorAssemblesProperlyURLsWhenMoreThanOneDotsArePresentInLastPath() {
        whenCoordinatorIsLoaded(withURL: "https://static.remove.bg/remove-bg-web/image_.sample.jpg.png")
        let size = ThumbnailsLinkCoordinator.ThumbnailSize.hugeThumbnail
        let url = coordinator.url(withSize: size)
        XCTAssertNotNil(url)
        XCTAssertEqual(url!.absoluteString, "https://static.remove.bg/remove-bg-web/image_.sample.jpg\(size.rawValue).png")
    }
}
