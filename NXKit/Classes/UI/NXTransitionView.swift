//
//  NXTransitionView.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/7.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit

/**
 1.转场动画的容器视图，这个视图会优先添加到现有导航栈最靠顶端的一个控制器视图上
 2.即将展示的视图控制器会添加到这个容器视图上。
 3.基础功能类似于UINavigationTransitionView,即让即将展示的控制器视图在这个视图上做动画
 */


open class NXTransitionView: NXView {
    
    open weak var owner: NXViewController!
    
    public var p : CGPoint = CGPoint.zero
    lazy private var panRecognizer : UIPanGestureRecognizer = {
        let __panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerAction))
        __panRecognizer.isEnabled = false
        return __panRecognizer
    }()
    
    public init(frame: CGRect, owner: NXViewController) {
        super.init(frame: frame)
        self.owner = owner
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setupSubviews() {
        self.addGestureRecognizer(self.panRecognizer)
    }
    
    override open func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        if let viewController = view.next as? NXViewController, viewController == owner {
            if owner.ctxs.orientation == .bottom || owner.ctxs.orientation == .top {
                panRecognizer.isEnabled = false
            }
            else{
                panRecognizer.isEnabled = true
            }
        }
    }
    
    
    @objc open func panRecognizerAction() {
        let point = panRecognizer.translation(in: self)
        if panRecognizer.state == .began {
            self.p = point
        }
        else if panRecognizer.state == .changed {
            var affineValue = point.x - self.p.x
            
            if owner.ctxs.orientation == .right {
                if affineValue < 0 { affineValue = 0}
                if affineValue > NXDevice.width { affineValue = NXDevice.width}
            }
            else if owner.ctxs.orientation == .left {
                if affineValue > 0 { affineValue = 0}
                if affineValue < -NXDevice.width { affineValue = -NXDevice.width}
            }
            owner.view.x = affineValue
        }
        else {
            if owner.ctxs.orientation == .right {
                if owner.view.x < NXDevice.width/3.0 {
                    UIView.animate(withDuration: 0.2) {
                        self.owner.view.x = 0.0
                        self.backgroundColor = NX.maxAlphaOfColor
                    }
                }
                else {
                    if let naviController = self.owner.ctxs.superviewController?.navigationController as? NXNavigationController {
                        naviController.removeSubviewController(owner, animated: true)
                        UIView.animate(withDuration: naviController.ctxs.duration*0.6) {
                            self.owner.view.x = NXDevice.width
                            self.backgroundColor = NX.minAlphaOfColor
                        }
                    }
                    
                }
            }
            else {
                if owner.view.x > -NXDevice.width/3.0 {
                    UIView.animate(withDuration: 0.2) {
                        self.owner.view.x = 0.0
                        self.backgroundColor = NX.maxAlphaOfColor
                    }
                }
                else {
                    if let naviController = self.owner.ctxs.superviewController?.navigationController as? NXNavigationController {
                        naviController.removeSubviewController(owner, animated: true)
                        UIView.animate(withDuration: naviController.ctxs.duration*0.6) {
                            self.owner.view.x = -NXDevice.width
                            self.backgroundColor = NX.minAlphaOfColor
                        }
                    }
                }
            }
        }
    }
}
