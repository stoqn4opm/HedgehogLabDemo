//
//  LoadImgurPhotoService.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ServiceLayer
import NetworkingKit

// MARK: - UIWindow Startup Action

final class LoadImgurPhotoService: TransformerStartupAction<String, Result<PhotoServiceFacade, Error>> {
    
    init() {
        super.init { appClientId in
            let repository = ImgurPhotoRepository(appClientId: appClientId)
            let downloader = WebRawDataDownloader(session: Endpoint.sharedSession)
            let oneGigabyte: Int64 = 1073741824
            
            guard let accessor = CacheDirectoryRawDataAccessor(cacheSubdirectory: "Imgur-temp",
                                                               fileManager: .default,
                                                               maxAllowedDiskUsageInBytes: oneGigabyte)
            else {
                return .failure(NSError(domain: "[LoadImgurPhotoService] - no enough space on disk!", code: 1))
            }
            
            let photoStorage = LossyCachePhotoStorage(downloader: downloader, accessor: accessor)
            let photoService = CachingPhotoService(photoRepository: repository, photoStorage: photoStorage)
            return .success(photoService)
        }
    }
    
    @available(*, unavailable)
    override init(input: String? = nil, transform: @escaping (String) -> (Result<PhotoServiceFacade, Error>)) {
        super.init(input: input, transform: transform)
    }
}
