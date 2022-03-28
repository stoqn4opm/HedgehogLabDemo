//
//  CacheDirectoryRawDataAccessor.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ServiceLayer
import FolderMonitorKit

// MARK: - Errors

extension CacheDirectoryRawDataAccessor {
     
    enum Error: Swift.Error {
        case dataNotFound
        case storingFailed
        case noEnoughSpaceOnDisk
    }
}

// MARK: - Cache Directory RawDataHandler

/// RawDataHandler that uses the directory within the caches directory
/// inside the user domain mask. The implementation tracks the disk space usage
/// and after it reaches the limit it starts erroring out.
///
/// Might be best if i make it smarter so that it deletes the oldest saved data.
///
/// Currently, it just adds new entries, it never deletes old ones, so if you use the app
/// long enough it will start erroring out, as all the available space within the limit
/// will be used.
final class CacheDirectoryRawDataAccessor: RawDataHandler {
    
    /// The subdirectory of the `NSCachesDirectory` directory that is used a a file system cache.
    let workingDirectory: URL
    let fileManager: FileManager
    let maxAllowedDiskUsageInBytes: Int64
    var currentlyUsedDiskSpaceInBytes: Int64 = 0
    
    init?(cacheSubdirectory name: String, fileManager: FileManager, maxAllowedDiskUsageInBytes: Int64) {
        self.fileManager = fileManager
        self.maxAllowedDiskUsageInBytes = maxAllowedDiskUsageInBytes
        
        guard fileManager.freeDiskSpaceInBytes > maxAllowedDiskUsageInBytes else { return nil }
        
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        guard var url = URL(string: path) else { return nil }
        url.appendPathComponent(name)
        
        do {
            try fileManager.createDirectory(atPath: url.absoluteString, withIntermediateDirectories: true, attributes: nil)
            workingDirectory = url
        } catch {
            return nil
        }
    }
    
    func store(data: Data, forKey key: String, withCompletion completion: @escaping (Swift.Error?) -> ()) {
        let usedBytes = currentlyUsedDiskSpaceInBytes + Int64(data.count)
        
        guard usedBytes < maxAllowedDiskUsageInBytes && usedBytes < fileManager.freeDiskSpaceInBytes else {
            completion(Error.noEnoughSpaceOnDisk)
            return
        }
        
        currentlyUsedDiskSpaceInBytes += Int64(data.count)
        
        let path = workingDirectory.appendingPathComponent(key).absoluteString
        let success = fileManager.createFile(atPath: path, contents: data, attributes: nil)
        
        if success {
            completion(nil)
        } else {
            completion(Error.storingFailed)
        }
    }
    
    func read(forKey key: String, withCompletion completion: @escaping (Result<Data, Swift.Error>) -> ()) {
        let path = workingDirectory.appendingPathComponent(key).absoluteString
        let data = fileManager.contents(atPath: path)
        
        if let data = data {
            completion(.success(data))
        } else {
            completion(.failure(Error.dataNotFound))
        }
    }
}
