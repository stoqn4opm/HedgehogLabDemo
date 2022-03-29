//
//  FavoritePhotoDetailsViewRoute.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import SwiftUI
import ServiceLayer
import CombineSchedulers

protocol FavoritePhotoDetailsViewRoute {
    func openFavoritePhoto(photo: Photo, photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ())
}

extension FavoritePhotoDetailsViewRoute where Self: Router {
    
    func openFavoritePhoto(photo: Photo, photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ()) {
        let transition = ModalTransition()
        let router = MainRouter(rootTransition: transition)
        
        let viewModel = PhotoDetailsViewModel(photo: photo,
                                              photoService: photoService,
                                              favoritePhotoService: favoritePhotoService,
                                              router: router,
                                              scheduler: scheduler)
        
        let view = PhotoDetailsView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        
        router.root = viewController
        route(to: viewController, with: transition) {
            completion(nil)
        }
    }
}

extension MainRouter: FavoritePhotoDetailsViewRoute {}

