//
//  Basic.swift
//  ImgurAPI
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation

// MARK: - Imgur Basic Model

/// The "Basic" data model from Imgur's API
///
/// More info here: https://api.imgur.com/models/basic
public struct Basic<Data: Codable>: Codable {
    
    /// Is null, boolean, object or integer value.
    /// If it's a post then this will contain an object with the all generated values, such as an ID.
    ///
    /// Format: mixed.
    public let data: Data?
    
    /// Was the request successful
    ///
    /// Format: Boolean
    public let success: Bool
    
    /// HTTP Status Code
    ///
    /// Format: integer
    public let status: Int
}
