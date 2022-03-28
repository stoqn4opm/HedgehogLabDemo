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

final class LoadImgurPhotoService: TransformerStartupAction<String, Result<(search: PhotoService, favorite: PhotoService), Error>> {
    
    init() {
        super.init { appClientId in
            let oneGigabyte: Int64 = 1073741824
            guard let searchAccessor = CacheDirectoryRawDataAccessor(cacheSubdirectory: "Imgur-temp",
                                                                     fileManager: .default,
                                                                     maxAllowedDiskUsageInBytes: oneGigabyte),
                  
                    let favoriteAccessor = CacheDirectoryRawDataAccessor(cacheSubdirectory: "Favorites",
                                                                         fileManager: .default,
                                                                         maxAllowedDiskUsageInBytes: oneGigabyte)
            else {
                return .failure(NSError(domain: "[LoadImgurPhotoService] - no enough space on disk!", code: 1))
            }
            
            return .success((search: Self.searchPhotoService(appClientId: appClientId, accessor: searchAccessor),
                             favorite: Self.favoritePhotoService(accessor: favoriteAccessor)))
        }
    }
    
    @available(*, unavailable)
    override init(input: String? = nil, transform: @escaping (String) -> (Result<(search: PhotoService, favorite: PhotoService), Error>)) {
        super.init(input: input, transform: transform)
    }
}

extension LoadImgurPhotoService {
    
    private static func searchPhotoService(appClientId: String, accessor: RawDataHandler) -> PhotoService {
        let repository = ImgurPhotoRepository(appClientId: appClientId)
        let downloader = WebRawDataDownloader(session: Endpoint.sharedSession)
        let photoStorage = LossyCachePhotoStorage(downloader: downloader, accessor: accessor)
        return CachingPhotoService(photoRepository: repository, photoStorage: photoStorage)
    }
    
    private static func favoritePhotoService(accessor: RawDataHandler) -> PhotoService {
        let repository = FavoritesPhotoRepository(rawDataHandler: accessor,
                                                  originalSizeMainRecordKey: "originalSizeRecords.json",
                                                  thumbnailSizeMainRecordKey: "thumbnailSizeRecords.json",
                                                  pageSize: 10)
        
        return NonCachingPhotoService(photoRepository: repository, accessor: accessor)
    }
}
