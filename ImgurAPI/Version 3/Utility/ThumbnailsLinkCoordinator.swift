//
//  ThumbnailsLinkCoordinator.swift
//  ImgurAPI
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation


/// Gives you clean way of assembling a link to a image raw data,
/// in various sizes, predefined and hosted by Imgur.
///
/// Imgur Image thumbnails
///
/// There are 6 total thumbnails that an image can be resized to.
/// Each one is accessible by appending a single character suffix
/// to the end of the image id, and before the file extension.
///
/// The thumbnails are:
///
/// - s: Small Square (90x90) - Keeps Proportions: No
/// - b: Big Square (160x160) - Keeps Proportions: No
/// - t: Small Thumbnail (160x160) - Keeps Proportions: Yes
/// - m: Medium Thumbnail (320x320) - Keeps Proportions: Yes
/// - l: Large Thumbnail (640x640) - Keeps Proportions: Yes
/// - h: Huge Thumbnail (1024x1024) - Keeps Proportions: Yes
///
/// For example, the image located at https://i.imgur.com/12345.jpg
/// has the Medium Thumbnail located at https://i.imgur.com/12345m.jpg
///
/// Note: if fetching an animated GIF that was over 20MB in original size, a .gif thumbnail will be returned
public struct ThumbnailsLinkCoordinator {
    
    /// The place where the original photo is stored.
    public let originalLink: URL
    
    /// Gives you clean way of assembling a link to a image raw data,
    /// in various sizes, predefined and hosted by Imgur.
    ///
    /// - Parameter originalLink: The place where the original photo is stored.
    public init(originalLink: URL) {
        self.originalLink = originalLink
    }
    
    /// Generates a url Imgur thumbnail URL from original url.
    ///
    /// There are 6 total thumbnails that an image can be resized to.
    /// Each one is accessible by appending a single character suffix
    /// to the end of the image id, and before the file extension.
    ///
    /// The thumbnails are:
    ///
    /// - s: Small Square (90x90) - Keeps Proportions: No
    /// - b: Big Square (160x160) - Keeps Proportions: No
    /// - t: Small Thumbnail (160x160) - Keeps Proportions: Yes
    /// - m: Medium Thumbnail (320x320) - Keeps Proportions: Yes
    /// - l: Large Thumbnail (640x640) - Keeps Proportions: Yes
    /// - h: Huge Thumbnail (1024x1024) - Keeps Proportions: Yes

    public func url(withSize size: ThumbnailSize) -> URL? {
        let pathExtension = originalLink.pathExtension
        var absoluteString = originalLink.absoluteString
        
        // check if url ends in .<filetype>
        guard pathExtension.isEmpty == false else { return nil }
        
        absoluteString.removeLast(pathExtension.count) // remove path extension
        let dot = absoluteString.removeLast() // remove dot that separates path extension
        
        
        absoluteString.append(size.rawValue)
        absoluteString.append(dot)
        absoluteString.append(pathExtension)
        return URL(string: absoluteString)
    }
}

// MARK: - Thumbnail Sizes

extension ThumbnailsLinkCoordinator {
    
    /// Imgur Image thumbnail sizes
    ///
    /// There are 6 total thumbnails that an image can be resized to.
    /// Each one is accessible by appending a single character suffix
    /// to the end of the image id, and before the file extension.
    ///
    /// For example, the image located at https://i.imgur.com/12345.jpg
    /// has the Medium Thumbnail located at https://i.imgur.com/12345m.jpg
    public enum ThumbnailSize: String {
        
        /// Unmodified image size
        case original = ""
        
        /// Small Square (90x90) - Keeps Proportions: No
        case smallSquare = "s"
        
        /// Big Square (160x160) - Keeps Proportions: No
        case bigSquare = "b"
        
        /// Small Thumbnail (160x160) - Keeps Proportions: Yes
        case smallThumbnail = "t"
        
        /// Medium Thumbnail (320x320) - Keeps Proportions: Yes
        case mediumThumbnail = "m"
        
        /// Large Thumbnail (640x640) - Keeps Proportions: Yes
        case largeThumbnail = "l"
        
        /// Huge Thumbnail (1024x1024) - Keeps Proportions: Yes
        case hugeThumbnail = "h"
    }
}
