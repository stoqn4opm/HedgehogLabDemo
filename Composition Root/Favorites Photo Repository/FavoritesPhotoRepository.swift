//
//  FavoritesPhotoRepository.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import ServiceLayer

// MARK: - Favorites Repository

final class FavoritesPhotoRepository: PhotoRepository, PhotoRepositoryModifiable {
    let rawDataHandler: RawDataHandler & RawDataDestructor
    
    /// The key under which `inMemoryStore` is persisted inside `rawDataHandler`.
    let originalSizeMainRecordKey: String
    let thumbnailSizeMainRecordKey: String
    let pageSize: Int
    
    private var originalSizeInMemoryStore: [String: RawPhoto]
    private var thumbnailSizeInMemoryStore: [String: RawPhoto]
    
    init(rawDataHandler: RawDataHandler & RawDataDestructor,
         originalSizeMainRecordKey: String,
         thumbnailSizeMainRecordKey: String,
         pageSize: Int) {
        
        self.rawDataHandler = rawDataHandler
        self.originalSizeMainRecordKey = originalSizeMainRecordKey
        self.thumbnailSizeMainRecordKey = thumbnailSizeMainRecordKey
        self.pageSize = pageSize
        
        originalSizeInMemoryStore = [:]
        thumbnailSizeInMemoryStore = [:]
    }
    
    func fetch(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        photoStorage(for: size) { [weak self] result in
            switch result {
            case .success(let store):
                self?.setInMemoryStore(store, for: size)
                let page = self?.rawPhotoPage(page, for: size) ?? []
                completion(.success(page))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPhotoDetails(forId id: String, inSize size: Photo.Size, withCompletion completion: @escaping (Result<RawPhoto, Error>) -> ()) {
        photoStorage(for: size) { [weak self] result in
            switch result {
            case .success(let store):
                self?.setInMemoryStore(store, for: size)
                
                if let found = store.values.first(where: { $0.id == id }) {
                    completion(.success(found))
                } else {
                    completion(.failure(PhotoServiceError.rawPhotoDetailsMissing))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        photoStorage(for: size) { [weak self] result in
            switch result {
            case .success(let store):
                self?.setInMemoryStore(store, for: size)
                
                let allSearchResults = store.values
                    .filter {
                        $0.title?.lowercased().contains(searchQuery.lowercased()) == true ||
                        $0.description?.lowercased().contains(searchQuery.lowercased()) == true
                    }
                    .chunked(into: self?.pageSize ?? .max)
                
                let pageIndex = page - 1
                let resultsPage = allSearchResults.indices.contains(pageIndex) ? allSearchResults[pageIndex] : []
                completion(.success(resultsPage))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func containsPhoto(withId id: String, inSize size: Photo.Size, completion: @escaping (Result<Bool, PhotoServiceError>) -> ()) {
        photoStorage(for: size) { result in
            switch result {
            case .success(let storage):
                let found = storage.keys.contains(id)
                completion(.success(found))
                
            case .failure(let error):
                completion(.failure(.photoRepositoryError(error)))
            }
        }
    }
    
    func store(_ photo: RawPhoto, withData data: Data, underKey dataAccessorKey: String, forSize size: Photo.Size, completion: @escaping (PhotoServiceError?) -> ()) {
        rawDataHandler.store(data: data, forKey: dataAccessorKey) { [weak self] error in
            if let error = error {
                completion(.photoRepositoryError(error))
            } else {
                self?.addToMemoryStore(photo, forSize: size) { error in
                    completion(error)
                }
            }
        }
    }
    
    func deletePhoto(withId id: String, underKey dataAccessorKey: String, inSize size: Photo.Size, completion: @escaping (PhotoServiceError?) -> ()) {
        photoStorage(for: size) { [weak self] store in // get the relevant store
            switch store {
            case .success(var store):
                if store.removeValue(forKey: id) != nil { // delete photo model
                    
                    // if model deleted, remove raw data
                    self?.rawDataHandler.delete(forKey: dataAccessorKey) { error in
                        if let error = error {
                            completion(.photoRepositoryError(error))
                        } else {
                            
                            // if raw data removed, persist store in rawDataHandler
                            self?.setInMemoryStore(store, for: size)
                            self?.persistStore(store, forSize: size, completion: completion)
                        }
                    }
                } else {
                    // no image with this id found in the store
                    completion(nil)
                }
                
            case .failure(let error):
                completion(.photoRepositoryError(error))
            }
        }
    }
}

// MARK: - Helpers

extension FavoritesPhotoRepository {
    
    private func mainRecordKey(for size: Photo.Size) -> String {
        switch size {
        case .thumbnail:
            return thumbnailSizeMainRecordKey
        case .original:
            return originalSizeMainRecordKey
        }
    }
    
    private func setInMemoryStore(_ store: [String: RawPhoto], for size: Photo.Size) {
        switch size {
        case .thumbnail:
            thumbnailSizeInMemoryStore = store
        case .original:
            originalSizeInMemoryStore = store
        }
    }
    
    private func inMemoryStore(for size: Photo.Size) -> [String: RawPhoto] {
        switch size {
        case .thumbnail:
            return thumbnailSizeInMemoryStore
        case .original:
            return originalSizeInMemoryStore
        }
    }
    
    private func rawPhotoPage(_ page: Int, for size: Photo.Size) -> [RawPhoto] {
        let all = Array(inMemoryStore(for: size).values).chunked(into: pageSize)
        let pageIndex = page - 1
        return all.indices.contains(pageIndex) ? all[pageIndex] : []
    }
    
    private func photoStorage(for size: Photo.Size, completion: @escaping (Result<[String: RawPhoto], Error>) -> ()) {
        if inMemoryStore(for: size).isEmpty == false {
            completion(.success(inMemoryStore(for: size)))
        } else {
            rawDataHandler.read(forKey: mainRecordKey(for: size)) { result in
                switch result {
                case .success(let data):
                    
                    do {
#warning("don't reference directly FavoriteRawPhoto")
                        let store = try JSONDecoder().decode([String: FavoriteRawPhoto].self, from: data)
                        completion(.success(store))
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    if let error = error as? CacheDirectoryRawDataAccessor.Error,
                       error == .dataNotFound {
                        completion(.success([:]))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func addToMemoryStore(_ photo: RawPhoto, forSize size: Photo.Size, completion: @escaping (PhotoServiceError?) -> ()) {
        photoStorage(for: size) { [weak self] result in
            switch result {
            case .success(var storage):
                storage[photo.id] = photo
                self?.persistStore(storage, forSize: size) { error in
                    completion(error)
                }
                
            case .failure(let error):
                completion(.photoRepositoryError(error))
            }
        }
    }
    
    private func persistStore(_ store: [String: RawPhoto], forSize size: Photo.Size, completion: @escaping (PhotoServiceError?) -> ()) {
#warning("don't reference directly FavoriteRawPhoto")
        
        setInMemoryStore(store, for: size)
        do {
            let storeData = try JSONEncoder().encode(store as! [String : FavoriteRawPhoto])
            rawDataHandler.store(data: storeData, forKey: mainRecordKey(for: size)) { error in
                if let error = error {
                    completion(.photoRepositoryError(error))
                } else {
                    completion(nil)
                }
            }
        } catch {
            completion(.photoRepositoryError(error))
        }
    }
}
