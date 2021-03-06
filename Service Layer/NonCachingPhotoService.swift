//
//  NonCachingPhotoService.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import Combine

/// Photo service that before is providing photos to its callers, first stores them in a `PhotoStorage`.
/// When requesting `rawImageData()`, it gets it straight from the `PhotoStorage`.
open class NonCachingPhotoService: PhotoService {
    
    let photoRepository: PhotoRepository
    let accessor: RawDataHandler
    
    public init(photoRepository: PhotoRepository, accessor: RawDataHandler) {
        self.photoRepository = photoRepository
        self.accessor = accessor
    }
}

// MARK: - Interface

extension NonCachingPhotoService {
    public func fetch(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ()) {
        photoRepository.fetch(inSize: size, page: page) { [weak self] result in
            self?.handleMultiPhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func fetchPhotoDetails(forId id: String, inSize size: Photo.Size, withCompletion completion: @escaping (Result<Photo, PhotoServiceError>) -> ()) {
        photoRepository.fetchPhotoDetails(forId: id, inSize: size) { [weak self] result in
            self?.handlePhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ()) {
        photoRepository.search(searchQuery: searchQuery, inSize: size, page: page) { [weak self] result in
            self?.handleMultiPhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func rawImageData(forPhoto photo: Photo, completion: @escaping (Result<Data, PhotoServiceError>) -> ()) {
        accessor.read(forKey: photo.url.lastPathComponent) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(.rawDataHandlerError(error)))
            }
        }
    }
}

// MARK: - Result Handlers

extension NonCachingPhotoService {
    
    private func handleMultiPhotoFetchingResult(_ result: Result<[RawPhoto], Swift.Error>, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ()) {
        switch result {
        case .success(let rawPhotos):
            let photos = rawPhotos.map { Photo(id: $0.id, title: $0.title, description: $0.description, viewCount: $0.viewCount, tags: $0.tags, url: $0.downloadURL) }
            completion(.success(photos))
            
        case .failure(let error):
            completion(.failure(.photoRepositoryError(error)))
        }
    }
    
    private func handlePhotoFetchingResult(_ result: Result<RawPhoto, Swift.Error>, withCompletion completion: @escaping (Result<Photo, PhotoServiceError>) -> ()) {
        switch result {
        case .success(let rawPhoto):
            let photo = Photo(id: rawPhoto.id, title: rawPhoto.title, description: rawPhoto.description, viewCount: rawPhoto.viewCount, tags: rawPhoto.tags, url: rawPhoto.downloadURL)
            completion(.success(photo))
            
        case .failure(let error):
            completion(.failure(.photoRepositoryError(error)))
        }
    }
}
