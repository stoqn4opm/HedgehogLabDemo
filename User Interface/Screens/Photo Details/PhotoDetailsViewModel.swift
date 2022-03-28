//
//  PhotoDetailsViewModel.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 27/03/22.
//

import Foundation
import UIKit
import ServiceLayer


// MARK: - PhotoDetailsViewModel

final class PhotoDetailsViewModel: ObservableObject {
    typealias Routes = Closable
    
    @Published var title: String
    @Published var description: String?
    @Published var tags: [String]
    @Published var viewCount: Int
    @Published var image: UIImage?
    
    
    let photo: Photo!
    let photoService: PhotoServiceFacade!
    let router: Routes!
    
    /// Used ONLY for SwiftUI previews, always pass photo and photo service and router to the model.
    ///
    /// Consider introducing a seam between PhotoDetailsView and its view model, so that this can go away.
    init(title: String, description: String, tags: [String], viewCount: Int, image: UIImage) {
        self.title = title
        self.description = description
        self.tags = tags
        self.viewCount = viewCount
        self.image = image
        photo = nil
        photoService = nil
        router = nil
    }
    
    init(photo: Photo, photoService: PhotoServiceFacade, router: Routes) {
        title = photo.title
        description = photo.description
        tags = photo.tags
        viewCount = photo.viewCount
        self.photo = photo
        self.photoService = photoService
        self.router = router
    }
}

// MARK: - Commands

extension PhotoDetailsViewModel {
    func generateGraphicRepresentation(withCompletion completion: @escaping (Bool) -> ()) {
        guard let photoService = photoService else { completion(false); return }
        photoService.rawImageData(forPhoto: photo) { [weak self] result in
            switch result {
            case .success(let data):
                self?.image = UIImage(data: data)
                completion(true)
                
            case .failure(let error):
                print("[PhotoDetailsViewModel] Failed loading graphic representation of image with error: \(error)")
                completion(false)
            }
        }
    }
    
    func dismiss() {
        router.close()
    }
}
