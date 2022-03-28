//
//  ShrinkableCollectionViewCell.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import UIKit

// MARK: - Shrinkable Collection View Cell

class ShrinkableCollectionViewCell: UICollectionViewCell, Scalable {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first?.location(in: self) else { return }
        guard touch.x > 0, touch.x < bounds.width else { return }
        guard touch.y > 0, touch.y < bounds.height else { return }
        setScaleDown(true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setScaleDown(false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setScaleDown(false)
    }
}

// MARK: - Shrinkables

protocol Scalable: AnyObject {
    func setScaleDown(_ scaleDown: Bool)
    var transform: CGAffineTransform { get set }
    var duration: TimeInterval { get }
    var minScaleFactor: CGFloat { get }
}

extension Scalable {
    var duration: TimeInterval { 0.7 }
    var minScaleFactor: CGFloat { 0.95 }

    func setScaleDown(_ scaleDown: Bool) {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.6) { [weak weakSelf = self] in
            guard let strongSelf = weakSelf else { return }
            strongSelf.transform = scaleDown ? CGAffineTransform.identity.scaledBy(x: strongSelf.minScaleFactor, y: strongSelf.minScaleFactor) : .identity
        }
        animator.startAnimation()
    }
}
