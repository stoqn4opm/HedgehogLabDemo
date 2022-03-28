//
//  PhotoServiceFacade.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import Combine


public protocol PhotoServiceFacade {
    func fetch(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ())
    func fetchPhotoDetails(forId id: String, inSize size: Photo.Size, withCompletion completion: @escaping (Result<Photo, PhotoServiceError>) -> ())
    func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[Photo], PhotoServiceError>) -> ())
    func rawImageData(forPhoto photo: Photo, completion: @escaping (Result<Data, PhotoServiceError>) -> ())
}

/// Representing unprocessed, raw photo that has just been given back by a `PhotoRepository`
/// In the case of network based `PhotoRepository` that would be a simple model with a link from where
/// to download the image.
public protocol RawPhoto {
    var id: String { get }
    var title: String { get }
    var description: String? { get }
    var downloadURL: URL { get }
    var tags: [String] { get }
    var viewCount: Int { get }
}

/// Source that could provide `RawPhoto`s. That's the origin of where the photos are coming from.
public protocol PhotoRepository {
 
    func fetch(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ())
    func fetchPhotoDetails(forId id: String, inSize size: Photo.Size, withCompletion completion: @escaping (Result<RawPhoto, Error>) -> ())
    func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ())
}

/// Place where photos are kept, including their raw image data representation.
public protocol PhotoStorage {
    
    func storePhoto(_ rawPhoto: RawPhoto, forKey: String, completion: @escaping (Result<Photo, Error>) -> ())
    func storePhotos(_ tuples: [(key: String, photo: RawPhoto)], completion: @escaping (Result<[Photo], Error>) -> ())
    func readPhotoRawData(forPhoto photo: Photo, completion: @escaping (Result<Data, Error>) -> ())
}

// MARK: - Photo Service Errors

/// All possible user facing errors that can occur when interacting with the public interface of `PhotoService`.
public enum PhotoServiceError: Swift.Error {
    
    case photoRepositoryError(Error)
    case photoStorageError(Error)
    case photoStorageMultipleSavesFailed
    case graphicRepresentationError
}
