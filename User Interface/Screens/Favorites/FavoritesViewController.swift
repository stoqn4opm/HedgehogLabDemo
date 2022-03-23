//
//  FavoritesViewController.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

// MARK: - Class Definition

final class FavoritesViewController: UIViewController {
    let viewModel: FavoritesViewModel
    
    init?(coder: NSCoder, viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
