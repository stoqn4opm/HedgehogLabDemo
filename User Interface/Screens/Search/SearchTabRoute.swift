//
//  SearchTabRoute.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

public protocol SearchTabRoute {
    var composedSearchTab: UIViewController { get }
}

extension SearchTabRoute where Self: Router {
    
    public var composedSearchTab: UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle(for: SearchViewController.self))
            .instantiateViewController(identifier: SearchViewController.className) { coder in
                
                // `EmptyTransition` since they are managed by the TabBarController
                let router = MainRouter(rootTransition: EmptyTransition())
                let viewModel = SearchViewModel(router: router, repository: DummyPhotoRepository())
                let result = SearchViewController(coder: coder, viewModel: viewModel)
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
