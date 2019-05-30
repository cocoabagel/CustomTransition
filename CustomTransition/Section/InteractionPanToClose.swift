//
//  InteractionPanToClose.swift
//  CustomTransition
//
//  Created by Kazutoshi Baba on 2019/05/30.
//  Copyright © 2019 Seesaa Inc. All rights reserved.
//

import UIKit

class InteractionPanToClose: UIPercentDrivenInteractiveTransition {
    @IBOutlet weak var viewController: UIViewController!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dialogView: UIView!
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!

    func setGestureRecognizer() {
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle))
        scrollView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateDialogDisappearAndDismiss))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
    }
    
    @objc func handle(_ gesture: UIPanGestureRecognizer) {
        
        guard scrollView.contentOffset.y < 1 else { return }
        
        let threshold : CGFloat = 100
        let translation = gesture.translation(in: viewController.view)
        
        switch gesture.state {
        case .changed:
            // The animation will update
            if translation.y > 0 {
                let percentComplete = translation.y / 2000
                update(percentComplete)
            }
        case .ended:
            // The animation will finish or cancel
            if translation.y > threshold {
                finish()
            } else {
                cancel()
            }
        default: break
        }
    }
    
    @objc func animateDialogDisappearAndDismiss(_ sender: UITapGestureRecognizer) {
        self.viewController.dismiss(animated: true)
    }
    
    override func update(_ percentComplete: CGFloat) {
        let translation = panGestureRecognizer.translation(in: viewController.view)
        
        let translationY = CGAffineTransform(translationX: 0, y: translation.y)
        let scale = CGAffineTransform(scaleX: 1-percentComplete, y: 1-percentComplete)

        let transform = translationY.concatenating(scale)
        
        dialogView.transform = transform
    }
    
    override func cancel() {
        
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6) {
            self.dialogView.transform = .identity
        }
        animator.startAnimation()
    }
    
    override func finish() {
        
        let animator = UIViewPropertyAnimator(duration: 0.9, dampingRatio: 0.9) {
            self.dialogView.frame.origin.y += 200
            self.viewController.dismiss(animated: true)
        }
        animator.startAnimation()
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension InteractionPanToClose: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tapGestureRecognizer && touch.view!.isDescendant(of: dialogView) {
            return false
        }
        return true
    }
}
