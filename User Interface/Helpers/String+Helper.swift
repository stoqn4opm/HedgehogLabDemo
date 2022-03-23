//
//  String+Helper.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation

// MARK: - Localization

extension String {
    
    /// Returns a localized version of this string.
    ///
    /// It performs its job by calling `NSLocalizedString` like this:
    /// ```
    /// NSLocalizedString(self, comment: "")
    /// ```
    public var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
