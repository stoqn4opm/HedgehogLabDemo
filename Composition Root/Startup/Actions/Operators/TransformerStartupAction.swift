//
//  TransformerStartupAction.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation

// MARK: - Transformer Startup Action

/// Startup action, that takes a value `input`
/// and transforms and stores it in property `output`,
/// with a transformation of your choice.
class TransformerStartupAction<Input, Output>: StartupAction {
    
    /// The value that is to be transformed to the type `Output`.
    ///
    /// If you execute a few consecutive transforms in a multistep `StartupAction`
    /// and this is not the first transform, the value of this property will be set
    /// by the output of the previous transform,
    /// thus could be set as `nil` in the constructor.
    fileprivate(set) var input: Input?
    
    /// The output value after the transformer did its job.
    /// Nil before the Action was executed.
    private(set) var output: Output?
    
    /// Closure containing the transformation algorithm.
    let transform: (Input) -> (Output)
    
    /// Startup action, that takes a value `input`
    /// and transforms and stores it in property `output`,
    /// with a transformation of your choice.
    ///
    /// - Parameters:
    ///   - input: The value that is to be transformed to the type `Output`.
    ///   If you execute a few consecutive transforms in a multistep `StartupAction`
    ///   This parameter is only relevant in the first of them. The following transforms
    ///   get their input from the output of the previous.
    ///   - transform: Closure describing how the values will be transformed.
    init(input: Input? = nil, transform: @escaping (Input) -> (Output)) {
        self.input = input
        self.transform = transform
    }
    
    func execute() {
        guard let input = input else { return }
        output = transform(input)
    }
}
