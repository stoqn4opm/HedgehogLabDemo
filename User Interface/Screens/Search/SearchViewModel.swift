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
    let photoService: PhotoService
    
    init(router: Router, photoService: PhotoService) {
        self.router = router
        self.photoService = photoService
        
        photoService.photoRepository.fetchMostPopular(page: 1) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
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
