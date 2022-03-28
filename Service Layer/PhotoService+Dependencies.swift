//
//  PhotoServiceDependencies.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation

/// Representing, unprocessed, raw photo that haven't been downloaded from the internet yet.
public protocol RawPhoto {
    var id: String { get }
    var title: String { get }
    var description: String? { get }
    var downloadURL: URL { get }
    var tags: [String] { get }
    var viewCount: Int { get }
}

public protocol PhotoRepository {
 
    func fetchMostPopular(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ())
    func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ())
}

public protocol PhotoStorage {
    
    func storePhoto(_ rawPhoto: RawPhoto, forKey: String, completion: @escaping (Result<Photo, Error>) -> ())
    func storePhotos(_ tuples: [(key: String, photo: RawPhoto)], completion: @escaping (Result<[Photo], Error>) -> ())
    func readPhotoRawData(forPhoto photo: Photo, completion: @escaping (Result<Data, Error>) -> ())
}
