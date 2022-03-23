//
//  SearchTabRoute.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

protocol SearchTabRoute {
    var composedSearchTab: UIViewController { get }
}

extension SearchTabRoute where Self: Router {
    
    var composedSearchTab: UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle(for: SearchViewController.self))
            .instantiateViewController(identifier: SearchViewController.className) { coder in
                
                // `EmptyTransition` since they are managed by the TabBarController
                let router = MainRouter(rootTransition: EmptyTransition())
                let viewModel = SearchViewModel(router: router)
                let result = SearchViewController(coder: coder, viewModel: viewModel)
                router.root = result
                return result
            }

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = Tabs.search.item
        return navigation
    }
}

extension MainRouter: SearchTabRoute {}
