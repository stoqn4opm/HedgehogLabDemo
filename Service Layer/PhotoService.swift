//
//  PhotoService.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import Combine


public final class PhotoService {
    
    let photoRepository: PhotoRepository
    let photoStorage: PhotoStorage
    
    public init(photoRepository: PhotoRepository, photoStorage: PhotoStorage) {
        self.photoRepository = photoRepository
        self.photoStorage = photoStorage
    }
}

// MARK: - Interface

extension PhotoService {
    public func fetchMostPopular(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], Error>) -> ()) {
        photoRepository.fetchMostPopular(inSize: size, page: page) { [weak self] result in
            self?.handleMultiPhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func fetchPhotoDetails(forId id: String, inSize size: Photo.Size, withCompletion completion: @escaping (Result<Photo, Error>) -> ()) {
        photoRepository.fetchPhotoDetails(forId: id, inSize: size) { [weak self] result in
            self?.handlePhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], Error>) -> ()) {
        photoRepository.search(searchQuery: searchQuery, inSize: size, page: page) { [weak self] result in
            self?.handleMultiPhotoFetchingResult(result, withCompletion: completion)
        }
    }
    
    public func rawImageData(forPhoto photo: Photo, completion: @escaping (Result<Data, Error>) -> ()) {
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

extension PhotoService {
    
    private func handleMultiPhotoFetchingResult(_ result: Result<[RawPhoto], Swift.Error>, withCompletion completion: @escaping (Result<[Photo], Error>) -> ()) {
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
    
    private func handlePhotoFetchingResult(_ result: Result<RawPhoto, Swift.Error>, withCompletion completion: @escaping (Result<Photo, Error>) -> ()) {
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
