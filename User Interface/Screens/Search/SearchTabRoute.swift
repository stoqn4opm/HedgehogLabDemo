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
    func composedSearchTab(withPhotoService photoService: PhotoServiceFacade) -> UIViewController
}

extension SearchTabRoute where Self: Router {
    
    public func composedSearchTab(withPhotoService photoService: PhotoServiceFacade) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle(for: SearchViewController.self))
            .instantiateViewController(identifier: SearchViewController.className) { coder in
                
                // `EmptyTransition` since they are managed by the TabBarController
                let searchController = UISearchController(searchResultsController: nil)
                let router = MainRouter(rootTransition: EmptyTransition())
                let viewModel = SearchViewModel(router: router, photoService: photoService, state: .mostPopular)
                let result = SearchViewController(coder: coder, viewModel: viewModel, searchController: searchController)
                router.root = result
                return result
            }

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem = Tabs.search.item
        return navigation
    }
}

extension MainRouter: SearchTabRoute {}
