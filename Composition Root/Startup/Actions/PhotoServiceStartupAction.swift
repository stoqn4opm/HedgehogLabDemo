//
//  PhotoServiceStartupAction.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ServiceLayer

// MARK: - UIWindow Startup Action

struct PhotoServiceStartupAction: StartupAction {

    let appClientId: String
        
    init(appClientId: String = "ef8d4acb74c28c0") {
        self.appClientId = appClientId
    }
    
    func execute() {
        let repository = ImgurPhotoRepository(appClientId: appClientId)
        let photoService = PhotoService(photoRepository: repository)
    }
}
