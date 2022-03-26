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
    
    init(id: String = "", title: String = "", description: String? = "", downloadURL: URL = URL(fileURLWithPath: "")) {
        self.id = id
        self.title = title
        self.description = description
        self.downloadURL = downloadURL
    }
}
