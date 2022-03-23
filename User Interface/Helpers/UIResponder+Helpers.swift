//
//  UIResponder+Helpers.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

// MARK: - Helpers

extension UIResponder {
    
    // Gives you back `String(describing: self)` for this instance.
    class var className: String { String(describing: self) }

    /// Gives you back `UINib` instance with the name of this class,
    /// in the bundle where this class is.
    ///
    /// More specifically:
    /// ```
    /// UINib(nibName: className, bundle: Bundle(for: Self.self))
    /// ```
    /// Where `className` is defined as `String(describing: self)`
    class var nib: UINib { UINib(nibName: className, bundle: Bundle(for: Self.self)) }
}
