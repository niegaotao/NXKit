//
//  NXSwitch.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/10.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit

extension NXSwitch {
    /*
     oval                    仿UISwitch扁平化效果
     rectangle               矩形带圆角
     rectangleNoCorner       矩形不带圆角
     */
    public enum Shape {
        case oval, rectangle, rectangleNoCorner
    }
}


open class NXSwitch: NXControl {
    open var animateDuration: Double = 0.3
    open var horizontalAdjustment: CGFloat = 5.0
    open var cornerRadius: CGFloat = 4.0
    open var shadowOpacity: Float = 0.3
    open var shadowRadius: CGFloat = 0.5
    open var borderWidth: CGFloat = 1.75
    public final var onBackgroundView: UIView = UIView()
    public final var offBackgroundView: UIView = UIView()
    public final var thumbView: UIView = UIView()
    public final var tapRecongizer = UITapGestureRecognizer()
    
    //未选中颜色后背景色   默认0xFFFFFF
    open var offTintColor: UIColor = NXUI.color(0xFFFFFF, 1) {
        didSet {
            offBackgroundView.backgroundColor = offTintColor
        }
    }
    
    //选中颜色后背景色   默认0xFFFFFF
    open var onTintColor: UIColor = NXUI.color(0xFFFFFF, 1) {
        didSet {
            onBackgroundView.backgroundColor = onTintColor
        }
    }
    
    //未中颜色后背景边框颜色
    open var offTintBorderColor: UIColor? = nil {
        didSet {
            if offTintBorderColor != nil {
                offBackgroundView.layer.borderColor = offTintBorderColor!.cgColor
                offBackgroundView.layer.borderWidth = 1.0
            }
        }
    }
    
    //选中颜色后背景边框颜色
    open var onTintBorderColor: UIColor? = nil {
        didSet {
            if onTintBorderColor != nil {
                onBackgroundView.layer.borderColor = onTintBorderColor!.cgColor
                onBackgroundView.layer.borderWidth = 1.0
            }
        }
    }
    
    //未选中后中间圆圈背景色
    open var offThumbTintColor: UIColor? = nil {
        didSet {
            if offThumbTintColor != nil {
                thumbView.backgroundColor = offThumbTintColor!
            }
        }
    }
    
    
    //选中后中间圆圈背景色
    open var onThumbTintColor: UIColor? = nil {
        didSet {
            if onThumbTintColor != nil {
                thumbView.backgroundColor = onThumbTintColor!
            }
        }
    }
    
    /*
     样式 默认oval
     */
    open var shape: NXSwitch.Shape = .oval {
        didSet {
            self.updateSubviews("shape", nil)
        }
    }

    /*
     开关状态 默认开
     */
    open var on: Bool = true {
        didSet {
            self.updateSubviews("on", nil)
        }
    }
    
    open override func setupSubviews() {
        self.backgroundColor = UIColor.clear
        
        onBackgroundView.isUserInteractionEnabled = false
        onBackgroundView.frame = self.bounds
        onBackgroundView.backgroundColor = onTintColor
        onBackgroundView.layer.cornerRadius = onBackgroundView.y
        onBackgroundView.layer.shouldRasterize = true
        onBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        self.addSubview(onBackgroundView)
        
        offBackgroundView.isUserInteractionEnabled = false
        offBackgroundView.frame = self.bounds
        offBackgroundView.backgroundColor = offTintColor
        offBackgroundView.layer.cornerRadius = onBackgroundView.y
        offBackgroundView.layer.shouldRasterize = true
        offBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        self.addSubview(offBackgroundView)
        
        thumbView.frame = CGRect(x: 0, y: 0, width: self.h - horizontalAdjustment, height: self.h - horizontalAdjustment)
        thumbView.backgroundColor = UIColor.white
        thumbView.isUserInteractionEnabled = false
        thumbView.layer.cornerRadius = thumbView.w / 2.0
        thumbView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thumbView.layer.shouldRasterize = true
        thumbView.layer.shadowOpacity = shadowOpacity
        thumbView.layer.shadowRadius = shadowRadius
        thumbView.layer.rasterizationScale = UIScreen.main.scale
        self.addSubview(thumbView)
        thumbView.center = CGPoint(x: thumbView.w / 2.0, y: self.h / 2.0)
        
        self.tapRecongizer.addTarget(self, action: #selector(handleBgTap))
        self.addGestureRecognizer(self.tapRecongizer)
                
        shape = .oval
        on = false
    }
    
    open override func updateSubviews(_ action:String, _ value:Any?){
        if action == "shape" {
            switch self.shape {
                case .oval:
                    onBackgroundView.layer.cornerRadius = self.frame.size.height / 2.0
                    offBackgroundView.layer.cornerRadius = self.frame.size.height / 2.0
                    thumbView.layer.cornerRadius = (self.frame.size.height - horizontalAdjustment) / 2.0
            
                case .rectangle:
                    onBackgroundView.layer.cornerRadius = cornerRadius
                    offBackgroundView.layer.cornerRadius = cornerRadius
                    thumbView.layer.cornerRadius = cornerRadius
            
                case .rectangleNoCorner:
                    onBackgroundView.layer.cornerRadius = 0
                    offBackgroundView.layer.cornerRadius = 0
                    thumbView.layer.cornerRadius = 0
            }
        }
        else if action == "on" {
            if self.on {
                onBackgroundView.alpha = 1.0
                offBackgroundView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                
                thumbView.center = CGPoint(x: onBackgroundView.w - (thumbView.w + horizontalAdjustment) / 2.0, y: thumbView.center.y)
                thumbView.backgroundColor = onThumbTintColor ?? NXUI.mainColor
                
            } else {
                onBackgroundView.alpha = 0.0
                offBackgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                thumbView.center = CGPoint(x: (thumbView.w + horizontalAdjustment) / 2.0, y: thumbView.center.y)
                thumbView.backgroundColor = offThumbTintColor ?? NXUI.darkGrayColor
            }
        }
    }
    
    @objc func handleBgTap(tap: UITapGestureRecognizer) {
        if self.isUserInteractionEnabled == false {
            return
        }
        if tap.state == .ended {
            let isOn = !self.on
            self.isUserInteractionEnabled = false
            self.startAnimations(duration: animateDuration, isOn: isOn, completion: {[weak self] isCompleted in
                self?.isUserInteractionEnabled = true
            })
        }
    }
    
    final public func startAnimations(duration: Double, isOn: Bool, completion: ((_ isCompleted:Bool) -> ())? = nil) {
        var centerPoint = CGPoint.zero
        if isOn {
            centerPoint = CGPoint(x: onBackgroundView.w - (thumbView.w + horizontalAdjustment) / 2.0, y: thumbView.center.y)
        }
        else {
            centerPoint = CGPoint(x: (thumbView.w + horizontalAdjustment) / 2.0, y: thumbView.center.y)
        }
        
        UIView.animate(withDuration: duration,
                       animations: {
            self.thumbView.center = centerPoint
            self.onBackgroundView.alpha = isOn ? 1.0 : 0.0
        }) { finished in
            if finished {
                self.updateSwitch(isOn: isOn)
            }
            completion?(true)
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0.075,
                       options: .curveEaseOut,
                       animations: {
                        self.offBackgroundView.transform = isOn ? CGAffineTransform(scaleX: 0.0, y: 0.0) : CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished) in
        }
    }
    
    final func updateSwitch(isOn: Bool) {
        on = isOn
        
        self.sendActions(for: .valueChanged)
    }
}
