//
//  FavoriteTabRoute.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

public protocol FavoriteTabRoute {
    var composedFavoritesTab: UIViewController { get }
}

extension FavoriteTabRoute where Self: Router {
    
    public var composedFavoritesTab: UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle(for: FavoritesViewController.self))
            .instantiateViewController(identifier: FavoritesViewController.className) { coder in
                
                // `EmptyTransition` since they are managed by the TabBarController
                let router = MainRouter(rootTransition: EmptyTransition())
                let viewModel = FavoritesViewModel(router: router)
                let result = FavoritesViewController(coder: coder, viewModel: viewModel)
                router.root = result
                return result
            }

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = Tabs.favorites.item
        return navigation
    }
}

extension MainRouter: FavoriteTabRoute {}

