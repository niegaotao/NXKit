//
//  LEYTransitionView.swift
//  NXFoundation
//
//  Created by firelonely on 2018/7/7.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

/**
 1.转场动画的容器视图，这个视图会优先添加到现有导航栈最靠顶端的一个控制器视图上
 2.即将展示的视图控制器会添加到这个容器视图上。
 3.基础功能类似于UINavigationTransitionView,即让即将展示的控制器视图在这个视图上做动画
 */


open class LEYTransitionView: LEYView {
    
    open weak var owner: LEYViewController!
    
    public var p : CGPoint = CGPoint.zero
    lazy private var panRecognizer : UIPanGestureRecognizer = {
        let __panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerAction))
        __panRecognizer.isEnabled = false
        return __panRecognizer
    }()
    
    public init(frame: CGRect, owner: LEYViewController) {
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
        
        if let viewController = view.next as? LEYViewController, viewController == owner {
            if owner.ctxs.oriention == .bottom || owner.ctxs.oriention == .top {
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
            
            if owner.ctxs.oriention == .right {
                if affineValue < 0 { affineValue = 0}
                if affineValue > LEYDevice.width { affineValue = LEYDevice.width}
            }
            else if owner.ctxs.oriention == .left {
                if affineValue > 0 { affineValue = 0}
                if affineValue < -LEYDevice.width { affineValue = -LEYDevice.width}
            }
            owner.view.x = affineValue
        }
        else {
            if owner.ctxs.oriention == .right {
                if owner.view.x < LEYDevice.width/3.0 {
                    UIView.animate(withDuration: 0.2) {
                        self.owner.view.x = 0.0
                        self.backgroundColor = LEYApp.maxAlphaOfColor
                    }
                }
                else {
                    if let naviController = self.owner.ctxs.superviewController?.navigationController as? LEYNavigationController {
                        naviController.removeSubviewController(owner, animated: true)
                        UIView.animate(withDuration: naviController.ctxs.duration*0.6) {
                            self.owner.view.x = LEYDevice.width
                            self.backgroundColor = LEYApp.minAlphaOfColor
                        }
                    }
                    
                }
            }
            else {
                if owner.view.x > -LEYDevice.width/3.0 {
                    UIView.animate(withDuration: 0.2) {
                        self.owner.view.x = 0.0
                        self.backgroundColor = LEYApp.maxAlphaOfColor
                    }
                }
                else {
                    if let naviController = self.owner.ctxs.superviewController?.navigationController as? LEYNavigationController {
                        naviController.removeSubviewController(owner, animated: true)
                        UIView.animate(withDuration: naviController.ctxs.duration*0.6) {
                            self.owner.view.x = -LEYDevice.width
                            self.backgroundColor = LEYApp.minAlphaOfColor
                        }
                    }
                }
            }
        }
    }
}
