//
//  SearchViewModelMock.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import Foundation
import Combine
@testable import HedgehogLabDemo

final class SearchViewModelMock: SearchViewModelType {
     
    private(set) var fetchedMostPopular = false
    private(set) var fetchedNext = false
    private(set) var refreshed = false
    
    private(set) var appendPhotosSubject = PassthroughSubject<[Photo], Error>()
    private(set) var resetPhotosSubject = PassthroughSubject<Void, Never>()
    
    
    var appendPhotosPublisher: AnyPublisher<[Photo], Error> {
        appendPhotosSubject.eraseToAnyPublisher()
    }
    
    var resetPhotosPublisher: AnyPublisher<Void, Never> {
        resetPhotosSubject.eraseToAnyPublisher()
    }
    
    
    func fetchMostPopular() {
        fetchedMostPopular = true
    }
    
    func fetchNext() {
        fetchedNext = true
    }
    
    func refresh() {
        refreshed = true
    }
}
