//
//  PhotoService+Error.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation


// MARK: - Photo Service Errors

extension PhotoService {
    
    /// All possible user facing errors that can occur when interacting with the public interface of `PhotoService`.
    public enum Error: Swift.Error {
     
        case photoRepositoryError(Swift.Error)
        case photoStorageError(Swift.Error)
        case photoStorageMultipleSavesFailed
    }
}
