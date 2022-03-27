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

// MARK: - SearchViewModelState

enum SearchViewModelState {
    case mostPopular
    case search
}

// MARK: - SearchViewModelType

protocol SearchViewModelType {
    
    /// Gives info regarding the current state of the model.
    var state: SearchViewModelState { get }
    
    /// Fetches the most popular photos from the photo service.
    func fetchMostPopular()
    
    /// Fetches the next page of photos to be presented to the user.
    func fetchNext()
    
    /// Triggers a refresh of the current results.
    func refresh()
    
    /// Publishes when a badge of more photos needs to be presented to the user.
    var appendPhotosPublisher: AnyPublisher<[Photo], Error> { get }
    
    /// Publishes when list photo list needs to be cleared.
    var resetPhotosPublisher: AnyPublisher<Void, Never> { get }
    
    /// Publishes when error message needs to be presented to the user.
    var errorMessagePublisher: AnyPublisher<String, Never> { get }
    
    /// Generates a graphical representation for a photo.
    func graphicRepresentation(for photo: Photo, withCompletion completion: @escaping (UIImage?) -> ())
}

// MARK: - Search View Model

final class SearchViewModel: SearchViewModelType {
    
    let router: Router
    let photoService: PhotoService
    
    @Published private(set) var state: SearchViewModelState
    
    /// Keeps track on which page we are
    private var currentPage: Int
    
    private var appendPhotosSubject = PassthroughSubject<[Photo], Error>()
    private var resetPhotosSubject = PassthroughSubject<Void, Never>()
    private var errorMessageSubject = PassthroughSubject<String, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(router: Router, photoService: PhotoService, state: SearchViewModelState) {
        self.router = router
        self.photoService = photoService
        self.state = state
        self.currentPage = 1

        $state
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.currentPage = 1
            }
            .store(in: &cancellables)
    }
}

// MARK: - Interface Publishers

extension SearchViewModel {
    
    var appendPhotosPublisher: AnyPublisher<[Photo], Error> {
        appendPhotosSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var resetPhotosPublisher: AnyPublisher<Void, Never> {
        $state
            .removeDuplicates()
            .map { _ in () }
            .merge(with: resetPhotosSubject)
            .eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String, Never> {
        errorMessageSubject
            .eraseToAnyPublisher()
    }
}

// MARK: - Commands

extension SearchViewModel {
    
    func fetchMostPopular() {
        state = .mostPopular
        
        photoService.fetchMostPopular(inSize: .thumbnail, page: currentPage) { [weak self] result in
            switch result {
            case .success(let result):
                self?.appendPhotosSubject.send(result)
                
            case .failure(let error):
                print("[SearchViewModel] Failed most popular photos with error: \(error)")
                self?.errorMessageSubject.send("Failed most popular photos".localized)
            }
        }
    }
    
    func fetchNext() {
        currentPage += 1
        fetch()
    }
    
    func refresh() {
        currentPage = 1
        resetPhotosSubject.send(())
        fetch()
    }
    
    func graphicRepresentation(for photo: Photo, withCompletion completion: @escaping (UIImage?) -> ()) {
        photoService.rawImageData(forPhoto: photo) { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
                
            case .failure(let error):
                print("[SearchViewModel] Failed loading graphic representation of image with error: \(error)")
                self?.errorMessageSubject.send(String(format: "Loading graphic for image %s representation failed".localized, photo.title))
            }
        }
    }
}

// MARK: - Helpers

extension SearchViewModel {
    
    private func fetch() {
        switch state {
        case .mostPopular:
            fetchMostPopular()
            
        case .search:
            break
        }
    }
}
