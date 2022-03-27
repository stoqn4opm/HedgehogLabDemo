//
//  ThreeStepTransformerAction.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation

// MARK: - 3 Step Transformer Startup Action

/// Executes 3 consecutive transformers across the Generic types you set.
class ThreeStepTransformerAction<Input, Stage1, Stage2, Output>: TransformerStartupAction<Input, Output> {
    
    init(input: Input,
         step1: TransformerStartupAction<Input, Stage1>,
         step2: TransformerStartupAction<Stage1, Stage2>,
         step3: TransformerStartupAction<Stage2, Output>) {
    
        super.init(input: input) { input in
            step3.transform(step2.transform(step1.transform(input)))
        }
    }
    
    @available(*, unavailable)
    override init(input: Input? = nil, transform: @escaping (Input) -> (Output)) {
        fatalError("not meant to be used")
    }
}
