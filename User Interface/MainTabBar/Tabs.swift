//
//  Tabs.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

// MARK: - Main App Tabs

enum Tabs {
    case search
    case favorites
}

// MARK: - Helpers

extension Tabs {
    
    var index: Int {
        switch self {
        case .search:
            return 0
        case .favorites:
            return 1
        }
    }

    var item: UITabBarItem {
        switch self {
        case .search:
            return UITabBarItem(title: "Search".localized, image: UIImage(systemName: "magnifyingglass.circle"), tag: index)
            
        case .favorites:
            return UITabBarItem(title: "Favorites".localized, image: UIImage(systemName: "star.circle"), tag: index)
        }
    }
}
