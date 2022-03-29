//
//  ImgurImageRawPhoto.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import ImgurAPI
import ServiceLayer

// MARK: - Raw Photo Conformance

/// Might be worth merging with `ImgurGalleryRawPhoto` class,
/// as both are identical.
///
/// The only reason for them to be kept separate is that
/// they are representing different entities from the server
/// `GalleryImage` and `Image`
///
/// The properties we use in app are available from both models.
final class ImgurImageRawPhoto: RawPhoto {
    
    let image: Image
    let downloadURL: URL
    let width: Int
    let height: Int
    
    init?(image: Image, inSize size: Photo.Size) {
        self.image = image
        
        guard let width = image.width,
              let height = image.height else { return nil }
        
        self.width = width
        self.height = height
        
        guard let url = URL(string: image.link) else { return nil }
        let coordinator = ThumbnailsLinkCoordinator(originalLink: url)
        guard let link = coordinator.url(withSize: size.imgurSize) else { return nil }
        
        downloadURL = link
    }
    
    var id: String { image.id }
    var title: String? { image.title }
    var description: String? { image.description }
    
    var tags: [String] { image.tags.map { $0.name } }
    var viewCount: Int { image.views }
}
