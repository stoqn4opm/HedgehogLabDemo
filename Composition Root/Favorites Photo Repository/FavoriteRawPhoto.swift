//
//  FavoriteRawPhoto.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import ServiceLayer

public class FavoriteRawPhoto: RawPhoto {
    public var id: String
    public var title: String
    public var description: String?
    public var downloadURL: URL
    public var tags: [String]
    public var viewCount: Int
}
