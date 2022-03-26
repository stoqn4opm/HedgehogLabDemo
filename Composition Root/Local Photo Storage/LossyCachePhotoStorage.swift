//
//  LossyPhotoStorage.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ServiceLayer
import Combine

// MARK: - Local Lossy Photo Storage

/// Stores the passed photos on disk in NSCaches directory.
///
/// It is said to be lossy, as the caches can be wiped by the OS
/// and also when saving multiple photos simultaneously, in case
/// of write failures they are dismissed, and only the successful
/// writes are returned.
class LossyCachePhotoStorage: PhotoStorage {
    
    let downloader: RawDataDownloader
    let accessor: RawDataAccessor
    
    init(downloader: RawDataDownloader, accessor: RawDataAccessor) {
        self.downloader = downloader
        self.accessor = accessor
    }
    
    func storePhotos(_ tuples: [(key: String, photo: RawPhoto)], completion: @escaping (Result<[Photo], Error>) -> ()) {
        var cancellable: AnyCancellable?
        cancellable = tuples.publisher
            .flatMap { [weak self] tuple -> AnyPublisher<Result<Photo, Error>, Never> in
                Future<Result<Photo, Error>, Never> { [weak self] promise in
                    self?.storePhoto(tuple.photo, forKey: tuple.key) { result in
                        switch result {
                        case .success(let photo):
                            promise(.success(.success(photo)))
                        case .failure(let error):
                            promise(.success(.failure(error)))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .collect()
            .eraseToAnyPublisher()
            .sink { individualResults in
                let photos = individualResults.compactMap { result -> Photo? in
                    switch result {
                    case .success(let photo): return photo
                    case .failure: return nil
                    }
                }
                
                if photos.isEmpty {
                    completion(.failure(PhotoService.Error.photoStorageMultipleSavesFailed))
                } else {
                    completion(.success(photos))
                }
                
                _ = cancellable // referenced just to be kept in memory during execution
            }
    }
    
    func storePhoto(_ rawPhoto: RawPhoto, forKey: String, completion: @escaping (Result<Photo, Error>) -> ()) {
        downloader.download(url: rawPhoto.downloadURL) { [weak self] result in
            switch result {
            case .success(let data):
                self?.accessor.store(data: data, forKey: rawPhoto.id) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        let photo = Photo(rawPhoto: rawPhoto, dataAccessorKey: rawPhoto.id)
                        completion(.success(photo))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func readPhotoRawData(forPhoto photo: Photo, completion: @escaping (Result<Data, Error>) -> ()) {
        accessor.read(forKey: photo.dataAccessorKey) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
