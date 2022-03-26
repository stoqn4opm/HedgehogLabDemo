//
//  GalleryImage.swift
//  ImgurAPI
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation

// MARK: - Imgur GalleryImage Model

/// The data model formatted for gallery images from Imgur's API.
///
/// More info: https://api.imgur.com/models/gallery_image
public struct GalleryImage: Codable {
    
    /// The ID for the image.
    public let id: String
    
    /// The title of the image.
    public let title: String
    
    /// Description of the image
    ///
    /// Not documented as optional, but saw it being `nil` a couple of times.
    public let description: String?
    
    /// The width of the image in pixels
    ///
    /// Not documented as optional, but saw it being `nil` a couple of times.
    public let width: Int?
    
    /// The height of the image in pixels
    ///
    /// Not documented as optional, but saw it being `nil` a couple of times.
    public let height: Int?
    
    /// The size of the image in bytes
    ///
    /// Not documented as optional, but saw it being `nil` a couple of times.
    public let size: Int?
    
    /// The number of image views
    public let views: Int
    
    /// The direct link to the the `ImageEndpoint` endpoint for this image.
    public let link: String
    
    /// Upvotes for the image
    public let ups: Int
    
    /// Number of downvotes for the image
    public let downs: Int
    
    /// Upvotes minus downvotes
    public let points: Int
    
    /// Imgur popularity score
    public let score: Int
    
    /// Number of comments on the gallery image.
    public let commentCount: Int
    
    /// Undocumented, noticing that its never `null`, but keep an eye
    public let tags: [Tag]

    /// If it's an advertisement or not
    public let isAd: Bool
    
    /// If it's an album or not
    public let isAlbum: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case width
        case height
        case size
        case description
        case views
        case link
        case ups
        case downs
        case points
        case score
        case commentCount = "comment_count"
        case tags
        case isAd = "is_ad"
        case isAlbum = "is_album"
    }
}
