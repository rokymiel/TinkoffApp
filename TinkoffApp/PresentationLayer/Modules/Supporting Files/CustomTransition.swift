//
//  CustomTransition.swift
//  TinkoffApp
//
//  Created by Михаил on 26.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
class MyCustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5 }
    
    func animateTransition(using
        transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if let toView = transitionContext.view(forKey: .to) {
        //let fromView = transitionContext.view(forKey: .from)!
//        let fromVC = transitionContext.viewController(forKey: .from)!
//        let toVC = transitionContext.viewController(forKey: .to)!
        containerView.addSubview(toView)
        toView.alpha = 0.0
        let x = toView.center.x
        toView.center = CGPoint(x: -50, y: toView.center.y)
        UIView.animate(withDuration: 1.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0,
                       animations: {
                        toView.alpha = 1.0
                        toView.center = CGPoint(x: x, y: toView.center.y)
                        
        }, completion: { _ in
        transitionContext.completeTransition(true) })
//        UIView.animate(withDuration: 1.5,
//                       animations: {
//                        toView.alpha = 1.0
//                        toView.center = CGPoint(x: x, y: toView.center.y)
//        },
//                       completion: { _ in
//                        transitionContext.completeTransition(true) })
        
        }
        
    }
    
}

class MyCustomDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5 }
    func animateTransition(using
        transitionContext: UIViewControllerContextTransitioning) {
        //let containerView = transitionContext.containerView
        //let toView = transitionContext.view(forKey: .to)!
        //let fromView = transitionContext.view(forKey: .from)!
        if let fromVC = transitionContext.viewController(forKey: .from) {
        //let toVC = transitionContext.viewController(forKey: .to)!
        fromVC.removeFromParent()//.removeFromSuperview()
        fromVC.view.alpha = 1.0
        UIView.animate(withDuration: 1.5,
                       animations: {
                        fromVC.view.alpha = 0.0 },
                       completion: { _ in
                        transitionContext.completeTransition(true) })
            
        }
        
    }
}
