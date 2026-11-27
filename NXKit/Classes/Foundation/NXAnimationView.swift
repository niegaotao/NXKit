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
    // 动画时长
    open var duration: CFTimeInterval = 1.0
    // 是否在动画
    open var isAnimation: Bool = false

    override open func setupSubviews() {
        isHidden = true
        contentMode = .scaleAspectFill
        backgroundColor = UIColor.clear
        image = NXKit.image(named: "icon-animation.png")
    }

    // 开始动画
    override open func startAnimating() {
        isHidden = false
        if !isAnimation {
            isAnimation = true
            addAnimations()
        }
    }

    // 结束动画
    override open func stopAnimating() {
        isAnimation = false
        removeAnimations()
        isHidden = true
    }

    // 添加动画
    open func addAnimations() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float(Int.max)
        layer.add(animation, forKey: "rotate")
    }

    // 移除动画
    open func removeAnimations() {
        layer.removeAllAnimations()
    }
}

open class NXAnimationWrappedView: NXAutoresizeView<NXAnimationView>, NXAnimationViewProtocol {
    // 转圈的视图
    open var animation = CGSize(width: 50, height: 50)

    override public required init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func setupSubviews() {
        super.setupSubviews()
        isHidden = true
        backgroundColor = UIColor.clear
        contentMode = .center
    }

    // 开始动画
    open func startAnimating() {
        isHidden = false
        contentView.startAnimating()
    }

    // 结束动画
    open func stopAnimating() {
        contentView.stopAnimating()
        isHidden = true
    }

    // 布局
    override open func layoutSubviews() {
        contentView.frame = CGRect(x: (width - animation.width) / 2, y: (height - animation.height) / 2, width: animation.width, height: animation.height)
    }
}
