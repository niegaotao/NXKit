//
//  NXAnimationView.swift
//  NXKit
//
//  Created by firelonely on 2018/7/19.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXAnimationView: NXImageView {
    //动画时长
    open var duration : CFTimeInterval = 1.0
    //是否在动画
    open var isAnimation : Bool = false
    
    override open func setupSubviews() {
        self.isHidden = true
        self.contentMode = .scaleAspectFill
        self.backgroundColor = UIColor.clear
        self.image = NX.image(named:"uiapp_overlay.png")
    }
    
    //开始动画
    open override func startAnimating() {
        self.isHidden = false
        if !self.isAnimation {
            self.isAnimation = true
            self.startAnimations()
        }
    }
    
    //结束动画
    open func stopAnimating(_ isCompleted:Bool = true) {
        self.isAnimation = false
        self.layer.removeAllAnimations()
        self.isHidden = true
    }
    
    //动画
    open func startAnimations(){
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = self.duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float(Int.max)
        self.layer.add(animation, forKey: "rotate")
    }
}


open class NXAnimationWrappedView: NXView {
    //转圈的视图
    open var animationView = NXAnimationView()
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setupSubviews() {
        self.isHidden = true
        self.backgroundColor = UIColor.clear
        self.contentMode = .center
        
        self.animationView.frame = CGRect(x: (self.w-50)/2, y: (self.h-50)/2, width: 50, height: 50)
        self.animationView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.animationView.contentMode = .scaleAspectFill
        self.animationView.backgroundColor = UIColor.clear
        self.animationView.image = NX.image(named:"uiapp_overlay.png")
        self.animationView.isHidden = true
        self.addSubview(animationView)
    }
    
    //开始动画
    open func startAnimating() {
        self.isHidden = false
        self.animationView.startAnimating()
    }
    
    //结束动画
    open func stopAnimating(_ isCompleted:Bool = true) {
        self.animationView.stopAnimating()
        self.isHidden = true
    }
}
