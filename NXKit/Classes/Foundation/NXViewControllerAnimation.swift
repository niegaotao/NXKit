//
//  NXViewControllerAnimation.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/18.
//  Copyright (c) 2021年 niegaotao. All rights reserved.
//

import UIKit

open class NXViewControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private var operation = UINavigationController.Operation.push
    private var duration = 0.35
    public init(operation: UINavigationController.Operation, duration _: TimeInterval) {
        super.init()
        self.operation = operation
        duration = 0.35
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to),
              operation != .none
        else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        if operation == .push {
            containerView.addSubview(fromView)
            fromView.frame = containerView.bounds
            fromView.x = 0
            fromView.autoresizingMask = [.flexibleHeight]

            containerView.addSubview(toView)
            toView.frame = containerView.bounds
            toView.x = containerView.width
            toView.autoresizingMask = [.flexibleHeight]

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.x = -containerView.width * 0.3
                toView.x = 0

            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else if operation == .pop {
            containerView.addSubview(toView)
            toView.x = -containerView.width * 0.3
            toView.height = containerView.height
            toView.autoresizingMask = [.flexibleHeight]

            containerView.addSubview(fromView)

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.x = containerView.width
                toView.x = 0

            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
