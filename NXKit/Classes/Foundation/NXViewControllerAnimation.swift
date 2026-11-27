//
//  NXViewControllerAnimation.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/18.
//  Copyright (c) 2021年 niegaotao. All rights reserved.
//

import UIKit

open class NXViewControllerAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    private var operation = UINavigationController.Operation.push
    private var duration  = 0.35
    public init(operation:UINavigationController.Operation, duration:TimeInterval) {
        super.init()
        self.operation = operation
        self.duration = 0.35
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            self.operation != .none else {
                transitionContext.completeTransition(false)
                return;
        }
        
        let containerView = transitionContext.containerView
        if self.operation == .push {
            containerView.addSubview(fromView)
            fromView.frame = containerView.bounds
            fromView.x = 0
            fromView.autoresizingMask = [.flexibleHeight]

            containerView.addSubview(toView)
            toView.frame = containerView.bounds
            toView.x = containerView.width
            toView.autoresizingMask = [.flexibleHeight]
            
            UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.x = -containerView.width * 0.3
                toView.x = 0
                
            }, completion:  { (completed) in
                transitionContext.completeTransition(true)
            })
        }
        else if self.operation == .pop {
            containerView.addSubview(toView)
            toView.x = -containerView.width * 0.3
            toView.height = containerView.height
            toView.autoresizingMask = [.flexibleHeight]
            
            containerView.addSubview(fromView)
            
            UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.x = containerView.width
                toView.x = 0
                
            }, completion:  { (completed) in
                transitionContext.completeTransition(true)
            })
        }
    }
    
}
