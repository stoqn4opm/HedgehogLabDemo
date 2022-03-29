//
//  CachingPhotoService.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import Combine

/// Photo service that before is providing photos to its callers, first stores them in a `PhotoStorage`.
/// When requesting `rawImageData()`, it gets it straight from the `PhotoStorage`.
public final class CachingPhotoService: PhotoService {
    
    let photoRepository: PhotoRepository
    let photoStorage: PhotoStorage
    
    public init(photoRepository: PhotoRepository, photoStorage: PhotoStorage) {
        self.photoRepository = photoRepository
        self.photoStorage = photoStorage
    }
}

// MARK: - Interface

extension CachingPhotoService {
    public func fetch(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ()) {
        photoRepository.fetch(inSize: size, page: page) { [weak self] result in
            self?.cacheMultiPhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func fetchPhotoDetails(forId id: String, inSize size: Photo.Size, withCompletion completion: @escaping (Result<Photo, PhotoServiceError>) -> ()) {
        photoRepository.fetchPhotoDetails(forId: id, inSize: size) { [weak self] result in
            self?.cachePhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ()) {
        photoRepository.search(searchQuery: searchQuery, inSize: size, page: page) { [weak self] result in
            self?.cacheMultiPhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func rawImageData(forPhoto photo: Photo, completion: @escaping (Result<Data, PhotoServiceError>) -> ()) {
        photoStorage.readPhotoRawData(forPhoto: photo) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(.photoStorageError(error)))
            }
        }
    }
}

// MARK: - Result Handlers

extension CachingPhotoService {
    
    private func cacheMultiPhotoFetchingResult(_ result: Result<[RawPhoto], Swift.Error>, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ()) {
        switch result {
        case .success(let rawPhotos):
            photoStorage.storePhotos(rawPhotos.map { (key: $0.id, photo: $0) }) { result in
                switch result {
                case .success(let photos):
                    completion(.success(photos))
                    
                case .failure(let error):
                    completion(.failure(.photoStorageError(error)))
                }
            }
            
        case .failure(let error):
            completion(.failure(.photoRepositoryError(error)))
        }
    }
    
    private func cachePhotoFetchingResult(_ result: Result<RawPhoto, Swift.Error>, withCompletion completion: @escaping (Result<Photo, PhotoServiceError>) -> ()) {
        switch result {
        case .success(let rawPhoto):
            photoStorage.storePhoto(rawPhoto, forKey: rawPhoto.id) { result in
                switch result {
                case .success(let photo):
                    completion(.success(photo))
                    
                case .failure(let error):
                    completion(.failure(.photoStorageError(error)))
                }
            }
            
        case .failure(let error):
            completion(.failure(.photoRepositoryError(error)))
        }
    }
}
