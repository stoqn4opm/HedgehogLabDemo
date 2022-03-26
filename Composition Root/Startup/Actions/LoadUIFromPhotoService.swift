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

final class LoadUIFromPhotoService: TransformerStartupAction<PhotoService, UIWindow> {
    
    init(in windowScene: UIWindowScene) {
        super.init { photoService in
            let mainRouter = MainRouter(rootTransition: EmptyTransition())
            
            let tabs = [mainRouter.composedSearchTab(withPhotoService: photoService),
                        mainRouter.composedFavoritesTab]

            let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window.windowScene = windowScene
            window.rootViewController = MainTabBarController(viewControllers: tabs)
            window.makeKeyAndVisible()
            
            return window
        }
    }
    
    @available(*, unavailable)
    override init(input: PhotoService? = nil, transform: @escaping (PhotoService) -> (UIWindow)) {
        super.init(input: input, transform: transform)
    }
}
