//
//  PreMainRunThemingStartupAction.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 30/03/22.
//

import Foundation
import UIKit

// MARK: - App UI Theme StartupAction

final class ThemingStartupAction: StartupAction {

    weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func execute() {
        window?.tintColor = .systemGreen
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemGreen]
    }
}
