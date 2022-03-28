//
//  PhotoServiceError.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation


// MARK: - Photo Service Errors

/// All possible user facing errors that can occur when interacting with the public interface of `PhotoService`.
public enum PhotoServiceError: Swift.Error {
    
    case photoRepositoryError(Error)
    case photoStorageError(Error)
    case photoStorageMultipleSavesFailed
    case graphicRepresentationError
}
