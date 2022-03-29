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

final class LoadImgurPhotoService: TransformerStartupAction<String, Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>> {
    
    init() {
        super.init { appClientId in
            let oneGigabyte: Int64 = 1073741824
            guard let searchAccessor = CacheDirectoryRawDataAccessor(cacheSubdirectory: "Imgur-temp",
                                                                     fileManager: .default,
                                                                     maxAllowedDiskUsageInBytes: oneGigabyte),
                  
                    let favoriteAccessor = DestructiveCacheDirectoryRawDataAccessor(cacheSubdirectory: "Favorites",
                                                                         fileManager: .default,
                                                                         maxAllowedDiskUsageInBytes: oneGigabyte)
            else {
                return .failure(NSError(domain: "[LoadImgurPhotoService] - no enough space on disk!", code: 1))
            }
            
            let searchPhotoService = Self.searchPhotoService(appClientId: appClientId, accessor: searchAccessor)
            let favoritesPhotoService = Self.favoritePhotoService(sourcePhotoService: searchPhotoService, accessor: favoriteAccessor)
            
            return .success((search: searchPhotoService, favorite: favoritesPhotoService))
        }
    }
    
    @available(*, unavailable)
    override init(input: String? = nil, transform: @escaping (String) -> (Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>)) {
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
    
    private static func favoritePhotoService(sourcePhotoService: PhotoService, accessor: RawDataHandler & RawDataDestructor) -> PhotoService & PhotoServiceModifiable {
        let repository = FavoritesPhotoRepository(rawDataHandler: accessor,
                                                  originalSizeMainRecordKey: "originalSizeRecords.json",
                                                  thumbnailSizeMainRecordKey: "thumbnailSizeRecords.json",
                                                  pageSize: 10)
        
        return FavoritesPhotoService(sourcePhotoService: sourcePhotoService, photoRepository: repository, accessor: accessor)
    }
}
