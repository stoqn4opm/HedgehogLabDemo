//
//  ImgurPhotoRepository.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ImgurAPI
import ServiceLayer

// MARK: - Imgur Repository

final class ImgurPhotoRepository: PhotoRepository {
    
    let appClientId: String
    
    init(appClientId: String) {
        self.appClientId = appClientId
    }
    
    func fetch(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        GalleryEndpoint(inTimeWindow: .all, page: page, appClientId: appClientId) { result, error in
            if let rawResult = result?.data {
                let photosOnly = rawResult
                    .filter { $0.isAd == false && $0.isAlbum == false && $0.isAnimated == false }
                    .compactMap { ImgurGalleryRawPhoto(galleryImage: $0, inSize: size) }
                completion(.success(photosOnly))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func fetchPhotoDetails(forId id: String, inSize size: Photo.Size, withCompletion completion: @escaping (Result<RawPhoto, Error>) -> ()) {
        ImageEndpoint(imageId: id, appClientId: appClientId) { result, error in
            if let rawResult = result?.data,
               let rawPhoto = ImgurImageRawPhoto(image: rawResult, inSize: .original) {
                completion(.success(rawPhoto))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        GallerySearchEndpoint(searchQuery: searchQuery, inTimeWindow: .all, page: page, appClientId: appClientId) { result, error in
            if let rawResult = result?.data {
                let photosOnly = rawResult
                    .filter { $0.isAd == false && $0.isAlbum == false && $0.isAnimated == false }
                    .compactMap { ImgurGalleryRawPhoto(galleryImage: $0, inSize: size) }
                completion(.success(photosOnly))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}


// MARK: - Photo Size Translation

extension Photo.Size {
    var imgurSize: ThumbnailsLinkCoordinator.ThumbnailSize {
        switch self {
        case .original: return .original
        case .thumbnail: return .mediumThumbnail
        }
    }
}
