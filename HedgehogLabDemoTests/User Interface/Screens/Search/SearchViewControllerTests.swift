//
//  SearchViewControllerTests.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import XCTest
@testable import ServiceLayer
@testable import HedgehogLabDemoUI

// MARK: - Class Definition

final class SearchViewControllerTests: XCTestCase {
    private var searchViewController: PhotoTabViewController!
    private var viewModel: SearchViewModelMock!
    
    override func tearDown() {
        searchViewController = nil
        viewModel = nil
        super.tearDown()
    }

    private func givenAViewController(withDistanceToEndBeforeFetchingMore distanceToEndBeforeFetchingMore: Int = 5) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: PhotoTabViewController.self))
        let viewModel = SearchViewModelMock()
        self.viewModel = viewModel
        
        searchViewController = storyboard.instantiateViewController(identifier: PhotoTabViewController.className) { coder in
            let result = PhotoTabViewController(coder: coder,
                                              viewModel: viewModel,
                                              scheduler: .immediate,
                                              distanceToEndBeforeFetchingMore: distanceToEndBeforeFetchingMore, searchController: .init())
            return result
        }
    }

    private func whenTheViewLoads() {
        searchViewController.loadViewIfNeeded()
    }
    
    @discardableResult private func whenPhotoListChangesTo(imageCount: Int, nameStartingFrom: Int) -> [Photo] {
        let photos = (0..<max(0, imageCount))
            .map { Photo(id: "photo_\(nameStartingFrom + $0)", title: "", description: "", viewCount: 0, tags: [], url: URL(fileURLWithPath: "")) }
        
        viewModel.appendPhotosSubject.send(photos)
        return photos
    }
}

// MARK: - Tests

extension SearchViewControllerTests {
    
    func testThatCollectionViewIsPreparedWhenViewLoads() {
        givenAViewController()
        whenTheViewLoads()
        
        XCTAssertNotNil(searchViewController.collectionView.delegate, "delegate should have been set in `viewDidLoad`")
        XCTAssertNotNil(searchViewController.collectionView.dataSource, "dataSource should have been set in `viewDidLoad`")
        XCTAssertNotNil(searchViewController.collectionView.refreshControl, "refreshControl should have been set in `viewDidLoad`")
        
    }
    
    func testItAppendsToDataSourceNewlyAddedPhotos() {
        givenAViewController()
        
        whenTheViewLoads()
        whenPhotoListChangesTo(imageCount: 5, nameStartingFrom: 0)
        XCTAssertEqual(searchViewController.dataSource?.snapshot(for: 0).items.count, 5)
        
        whenPhotoListChangesTo(imageCount: 2, nameStartingFrom: 10)
        XCTAssertEqual(searchViewController.dataSource?.snapshot(for: 0).items.count, 2)
    }

    func testThatItShouldNotFetchMoreWhenBoundaryNotReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 5)
        
        whenTheViewLoads()
        let photos = whenPhotoListChangesTo(imageCount: 10, nameStartingFrom: 0)
        
        XCTAssertFalse(searchViewController.shouldFetchMore(reachedPhoto: photos[4]))
    }

    func testThatItShouldFetchMoreWhenBoundaryReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 2)
        
        whenTheViewLoads()
        let photos = whenPhotoListChangesTo(imageCount: 10, nameStartingFrom: 0)
        
        XCTAssertTrue(searchViewController.shouldFetchMore(reachedPhoto: photos[9]))
    }
    
    func testThatItIsNotFetchingMoreWhenBoundaryNotReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 5)
        
        whenTheViewLoads()
        let photos = whenPhotoListChangesTo(imageCount: 10, nameStartingFrom: 0)
        searchViewController.fetchMoreIfNeeded(reachedPhoto: photos[4])
        
        XCTAssertFalse(viewModel.fetchedNext)
    }

    func testThatItFetchesMoreWhenBoundaryReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 2)
        
        whenTheViewLoads()
        let photos = whenPhotoListChangesTo(imageCount: 10, nameStartingFrom: 0)
        searchViewController.fetchMoreIfNeeded(reachedPhoto: photos[9])
        
        XCTAssertTrue(viewModel.fetchedNext)
    }
}
