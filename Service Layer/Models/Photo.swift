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
    
    public init(id: String, title: String, description: String?, viewCount: Int, tags: [String]) {
        self.id = id
        self.title = title
        self.description = description
        self.viewCount = viewCount
        self.tags = tags
    }
    
    public var dataAccessorKey: String { id }
}

extension Photo {
    public enum Size {
        case thumbnail
        case original
    }
}
