//
//  FavoritesPhotoService.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 29/03/22.
//

import Foundation
import ServiceLayer

// MARK: - Favorites PhotoService

/// Non caching photo service, that can be modified freely and can have photos imported
/// from another PhotoService referred to as "source photo service".
final class FavoritesPhotoService: NonCachingPhotoService, PhotoServiceModifiable {
    
    let sourcePhotoService: PhotoService
    let photoRepository: PhotoRepository & PhotoRepositoryModifiable
    let accessor: RawDataHandler
    
    init(sourcePhotoService: PhotoService, photoRepository: PhotoRepository & PhotoRepositoryModifiable, accessor: RawDataHandler) {
        self.sourcePhotoService = sourcePhotoService
        self.photoRepository = photoRepository
        self.accessor = accessor
        super.init(photoRepository: photoRepository, accessor: accessor)
    }
    
    func store(_ photo: Photo, withSize size: Photo.Size, completion: @escaping (PhotoServiceError?) -> ()) {
        let rawPhoto = FavoriteRawPhoto(id: photo.id,
                         title: photo.title,
                         description: photo.description,
                         downloadURL: accessor.managedURL.appendingPathComponent(photo.id),
                         tags: photo.tags,
                         viewCount: photo.viewCount)

        
        sourcePhotoService.rawImageData(forPhoto: photo) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoRepository.store(rawPhoto,
                                            withData: data,
                                            underKey: photo.dataAccessorKey,
                                            forSize: size,
                                            completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func delete(_ photo: Photo, withSize size: Photo.Size, completion: @escaping (PhotoServiceError?) -> ()) {
        photoRepository.deletePhoto(withId: photo.id, underKey: photo.dataAccessorKey, inSize: size, completion: completion)
    }
}
