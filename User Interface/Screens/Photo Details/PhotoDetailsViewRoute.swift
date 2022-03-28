//
//  PhotoDetailsViewRoute.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import SwiftUI
import ServiceLayer
import CombineSchedulers

protocol PhotoDetailsViewRoute {
    func openPhoto(photo: Photo, photoService: PhotoServiceFacade, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ())
}

extension PhotoDetailsViewRoute where Self: Router {
    
    func openPhoto(photo: Photo, photoService: PhotoServiceFacade, scheduler: AnySchedulerOf<RunLoop>, completion: @escaping (Error?) -> ()) {
        
        photoService.fetchPhotoDetails(forId: photo.id, inSize: .original) { [weak self] result in
            scheduler.schedule {
                switch result {
                case .success(let originalPhoto):
                    let taggedPhoto = Photo(photo: originalPhoto, tags: photo.tags)
                    self?.openOriginalPhoto(photo: taggedPhoto, photoService: photoService, completion: completion)
                    
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    private func openOriginalPhoto(photo: Photo, photoService: PhotoServiceFacade, completion: @escaping (Error?) -> ()) {
        
        let transition = ModalTransition()
        let router = MainRouter(rootTransition: transition)
        
        let viewModel = PhotoDetailsViewModel(photo: photo, photoService: photoService, router: router)
        let view = PhotoDetailsView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        
        router.root = viewController
        route(to: viewController, with: transition) {
            completion(nil)
        }
    }
}

extension MainRouter: PhotoDetailsViewRoute {}
