//
//  SearchViewModel.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import Combine
import CombineSchedulers
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
    
    /// Searches for photos from the photo service.
    func searchPhoto(searchQuery: String)
    
    /// Fetches the next page of photos to be presented to the user.
    func fetchNext()
    
    /// Triggers a refresh of the current results.
    func refresh()
    
    /// Notifies the view model that the user want to see this photo.
    func openPhotoDetails(_ photo: Photo, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ())
    
    /// Publishes when a badge of more photos needs to be presented to the user.
    var appendPhotosPublisher: AnyPublisher<[Photo], Never> { get }
    
    /// Sends `true` when the view model is going to perform
    /// a fetch operation and `false` when its done.
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    
    /// Publishes when list photo list needs to be cleared.
    var resetPhotosPublisher: AnyPublisher<Void, Never> { get }
    
    /// Publishes when error message needs to be presented to the user.
    var errorMessagePublisher: AnyPublisher<String, Never> { get }
    
    /// Generates a graphical representation for a photo.
    func graphicRepresentation(for photo: Photo, withCompletion completion: @escaping (UIImage?) -> ())
    
    /// Gives you back a photo object at the given index.
    ///
    /// - Parameter index: The index at which you want to fetch the item
    /// - Returns: The found item, or `nil` if `index` is invalid.
    func photo(at index: Int) -> Photo?
}

// MARK: - Search View Model

final class SearchViewModel: SearchViewModelType {
    typealias Routes = PhotoDetailsViewRoute
    let router: Routes
    
    let photoService: PhotoService
    
    @Published private(set) var state: SearchViewModelState
    
    /// Keeps track on which page we are
    private var currentPage: Int
    private var photos: [Photo]
    private var searchQuery: String
    
    private var appendPhotosSubject = PassthroughSubject<[Photo], Never>()
    private var isLoadingSubject = PassthroughSubject<Bool, Never>()
    private var resetPhotosSubject = PassthroughSubject<Void, Never>()
    private var errorMessageSubject = PassthroughSubject<String, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(router: Routes, photoService: PhotoService, state: SearchViewModelState) {
        self.router = router
        self.photoService = photoService
        self.state = state
        self.currentPage = 1
        self.photos = []
        self.searchQuery = ""
        
        resetPhotosPublisher
            .sink { [weak self] _ in
                self?.currentPage = 1
                self?.photos = []
            }
            .store(in: &cancellables)
        
        appendPhotosPublisher
            .sink { [weak self] newPhotos in
                self?.photos.append(contentsOf: newPhotos)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Interface Publishers

extension SearchViewModel {
    
    var appendPhotosPublisher: AnyPublisher<[Photo], Never> {
        appendPhotosSubject
            .eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject
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
        isLoadingSubject.send(true)
        photoService.fetchMostPopular(inSize: .thumbnail, page: currentPage) { [weak self] result in
            self?.handleFetchResult(result)
        }
    }
    
    func searchPhoto(searchQuery: String) {
        state = .search
        if self.searchQuery != searchQuery {
            // because we want to reset on different consecutive searches
            resetPhotosSubject.send(())
        }
        
        self.searchQuery = searchQuery
        isLoadingSubject.send(true)
        photoService.search(searchQuery: searchQuery, inSize: .thumbnail, page: currentPage) { [weak self] result in
            self?.handleFetchResult(result)
        }
    }
    
    func fetchNext() {
        currentPage += 1
        fetch()
    }
    
    func refresh() {
        resetPhotosSubject.send(())
        fetch()
    }
    
    func openPhotoDetails(_ photo: Photo, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ()) {
        router.openPhoto(photo: photo, photoService: photoService, scheduler: scheduler, completion: completion)
    }
}

// MARK: - Queries

extension SearchViewModel {
    
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
    
    func photo(at index: Int) -> Photo? {
        guard photos.indices.contains(index) else { return nil }
        return photos[index]
    }
}

// MARK: - Helpers

extension SearchViewModel {
    
    private func fetch() {
        switch state {
        case .mostPopular:
            fetchMostPopular()
            
        case .search:
            searchPhoto(searchQuery: searchQuery)
        }
    }
    
    private func handleFetchResult(_ result: Result<[Photo], PhotoService.Error>) {
        isLoadingSubject.send(false)
        
        switch result {
        case .success(let result):
            appendPhotosSubject.send(result)
            
        case .failure(let error):
            print("[SearchViewModel] Failed most popular photos with error: \(error)")
            errorMessageSubject.send("Failed most popular photos".localized)
        }
    }
}
