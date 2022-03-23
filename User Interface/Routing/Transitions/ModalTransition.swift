//
//  ModalTransition.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit

// MARK: - Modal Transition

final class ModalTransition {
    var isAnimated = true
    
    var modalTransitionStyle: UIModalTransitionStyle
    var modalPresentationStyle: UIModalPresentationStyle

    init(isAnimated: Bool = true,
         modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
         modalPresentationStyle: UIModalPresentationStyle = .automatic) {
        self.isAnimated = isAnimated
        self.modalTransitionStyle = modalTransitionStyle
        self.modalPresentationStyle = modalPresentationStyle
    }
}

// MARK: - Transition Conformance

extension ModalTransition: Transition {
    // MARK: - Transition

    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        viewController.modalPresentationStyle = modalPresentationStyle
        viewController.modalTransitionStyle = modalTransitionStyle
        from.present(viewController, animated: isAnimated, completion: completion)
    }

    func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        viewController.dismiss(animated: isAnimated, completion: completion)
    }
}
