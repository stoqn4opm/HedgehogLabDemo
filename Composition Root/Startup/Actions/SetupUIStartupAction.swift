//
//  SetupUIStartupAction.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation
import UIKit
import HedgehogLabDemoUI

// MARK: - UIWindow Startup Action

struct SetupUIStartupAction: StartupAction {

    let windowScene: UIWindowScene
    let completion: (UIWindow) -> ()
    
    init(windowScene: UIWindowScene, completion: @escaping (UIWindow) -> ()) {
        self.windowScene = windowScene
        self.completion = completion
    }
    
    func execute() {
        let mainRouter = MainRouter(rootTransition: EmptyTransition())
        
        let tabs = [mainRouter.composedSearchTab,
                    mainRouter.composedFavoritesTab]

        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = MainTabBarController(viewControllers: tabs)
        window.makeKeyAndVisible()
        
        completion(window)
    }
}
