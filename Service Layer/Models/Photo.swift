//
//  Photo.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation


public struct Photo: Hashable {
        
    /// The key under which the raw `Data` of this Photo is saved.
    public let dataAccessorKey: String
    public let tags: [String]
    private let rawPhoto: RawPhoto
    
    public init(rawPhoto: RawPhoto, dataAccessorKey: String) {
        self.rawPhoto = rawPhoto
        self.tags = rawPhoto.tags
        self.dataAccessorKey = dataAccessorKey
    }
    
    public init(photo: Photo, tags: [String]) {
        self.rawPhoto = photo.rawPhoto
        self.tags = tags
        self.dataAccessorKey = photo.dataAccessorKey
    }
    
    public static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.rawPhoto.id == rhs.rawPhoto.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawPhoto.id)
    }
    
    public var id: String { rawPhoto.id }
    public var title: String { rawPhoto.title }
    public var description: String? { rawPhoto.description }
    public var viewCount: Int { rawPhoto.viewCount }
}

extension Photo {
    public enum Size {
        case thumbnail
        case original
    }
}
