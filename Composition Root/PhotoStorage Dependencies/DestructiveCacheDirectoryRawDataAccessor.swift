//
//  DestructiveCacheDirectoryRawDataAccessor.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 29/03/22.
//

import Foundation
import ServiceLayer

// MARK: - Cache Directory RawDataHandler


final class DestructiveCacheDirectoryRawDataAccessor: CacheDirectoryRawDataAccessor, RawDataDestructor {
    
    func delete(forKey key: String, withCompletion completion: @escaping (Swift.Error?) -> ()) {
        let path = managedURL.appendingPathComponent(key).absoluteString
        do {
            try fileManager.removeItem(atPath: path)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
