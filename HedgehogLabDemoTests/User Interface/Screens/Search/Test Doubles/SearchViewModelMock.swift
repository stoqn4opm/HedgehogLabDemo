//
//  SearchViewModelMock.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import Foundation
import Combine
import ServiceLayer
import UIKit
@testable import HedgehogLabDemoUI

final class SearchViewModelMock: SearchViewModelType {
    var state: SearchViewModelState = .mostPopular
     
    private(set) var fetchedMostPopular = false
    private(set) var fetchedNext = false
    private(set) var refreshed = false
    
    private(set) var appendPhotosSubject = PassthroughSubject<[Photo], Never>()
    private(set) var resetPhotosSubject = PassthroughSubject<Void, Never>()
    
    
    var appendPhotosPublisher: AnyPublisher<[Photo], Never> {
        appendPhotosSubject.eraseToAnyPublisher()
    }
    
    var resetPhotosPublisher: AnyPublisher<Void, Never> {
        resetPhotosSubject.eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String, Never> {
        Just("").eraseToAnyPublisher()
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
    
    func searchPhoto(searchQuery: String) {
        
    }
       
    func graphicRepresentation(for photo: Photo, withCompletion completion: @escaping (UIImage?) -> ()) {
        
    }
    
    func photo(at index: Int) -> Photo? {
        nil
    }
}
