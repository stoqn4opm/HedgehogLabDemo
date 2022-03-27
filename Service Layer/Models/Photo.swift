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
    let rawPhoto: RawPhoto
    
    public init(rawPhoto: RawPhoto, dataAccessorKey: String) {
        self.rawPhoto = rawPhoto
        self.dataAccessorKey = dataAccessorKey
    }
    
    public static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.rawPhoto.id == rhs.rawPhoto.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawPhoto.id)
    }
    
    public var title: String { rawPhoto.title }
}

extension Photo {
    public enum Size {
        case thumbnail
        case original
    }
}
