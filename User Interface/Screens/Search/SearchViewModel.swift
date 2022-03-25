//
//  SearchViewModel.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import Combine
import UIKit
import ServiceLayer

protocol PhotoRepository {
    func fetchMostPopular(withCompletion completion: (Result<UIImage, Error>) -> Void)
}

extension Photo {
    var asImage: UIImage { UIImage() }
}

protocol SearchViewModelType {
    func fetchMostPopular()
    func fetchNext()
    func refresh()
    
    var appendPhotosPublisher: AnyPublisher<[Photo], Error> { get }
    var resetPhotosPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - Search View Model

final class SearchViewModel: SearchViewModelType {
    
    let router: Router
    let repository: PhotoRepository
    
    init(router: Router, repository: PhotoRepository) {
        self.router = router
        self.repository = repository
    }
    
    var appendPhotosPublisher: AnyPublisher<[Photo], Error> {
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    var resetPhotosPublisher: AnyPublisher<Void, Never> {
        Just(())
            .eraseToAnyPublisher()
    }
    
    func fetchMostPopular() {
        
    }
    
    func fetchNext() {
        
    }
    
    func refresh() {
        
    }
}
