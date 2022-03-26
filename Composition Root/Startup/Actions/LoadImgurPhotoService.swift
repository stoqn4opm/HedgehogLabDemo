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

final class LoadImgurPhotoService: TransformerStartupAction<String, PhotoService> {
    
    init() {
        super.init { appClientId in
            let repository = ImgurPhotoRepository(appClientId: appClientId)
            let downloader = WebRawDataDownloader(session: Endpoint.sharedSession)
            let accessor = FileSystemRawDataAccessor()
            let photoStorage = LossyCachePhotoStorage(downloader: downloader, accessor: accessor)
            let photoService = PhotoService(photoRepository: repository, photoStorage: photoStorage)
            return photoService
        }
    }
    
    @available(*, unavailable)
    override init(input: String? = nil, transform: @escaping (String) -> (PhotoService)) {
        super.init(input: input, transform: transform)
    }
}
