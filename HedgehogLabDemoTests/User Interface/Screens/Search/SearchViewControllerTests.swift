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
    private var searchViewController: SearchViewController!
    private var viewModel: SearchViewModelMock!
    
    override func tearDown() {
        searchViewController = nil
        viewModel = nil
        super.tearDown()
    }

    private func givenAViewController(withDistanceToEndBeforeFetchingMore distanceToEndBeforeFetchingMore: Int = 5) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SearchViewController.self))
        let viewModel = SearchViewModelMock()
        self.viewModel = viewModel
        
        searchViewController = storyboard.instantiateViewController(identifier: SearchViewController.className) { coder in
            let result = SearchViewController(coder: coder,
                                              viewModel: viewModel,
                                              scheduler: .immediate,
                                              distanceToEndBeforeFetchingMore: distanceToEndBeforeFetchingMore)
            return result
        }
    }

    private func whenTheViewLoads() {
        searchViewController.loadViewIfNeeded()
    }
    
    @discardableResult private func whenPhotosAreAppended(imageCount: Int, nameStartingFrom: Int) -> [Photo] {
        let photos = (0..<max(0, imageCount))
            .map { Photo(identifier: "photo_\(nameStartingFrom + $0)") }
        
        viewModel.appendPhotosSubject.send(photos)
        return photos
    }
    
    private func whenPhotosAreReset() {
        viewModel.resetPhotosSubject.send(())
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
        whenPhotosAreAppended(imageCount: 5, nameStartingFrom: 0)
        XCTAssertEqual(searchViewController.dataSource?.snapshot(for: 0).items.count, 5)
        
        whenPhotosAreAppended(imageCount: 2, nameStartingFrom: 10)
        XCTAssertEqual(searchViewController.dataSource?.snapshot(for: 0).items.count, 7)
    }
    
    func testItRemovesAllPhotosFromDataSourceWhenReset() {
        givenAViewController()
        
        whenTheViewLoads()
        whenPhotosAreAppended(imageCount: 5, nameStartingFrom: 0)
        whenPhotosAreReset()
        
        XCTAssertEqual(searchViewController.dataSource?.snapshot(for: 0).items.count, 0)
    }
    
    func testThatResetFromInitialStateLeavesNoPhotosInDataSource() {
        givenAViewController()
        
        whenTheViewLoads()
        whenPhotosAreReset()
                
        XCTAssertEqual(searchViewController.dataSource?.snapshot(for: 0).items.count, 0)
    }
    
    func testThatItsPossibleToAppendPhotosToDataSourceAfterReset() {
        givenAViewController()
        
        whenTheViewLoads()
        whenPhotosAreAppended(imageCount: 5, nameStartingFrom: 0)
        whenPhotosAreReset()
        whenPhotosAreAppended(imageCount: 3, nameStartingFrom: 0)
        
        XCTAssertEqual(searchViewController.dataSource?.snapshot(for: 0).items.count, 3)
    }

    func testThatItShouldNotFetchMoreWhenBoundaryNotReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 5)
        
        whenTheViewLoads()
        let photos = whenPhotosAreAppended(imageCount: 10, nameStartingFrom: 0)
        
        XCTAssertFalse(searchViewController.shouldFetchMore(reachedPhoto: photos[4]))
    }

    func testThatItShouldFetchMoreWhenBoundaryReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 2)
        
        whenTheViewLoads()
        let photos = whenPhotosAreAppended(imageCount: 10, nameStartingFrom: 0)
        
        XCTAssertTrue(searchViewController.shouldFetchMore(reachedPhoto: photos[9]))
    }
    
    func testThatItIsNotFetchingMoreWhenBoundaryNotReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 5)
        
        whenTheViewLoads()
        let photos = whenPhotosAreAppended(imageCount: 10, nameStartingFrom: 0)
        searchViewController.fetchMoreIfNeeded(reachedPhoto: photos[4])
        
        XCTAssertFalse(viewModel.fetchedNext)
    }

    func testThatItFetchesMoreWhenBoundaryReached() {
        givenAViewController(withDistanceToEndBeforeFetchingMore: 2)
        
        whenTheViewLoads()
        let photos = whenPhotosAreAppended(imageCount: 10, nameStartingFrom: 0)
        searchViewController.fetchMoreIfNeeded(reachedPhoto: photos[9])
        
        XCTAssertTrue(viewModel.fetchedNext)
    }
}
