//
//  LoadUIFromPhotoService.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import UIKit
import HedgehogLabDemoUI
import ServiceLayer

// MARK: - UIWindow Startup Action

final class LoadUIFromPhotoService: TransformerStartupAction<Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>, UIWindow> {
    
    init(in windowScene: UIWindowScene) {
        super.init { result in
            
            var tabs: [UIViewController] = []
            
            if case let .success(photoService) = result {
                let mainRouter = MainRouter(rootTransition: EmptyTransition())
                
                tabs = [mainRouter.composedSearchTab(withPhotoService: photoService.search, favoritePhotoService: photoService.favorite),
                        mainRouter.composedFavoriteTab(withPhotoService: photoService.favorite, favoritePhotoService: photoService.favorite)]
                
            } else {
                // for now, just blank screen,
                // could be handled separately!
            }
            
            let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window.windowScene = windowScene
            window.rootViewController = MainTabBarController(viewControllers: tabs)
            window.makeKeyAndVisible()
            
            return window
        }
    }
    
    @available(*, unavailable)
    override init(input: Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>? = nil,
                  transform: @escaping (Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>) -> (UIWindow)) {
        
        super.init(input: input, transform: transform)
    }
}
