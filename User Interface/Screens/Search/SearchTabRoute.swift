//
//  SearchTabRoute.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit
import ServiceLayer


public protocol SearchTabRoute {
    func composedSearchTab(withPhotoService photoService: PhotoService) -> UIViewController
    func composedFavoriteTab(withPhotoService photoService: PhotoService) -> UIViewController
}

extension SearchTabRoute where Self: Router {
    
    public func composedSearchTab(withPhotoService photoService: PhotoService) -> UIViewController {
        composedTab(withPhotoService: photoService, tab: .search)
    }
    
    public func composedFavoriteTab(withPhotoService photoService: PhotoService) -> UIViewController {
        composedTab(withPhotoService: photoService, tab: .favorites)
    }
    
    private func composedTab(withPhotoService photoService: PhotoService, tab: Tabs) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle(for: SearchViewController.self))
            .instantiateViewController(identifier: SearchViewController.className) { coder in
                
                // `EmptyTransition` since they are managed by the TabBarController
                let searchController = UISearchController(searchResultsController: nil)
                let router = MainRouter(rootTransition: EmptyTransition())
                let viewModel = SearchViewModel(router: router, photoService: photoService, tab: tab)
                let result = SearchViewController(coder: coder, viewModel: viewModel, searchController: searchController)
                router.root = result
                return result
            }

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem = tab.item
        return navigation
    }
}

extension MainRouter: SearchTabRoute {}
