//
//  Photo.swift
//  ServiceLayer
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation


public struct Photo: Hashable {
    
    public var id: String
    public var title: String
    public var description: String?
    public var viewCount: Int
    public let tags: [String]
    public let url: URL
    
    public init(id: String, title: String, description: String?, viewCount: Int, tags: [String], url: URL) {
        self.id = id
        self.title = title
        self.description = description
        self.viewCount = viewCount
        self.tags = tags
        self.url = url
    }
}

extension Photo {
    public enum Size {
        case thumbnail
        case original
    }
}
