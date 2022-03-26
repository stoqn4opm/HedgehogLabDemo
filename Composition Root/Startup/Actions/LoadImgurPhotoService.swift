//
//  LoadImgurPhotoService.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ServiceLayer

// MARK: - UIWindow Startup Action

final class LoadImgurPhotoService: TransformerStartupAction<String, PhotoService> {
    
    init() {
        super.init { appClientId in
            let repository = ImgurPhotoRepository(appClientId: appClientId)
            let photoService = PhotoService(photoRepository: repository)
            return photoService
        }
    }
    
    @available(*, unavailable)
    override init(input: String? = nil, transform: @escaping (String) -> (PhotoService)) {
        super.init(input: input, transform: transform)
    }
}
