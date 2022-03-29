//
//  PhotoTabViewModel.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import Combine
import CombineSchedulers
import UIKit
import ServiceLayer

// MARK: - PhotoTabViewModelState

enum PhotoTabViewModelState {
    case list
    case search
}

// MARK: - PhotoTabViewModelType

protocol PhotoTabViewModelType {
    
    /// Gives info regarding the current state of the model.
    var state: PhotoTabViewModelState { get }
    
    /// Gives you back the title that needs to be presented to the user.
    var screenTitle: String { get }
    
    /// Fetches the most popular photos from the photo service.
    func fetchMostPopular()
    
    /// Instructs the view model that its time to do initial fetch.
    func initialFetch()
    
    /// Searches for photos from the photo service.
    func searchPhoto(searchQuery: String)
    
    /// Fetches the next page of photos to be presented to the user.
    func fetchNext()
    
    /// Triggers a refresh of the current results.
    func refresh()
    
    /// Notifies the view model that the user want to see this photo.
    func openPhotoDetails(_ photo: Photo, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ())
    
    /// Publishes when the photo list changes.
    var photosChangedPublisher: AnyPublisher<[Photo], Never> { get }
    
    /// Sends `true` when the view model is going to perform
    /// a fetch operation and `false` when its done.
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    
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

// MARK: - Photo Tab View Model

final class PhotoTabViewModel: PhotoTabViewModelType {
    typealias Routes = PhotoDetailsViewRoute
    let router: Routes
    
    let tab: Tabs
    let photoService: PhotoService
    let favoritePhotoService: PhotoServiceModifiable
    
    @Published private(set) var state: PhotoTabViewModelState
    
    /// Keeps track on which page we are
    private var currentPage: Int
    private var searchQuery: String
    
    @Published private var photos: [Photo]
    private var isLoadingSubject = PassthroughSubject<Bool, Never>()
    private var errorMessageSubject = PassthroughSubject<String, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(router: Routes, photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable, tab: Tabs) {
        self.router = router
        self.photoService = photoService
        self.favoritePhotoService = favoritePhotoService
        self.tab = tab
        self.state = .list
        self.currentPage = 1
        self.photos = []
        self.searchQuery = ""
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $state
            .removeDuplicates()
            .map { _ in () }
            .sink { [weak self] _ in
                self?.reset()
            }
            .store(in: &cancellables)
        
        guard favoritePhotoService === photoService else { return }
        
        favoritePhotoService
            .photoStoredPublisher
            .sink { [weak self] tuple in
                guard tuple.size == .thumbnail else { return }
                guard self?.photos.contains(tuple.photo) == false else { return }
                self?.photos.append(tuple.photo)
            }
            .store(in: &cancellables)
        
        favoritePhotoService
            .photoDeletedPublisher
            .sink { [weak self] tuple in
                guard tuple.size == .thumbnail else { return }
                guard let index = self?.photos.firstIndex(of: tuple.photo) else { return }
                self?.photos.remove(at: index)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Interface Publishers

extension PhotoTabViewModel {
    
    var photosChangedPublisher: AnyPublisher<[Photo], Never> {
        $photos.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String, Never> {
        errorMessageSubject
            .eraseToAnyPublisher()
    }
}

// MARK: - Commands

extension PhotoTabViewModel {
    
    func initialFetch() {
        guard favoritePhotoService !== photoService else { return }
        fetchMostPopular()
    }
    
    func fetchMostPopular() {
        state = .list
        isLoadingSubject.send(true)
        photoService.fetch(inSize: .thumbnail, page: currentPage) { [weak self] result in
            self?.handleFetchResult(result)
        }
    }
    
    func searchPhoto(searchQuery: String) {
        state = .search
        if self.searchQuery != searchQuery {
            // because we want to reset on different consecutive searches
            reset()
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
        reset()
        fetch()
    }
    
    func openPhotoDetails(_ photo: Photo, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ()) {
        router.openPhoto(photo: photo,
                         photoService: photoService,
                         favoritePhotoService: favoritePhotoService,
                         scheduler: scheduler,
                         completion: completion)
    }
}

// MARK: - Queries

extension PhotoTabViewModel {
    
    func graphicRepresentation(for photo: Photo, withCompletion completion: @escaping (UIImage?) -> ()) {
        photoService.rawImageData(forPhoto: photo) { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
                
            case .failure(let error):
                print("[PhotoTabViewModel] Failed loading graphic representation of image with error: \(error)")
                self?.errorMessageSubject.send(String(format: "Loading graphic for image %s representation failed".localized, photo.title))
            }
        }
    }
    
    func photo(at index: Int) -> Photo? {
        guard photos.indices.contains(index) else { return nil }
        return photos[index]
    }
    
    var screenTitle: String {
        switch tab {
        case .search:
            return "Search".localized
        case .favorites:
            return "Favorites".localized
        }
    }
}

// MARK: - Helpers

extension PhotoTabViewModel {
    
    private func reset() {
        currentPage = 1
        photos = []
    }
    
    private func fetch() {
        switch state {
        case .list:
            fetchMostPopular()
            
        case .search:
            searchPhoto(searchQuery: searchQuery)
        }
    }
    
    private func handleFetchResult(_ result: Result<[Photo], PhotoServiceError>) {
        isLoadingSubject.send(false)
        
        switch result {
        case .success(let result):
            let newlyAdded = result
                .filter { photos.contains($0) == false }
            
            photos.append(contentsOf: newlyAdded)
            
        case .failure(let error):
            print("[PhotoTabViewModel] Failed most popular photos with error: \(error)")
            errorMessageSubject.send("Failed most popular photos".localized)
        }
    }
}
