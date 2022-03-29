//
//  PhotoTabRoutes.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit
import ServiceLayer


public protocol PhotoTabRoutes {
    func composedSearchTab(withPhotoService photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable) -> UIViewController
    func composedFavoriteTab(withPhotoService photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable) -> UIViewController
}

extension PhotoTabRoutes where Self: Router {
    
    public func composedSearchTab(withPhotoService photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable) -> UIViewController {
        composedTab(withPhotoService: photoService, favoritePhotoService: favoritePhotoService, tab: .search)
    }
    
    public func composedFavoriteTab(withPhotoService photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable) -> UIViewController {
        composedTab(withPhotoService: photoService, favoritePhotoService: favoritePhotoService, tab: .favorites)
    }
    
    private func composedTab(withPhotoService photoService: PhotoService, favoritePhotoService: PhotoServiceModifiable, tab: Tabs) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle(for: PhotoTabViewController.self))
            .instantiateViewController(identifier: PhotoTabViewController.className) { coder in
                
                // `EmptyTransition` since they are managed by the TabBarController
                let searchController = UISearchController(searchResultsController: nil)
                let router = MainRouter(rootTransition: EmptyTransition())
                let viewModel = PhotoTabViewModel(router: router, photoService: photoService, favoritePhotoService: favoritePhotoService, tab: tab)
                let result = PhotoTabViewController(coder: coder, viewModel: viewModel, searchController: searchController)
                router.root = result
                return result
            }

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem = tab.item
        return navigation
    }
}

extension MainRouter: PhotoTabRoutes {}
