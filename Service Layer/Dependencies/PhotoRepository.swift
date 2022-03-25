//
//  PhotoRepository.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation

/// Representing, unprocessed, raw photo that haven't been downloaded from the internet yet.
public protocol RawPhoto {
    var title: String { get }
    var description: String? { get }
    var downloadURL: URL? { get }
}

public protocol PhotoRepository {
 
    func fetchMostPopular(page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ())
    func search(searchQuery: String, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ())
}
