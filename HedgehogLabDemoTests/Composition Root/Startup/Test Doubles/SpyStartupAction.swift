//
//  SpyStartupAction.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
@testable import HedgehogLabDemo

// MARK: - Spy Startup Action

class SpyStartupAction: StartupAction {
    
    var hasExecuted = false
    
    func execute() {
        hasExecuted = true
    }
}
