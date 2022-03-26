//
//  ImageEndpoint.swift
//  ImgurAPI
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import NetworkingKit


/// Fetch images from Imgur gallery.
///
/// Due to caching limitations of Imgur, it's not possible to change the result size of the gallery resources.
///
/// If you want to call the endpoint initialize this.
public final class ImageEndpoint: Endpoint.WithResponseTypeOnly<Basic<Image>> {
    
    public let imageId: String
    public let appClientId: String
    
    public override var host: String { "api.imgur.com" }
    
    public override var path: String { "/3/image/\(imageId)" }
    
    public override var headers: [HTTP.Header] {
        [.init(.authorization, value: "Client-ID \(appClientId)")]
    }
    
    @discardableResult public init(imageId: String, appClientId: String, completion: @escaping (Basic<Image>?, Endpoint.Error?) -> ()) {
        
        self.appClientId = appClientId
        self.imageId = imageId
        super.init(completion: completion)
    }
    
    @available(*, unavailable)
    override init(completion: @escaping (Basic<Image>?, Endpoint.Error?) -> ()) {
        fatalError("not implemented")
    }
}
