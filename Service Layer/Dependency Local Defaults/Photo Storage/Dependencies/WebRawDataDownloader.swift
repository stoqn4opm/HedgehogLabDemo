//
//  WebRawDataDownloader.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation

// MARK: - Web Raw Data Downloader

/// Simple HTTP GET downloader.
/// Pass it a session, and it will give you back the body of the response
/// as raw `Data`.
public struct WebRawDataDownloader: RawDataDownloader {
    
    public let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func download(url: URL, withCompletion completion: @escaping (Result<Data, Error>) -> ()) {
        session.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            } else {
                assertionFailure("neither data is available, nor error is given")
            }
        }.resume()
    }
}
