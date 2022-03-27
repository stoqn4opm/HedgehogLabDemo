//
//  EmptyTransition.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

public final class EmptyTransition {
    public var isAnimated = true
    
    public init() {}
}

// MARK: - Transition Conformance

extension EmptyTransition: Transition {

    public func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {}
    public func close(_ viewController: UIViewController, completion: (() -> Void)?) {}
}
