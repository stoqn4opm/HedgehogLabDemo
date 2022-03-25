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
    
    func fetchMostPopular(page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        GalleryEndpoint(inTimeWindow: .all, page: page, appClientId: appClientId) { result, error in
            if let rawPhotos = result?.data {
                completion(.success(rawPhotos))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func search(searchQuery: String, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        GallerySearchEndpoint(searchQuery: searchQuery, inTimeWindow: .all, page: page, appClientId: appClientId) { result, error in
            if let rawPhotos = result?.data {
                completion(.success(rawPhotos))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Raw Photo Conformance

extension Image: RawPhoto {
    
    public var downloadURL: URL? {
        URL(string: link)
    }
}
