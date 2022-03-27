//
//  LossyCachePhotoStorage+Dependencies.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation

// MARK: - LossyCachePhotoStorage Dependencies

public protocol RawDataAccessor {
    func store(data: Data, forKey key: String, withCompletion completion: @escaping (Error?) -> ())
    func read(forKey key: String, withCompletion completion: @escaping (Result<Data, Error>) -> ())
}

public protocol RawDataDownloader {
    func download(url: URL, withCompletion completion: @escaping (Result<Data, Error>) -> ())
}
