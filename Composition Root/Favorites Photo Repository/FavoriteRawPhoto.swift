//
//  FavoriteRawPhoto.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import ServiceLayer

class FavoriteRawPhoto: RawPhoto {
    var id: String
    var title: String?
    var description: String?
    var downloadURL: URL
    var tags: [String]
    var viewCount: Int

    init(id: String, title: String?, description: String? = nil, downloadURL: URL, tags: [String], viewCount: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.downloadURL = downloadURL
        self.tags = tags
        self.viewCount = viewCount
    }
}
