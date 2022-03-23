//
//  SearchViewController.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

// MARK: - Class Definition

final class SearchViewController: UIViewController {
    let viewModel: SearchViewModel
    
    init?(coder: NSCoder, viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
