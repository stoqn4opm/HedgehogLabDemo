//
//  ImgurGalleryRawPhoto.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import ImgurAPI
import ServiceLayer

// MARK: - Raw Photo Conformance

/// Might be worth merging with `ImgurImageRawPhoto` class,
/// as both are identical.
///
/// The only reason for them to be kept separate is that
/// they are representing different entities from the server
/// `GalleryImage` and `Image`
///
/// The properties we use in app are available from both models.
final class ImgurGalleryRawPhoto: RawPhoto {
    
    let galleryImage: GalleryImage
    let downloadURL: URL
    let width: Int
    let height: Int
    
    init?(galleryImage: GalleryImage, inSize size: Photo.Size) {
        self.galleryImage = galleryImage
        
        guard let width = galleryImage.width,
              let height = galleryImage.height else { return nil }
        
        self.width = width
        self.height = height
        
        guard let url = URL(string: galleryImage.link) else { return nil }
        let coordinator = ThumbnailsLinkCoordinator(originalLink: url)
        guard let link = coordinator.url(withSize: size.imgurSize) else { return nil }
        
        downloadURL = link
    }
    
    var id: String { galleryImage.id }
    var title: String { galleryImage.title }
    var description: String? { galleryImage.description }
    
    var tags: [String] { galleryImage.tags.map { $0.name } }
    var viewCount: Int { galleryImage.views }
}
