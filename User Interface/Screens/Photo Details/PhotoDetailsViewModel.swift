//
//  PhotoDetailsViewModel.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 27/03/22.
//

import Foundation
import Combine
import UIKit
import ServiceLayer
import CombineSchedulers


// MARK: - PhotoDetailsViewModel

final class PhotoDetailsViewModel: ObservableObject {
    typealias Routes = Closable
    
    @Published var title: String
    @Published var description: String?
    @Published var tags: [String]
    @Published var viewCount: Int
    @Published var image: UIImage?
    @Published var isFavorite: Bool
    
    let photo: Photo!
    let photoService: PhotoService!
    let router: Routes!
    let scheduler: AnySchedulerOf<RunLoop>
    
    private var cancellables: Set<AnyCancellable> = []
    
    /// Used ONLY for SwiftUI previews, always pass photo and photo service and router to the model.
    ///
    /// Consider introducing a seam between PhotoDetailsView and its view model, so that this can go away.
    init(title: String, description: String, tags: [String], viewCount: Int, image: UIImage, isFavorite: Bool) {
        self.title = title
        self.description = description
        self.tags = tags
        self.viewCount = viewCount
        self.image = image
        self.isFavorite = isFavorite
        photo = nil
        photoService = nil
        router = nil
        scheduler = .main
        setupSubscriptions()
    }
    
    init(photo: Photo, photoService: PhotoService, router: Routes, scheduler: AnySchedulerOf<RunLoop>) {
        title = photo.title
        description = photo.description
        tags = photo.tags
        viewCount = photo.viewCount
        isFavorite = false
        
        self.photo = photo
        self.photoService = photoService
        self.router = router
        self.scheduler = scheduler
        
        setupSubscriptions()
    }
}

// MARK: - Combine Subscriptions

extension PhotoDetailsViewModel {
    
    func setupSubscriptions() {
        $isFavorite
            .removeDuplicates()
            .receive(on: scheduler)
            .sink { isFavorite in
                print("is favorite: \(isFavorite)")
            }
            .store(in: &cancellables)
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
