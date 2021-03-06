//
//  MainStartupAction.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ServiceLayer
import UIKit

// MARK: - 3 Step Transformer Startup Action

/// Executes 3 consecutive transformers across the Generic types you set.
final class MainStartupAction: StartupAction {
    
    private let transformer: ThreeStepTransformerAction<String, Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>, UIWindow, Void>
    
    
    init(withImgurClientId clientId: String,
         step1: TransformerStartupAction<String, Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>>,
         step2: TransformerStartupAction<Result<(search: PhotoService, favorite: PhotoService & PhotoServiceModifiable), Error>, UIWindow>,
         step3: TransformerStartupAction<UIWindow, Void>) {
    
        transformer = .init(input: clientId, step1: step1, step2: step2, step3: step3)
    }

    func execute() {
        transformer.execute()
    }
}
