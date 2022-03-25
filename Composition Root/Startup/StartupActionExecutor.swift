//
//  StartupActionExecutor.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation


// MARK: - App Starter Interface

/// A simple abstraction, that executes synchronous tasks consecutively.
protocol StartupActionExecutor: AnyObject {
    
    /// Reference to all actions, that will get executed on `execute()`.
    var actions: [StartupAction] { get }
    
    /// Starts executing the appended actions.
    /// After execution finishes, all actions are removed.
    @discardableResult func execute() -> Self
    
    /// Appends a single action.
    @discardableResult func append(_ action: StartupAction) -> Self
    
    /// Appends a collection of actions.
    @discardableResult func append(_ actions: [StartupAction]) -> Self
}

// MARK: - App Starter

final class AppStarter: StartupActionExecutor {
    
    private(set) var actions: [StartupAction] = []
    
    @discardableResult func execute() -> Self {
        actions.forEach { $0.execute() }
        actions.removeAll()
        return self
    }
    
    @discardableResult func append(_ action: StartupAction) -> Self {
        actions.append(action)
        return self
    }
    
    @discardableResult func append(_ actions: [StartupAction]) -> Self {
        self.actions.append(contentsOf: actions)
        return self
    }
}
