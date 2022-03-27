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
    
    func fetchMostPopular(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
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
    
    func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        GallerySearchEndpoint(searchQuery: searchQuery, inTimeWindow: .all, page: page, appClientId: appClientId) { result, error in
            if let rawResult = result?.data {
                let photosOnly = rawResult
                    .filter { $0.isAd == false && $0.isAlbum == false }
                    .compactMap { ImgurGalleryRawPhoto(galleryImage: $0, inSize: size) }
                completion(.success(photosOnly))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Raw Photo Conformance

final class ImgurGalleryRawPhoto: RawPhoto {
    
    let galleryImage: GalleryImage
    let downloadURL: URL
    let width: Int
    let height: Int
    
    init?(galleryImage: GalleryImage, inSize size: Photo.Size) {
        self.galleryImage = galleryImage
        
        guard let width = galleryImage.width,
              let height = galleryImage.height else { return nil }
        
        self.width = width
        self.height = height
        
        guard let url = URL(string: galleryImage.link) else { return nil }
        let coordinator = ThumbnailsLinkCoordinator(originalLink: url)
        guard let link = coordinator.url(withSize: size.imgurSize) else { return nil }
        
        downloadURL = link
    }
    
    var id: String { galleryImage.id }
    var title: String { galleryImage.title }
    var description: String? { galleryImage.description }
}

// MARK: - Photo Size Translation

extension Photo.Size {
    fileprivate var imgurSize: ThumbnailsLinkCoordinator.ThumbnailSize {
        switch self {
        case .original: return .original
        case .thumbnail: return .mediumThumbnail
        }
    }
}
