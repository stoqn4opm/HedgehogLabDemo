//
//  Array+Helpers.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation


// MARK: - Array Helpers

extension Array {
    
    /// Spits this array into chunks of given size.
    /// Last chunk might be shorter if there are not
    /// exact count of elements to match.
    ///
    /// Example:
    /// ```
    /// let result = [1, 2, 3, 4, 5, 6, 7, 8].chunked(into: 3)
    /// print(result) // [[1, 2, 3], [4, 5, 6], [7, 8]]
    /// ```
    /// - Parameter size: Length of chunk
    /// - Returns: Array of chunks
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
