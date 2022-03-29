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
    @Published private(set) var errorMessage: String
    @Published var presentErrorAlert: Bool
    
    let photo: Photo!
    let photoService: PhotoService!
    let favoritePhotoService: PhotoServiceModifiable!
    let router: Routes!
    let scheduler: AnySchedulerOf<RunLoop>
    
    
    private var favoriteToggleOnInitialValue = false
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
        
        // default state
        self.errorMessage = ""
        self.presentErrorAlert = false
        
        // force unwrapped
        self.photo = nil
        self.photoService = nil
        self.favoritePhotoService = nil
        self.router = nil
        self.scheduler = .main
        
        checkFavoriteStatus()
    }
    
    init(photo: Photo, photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable, router: Routes, scheduler: AnySchedulerOf<RunLoop>) {
        self.title = photo.title
        self.description = photo.description
        self.tags = photo.tags
        self.viewCount = photo.viewCount
        self.image = nil
        self.isFavorite = false
        
        // default state
        self.errorMessage = ""
        self.presentErrorAlert = false
        
        // dependencies
        self.photo = photo
        self.photoService = photoService
        self.favoritePhotoService = favoritePhotoService
        self.router = router
        self.scheduler = scheduler
        
        checkFavoriteStatus()
    }
}

// MARK: - Combine Subscriptions

extension PhotoDetailsViewModel {
    
    private func checkFavoriteStatus() {
        favoritePhotoService.contains(photo, withSize: .original) { [weak self] result in
            switch result {
            case .success(let hasBeenFoundInFavoriteService):
                self?.isFavorite = hasBeenFoundInFavoriteService
                self?.favoriteToggleOnInitialValue = true
                self?.startMonitoringForFavoriteToggling()
                
            case .failure(let error):
                print("[PhotoDetailsViewModel] Failed checking if image is favorite with error: \(error)")
                self?.presentError("There was an error loading the image. Some details might not be correct!. Please try to open it later.".localized)
            }
        }
    }
    
    private func startMonitoringForFavoriteToggling() {
        $isFavorite
            .removeDuplicates()
            .receive(on: scheduler)
            .sink { [weak self] isFavorite in
                
                if self?.favoriteToggleOnInitialValue == true {
                    // skip initial setting
                    self?.favoriteToggleOnInitialValue = false
                } else {
                    self?.updateIsFavoriteState(to: isFavorite)
                    print("is favorite: \(isFavorite)")
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Commands

extension PhotoDetailsViewModel {
    
    func generateGraphicRepresentation() {
        generateGraphicRepresentation { [weak self] success in
            guard success == false else { return }
            self?.presentError("Image loading failed".localized)
        }
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        presentErrorAlert = true
    }
    
    func hideErrorAlert() {
        errorMessage = ""
        presentErrorAlert = false
    }
    
    func dismiss() {
        router.close()
    }
}

// MARK: - Helpers

extension PhotoDetailsViewModel {
    
    private func generateGraphicRepresentation(withCompletion completion: @escaping (Bool) -> ()) {
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
    
    private func updateIsFavoriteState(to isFavorite: Bool) {
        let completion: (PhotoServiceError?) -> () = { [weak self] error in
            guard let error = error else { return }
            print("[PhotoDetailsViewModel] Failed updating is favorite status with error: \(error)")
            self?.presentError("Updating is favorite status failed. Please try again later".localized)
        }
        
        if isFavorite {
            favoritePhotoService.store(photo, withSize: .original, completion: completion)
            favoritePhotoService.store(photo, withSize: .thumbnail, completion: completion)
        } else {
            favoritePhotoService.delete(photo, withSize: .original, completion: completion)
            favoritePhotoService.delete(photo, withSize: .thumbnail, completion: completion)
        }
    }
}
