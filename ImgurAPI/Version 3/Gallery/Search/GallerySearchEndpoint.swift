//
//  GallerySearchEndpoint.swift
//  ImgurAPI
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation
import NetworkingKit


/// Search the gallery with a given query string.
///
/// Due to caching limitations of Imgur, it's not possible to change the result size of the gallery resources.
///
/// If you want to call the endpoint initialize this.
public final class GallerySearchEndpoint: Endpoint.WithResponseTypeOnly<Basic<[GalleryImage]>> {
    
    public let sortedUsing: SortOption
    public let inTimeWindow: Window
    public let page: Int
    public let appClientId: String
    public let searchQuery: String
    
    public override var host: String { "api.imgur.com" }
    
    public override var path: String { "/3/gallery/search/\(sortedUsing.rawValue)/\(inTimeWindow.rawValue)/\(page)" }
    
    public override var headers: [HTTP.Header] {
        [.init(.authorization, value: "Client-ID \(appClientId)")]
    }
    
    public override var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "q", value: searchQuery)]
    }
    
    @discardableResult public init(searchQuery: String, sortedUsing: SortOption = .top, inTimeWindow: Window = .all, page: Int, appClientId: String, completion: @escaping (Basic<[GalleryImage]>?, Endpoint.Error?) -> ()) {
        self.sortedUsing = sortedUsing
        self.inTimeWindow = inTimeWindow
        self.page = page
        self.appClientId = appClientId
        self.searchQuery = searchQuery
        super.init(completion: completion)
    }
    
    @available(*, unavailable)
    override init(completion: @escaping (Basic<[GalleryImage]>?, Endpoint.Error?) -> ()) {
        fatalError("not implemented")
    }
}
