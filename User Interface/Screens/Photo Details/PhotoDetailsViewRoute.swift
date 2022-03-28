//
//  PhotoDetailsViewRoute.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import SwiftUI
import ServiceLayer

protocol PhotoDetailsViewRoute {
    func openPhoto(photo: Photo, photoService: PhotoService, completion: @escaping (Bool) -> ())
}

extension PhotoDetailsViewRoute where Self: Router {
    
    func openPhoto(photo: Photo, photoService: PhotoService, completion: @escaping (Bool) -> ()) {
        let transition = ModalTransition()
        let router = MainRouter(rootTransition: transition)
        
        let viewModel = PhotoDetailsViewModel(photo: photo, photoService: photoService, router: router)
        let view = PhotoDetailsView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        
        router.root = viewController
        route(to: viewController, with: transition)
        
        // for now, its like this, but download the original image and complete then
        completion(true)
    }
}

extension MainRouter: PhotoDetailsViewRoute {}
