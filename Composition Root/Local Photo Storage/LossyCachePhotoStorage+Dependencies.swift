//
//  LossyCachePhotoStorage+Dependencies.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation

// MARK: - LossyCachePhotoStorage Dependencies

protocol RawDataAccessor {
    func store(data: Data, forKey: String, withCompletion completion: @escaping (Error?) -> ())
    func read(forKey key: String, withCompletion completion: @escaping (Result<Data, Error>) -> ())
}

protocol RawDataDownloader {
    func download(url: URL, withCompletion completion: @escaping (Result<Data, Error>) -> ())
}
