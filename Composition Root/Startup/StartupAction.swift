//
//  StartupAction.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation


// MARK: - Startup Action

protocol StartupAction {
    
    /// Tells the instance to perform its action.
    func execute()
}
