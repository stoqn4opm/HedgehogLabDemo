//
//  Tag.swift
//  ImgurAPI
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation

// MARK: - Imgur Tag Model

/// The base model for a tag from Imgur's API.
///
/// More info: https://api.imgur.com/models/tag
public struct Tag: Codable {
    
    /// Name of the tag.
    public let name: String
    
    /// ??? Undocumented, maybe successor to `name`.
    public let displayName: String
    
    /// Number of followers for the tag.
    public let followers: Int
    
    /// Total number of gallery items for the tag.
    public let totalItems: Int

    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "display_name"
        case followers
        case totalItems = "total_items"
    }
}
