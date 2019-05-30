//
//  PresentSectionViewController.swift
//  CustomTransition
//
//  Created by Kazutoshi Baba on 2019/05/30.
//  Copyright © 2019 Seesaa Inc. All rights reserved.
//

import UIKit

class PresentSectionViewController: NSObject, UIViewControllerAnimatedTransitioning {

    var cellFrame: CGRect!

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let destination = transitionContext.viewController(forKey: .to) as! SectionViewController
        let containerView = transitionContext.containerView
        containerView.addSubview(destination.view)

        // Initial state
        let widthConstraint = destination.scrollView.widthAnchor.constraint(equalToConstant: 304)
        let heightConstraint = destination.scrollView.heightAnchor.constraint(equalToConstant: 248)
        let bottomConstraint = destination.scrollView.bottomAnchor.constraint(equalTo: destination.coverView.bottomAnchor)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, bottomConstraint])

        let translate = CATransform3DMakeTranslation(cellFrame.origin.x, cellFrame.origin.y, 0.0)
        destination.view.layer.transform = translate
        containerView.layoutIfNeeded()
        
        destination.scrollView.layer.cornerRadius = 14
        destination.scrollView.layer.shadowOpacity = 0.25
        destination.scrollView.layer.shadowOffset.height = 10
        destination.scrollView.layer.shadowRadius = 20
        
        let moveUpTransform = CGAffineTransform(translationX: 0, y: -100)
        let scaleUpTranform = CGAffineTransform(scaleX: 2, y: 2)
        let removeFromViewTransform = moveUpTransform.concatenating(scaleUpTranform)        
        destination.closeVisualEffectView.alpha = 0
        destination.closeVisualEffectView.transform = removeFromViewTransform
        destination.subheadVisualEffectView.alpha = 0
        destination.subheadVisualEffectView.transform = removeFromViewTransform
        
        
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8) {
            
            // Final state
            
            NSLayoutConstraint.deactivate([widthConstraint, heightConstraint, bottomConstraint])
            destination.view.layer.transform = CATransform3DIdentity
            containerView.layoutIfNeeded()
            destination.scrollView.layer.cornerRadius = 0
            destination.closeVisualEffectView.alpha = 1
            destination.closeVisualEffectView.transform = .identity
            destination.subheadVisualEffectView.alpha = 1
            destination.subheadVisualEffectView.transform = .identity
            
            let scaleTitleTranform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            let moveTitleTransform = CGAffineTransform(translationX: 30, y: 10)
            let titleTranform = scaleTitleTranform.concatenating(moveTitleTransform)
            
            destination.titleLabel.transform = titleTranform
        }
        
        animator.addCompletion { (finished) in
            // Completion
            transitionContext.completeTransition(true)
        }
        
        animator.startAnimation()

    }
}
