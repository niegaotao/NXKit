//
//  NXAnimationView.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/19.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public protocol NXAnimationViewProtocol: NSObjectProtocol {
    func startAnimating()
    func stopAnimating()
}

open class NXAnimationView: NXImageView, NXAnimationViewProtocol {
    //动画时长
    open var duration : CFTimeInterval = 1.0
    //是否在动画
    open var isAnimation : Bool = false
    
    override open func setupSubviews() {
        self.isHidden = true
        self.contentMode = .scaleAspectFill
        self.backgroundColor = UIColor.clear
        self.image = NXKit.image(named:"icon-animation.png")
    }
    
    //开始动画
    open override func startAnimating() {
        self.isHidden = false
        if !self.isAnimation {
            self.isAnimation = true
            self.addAnimations()
        }
    }
    
    //结束动画
    open override func stopAnimating() {
        self.isAnimation = false
        self.removeAnimations()
        self.isHidden = true
    }
    
    //添加动画
    open func addAnimations(){
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = self.duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float(Int.max)
        self.layer.add(animation, forKey: "rotate")
    }
    
    //移除动画
    open func removeAnimations(){
        self.layer.removeAllAnimations()
    }
}

open class NXAnimationWrappedView: NXAutoresizeView<NXAnimationView>, NXAnimationViewProtocol {
    //转圈的视图
    open var animation = CGSize(width: 50, height: 50)
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        self.isHidden = true
        self.backgroundColor = UIColor.clear
        self.contentMode = .center
    }
    
    //开始动画
    open func startAnimating() {
        self.isHidden = false
        self.contentView.startAnimating()
    }
    
    //结束动画
    open func stopAnimating() {
        self.contentView.stopAnimating()
        self.isHidden = true
    }
    
    //布局
    open override func layoutSubviews() {
        self.contentView.frame = CGRect(x: (self.width-self.animation.width)/2, y: (self.height-self.animation.height)/2, width: self.animation.width, height: self.animation.height)
    }
}
