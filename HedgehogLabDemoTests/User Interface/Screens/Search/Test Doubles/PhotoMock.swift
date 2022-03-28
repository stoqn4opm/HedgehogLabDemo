//
//  PhotoMock.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
@testable import ServiceLayer

struct PhotoMock: RawPhoto {
    
    var id: String
    var title: String
    var description: String?
    var downloadURL: URL
    var viewCount: Int
    var tags: [String]
    
    
    init(id: String = "", title: String = "", description: String? = "", downloadURL: URL = URL(fileURLWithPath: ""), viewCount: Int = 0, tags: [String] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.downloadURL = downloadURL
        self.viewCount = viewCount
        self.tags = tags
    }
}
