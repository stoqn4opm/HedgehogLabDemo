//
//  EmptyTransition.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

final class EmptyTransition {
    var isAnimated = true
}

// MARK: - Transition Conformance

extension EmptyTransition: Transition {

    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {}
    func close(_ viewController: UIViewController, completion: (() -> Void)?) {}
}
