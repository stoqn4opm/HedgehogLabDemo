//
//  MainRouter.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

// MARK: - Main Router

class MainRouter: Router, Closable, Dismissable {
    private let rootTransition: Transition
    weak var root: UIViewController?
    
    init(rootTransition: Transition) {
        self.rootTransition = rootTransition
    }
    
    func route(to viewController: UIViewController, with transition: Transition, completion: (() -> Void)?) {
        guard let root = root else { return }
        transition.open(viewController, from: root, completion: completion)
    }
    
    func route(to viewController: UIViewController, with transition: Transition) {
        route(to: viewController, with: transition, completion: nil)
    }
    
    func close(completion: (() -> Void)?) {
        guard let root = root else { return }
        rootTransition.close(root, completion: completion)
    }
    
    func close() {
        close(completion: nil)
    }
    
    func dismiss(completion: (() -> Void)?) {
        // Dismiss the root with default dismiss animation.
        // It will only work if the root or its ancestor were presented
        // using the native present view controller method.
        root?.dismiss(animated: rootTransition.isAnimated, completion: completion)
    }
    
    func dismiss() {
        dismiss(completion: nil)
    }
}
