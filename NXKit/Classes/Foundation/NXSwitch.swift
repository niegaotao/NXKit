//
//  NXSwitch.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/10.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public extension NXSwitch {
    /*
     oval                    仿UISwitch扁平化效果
     rectangle               矩形带圆角
     rectangleNoCorner       矩形不带圆角
     */
    enum Shape {
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
    public final var onBackgroundView: UIView = .init()
    public final var offBackgroundView: UIView = .init()
    public final var thumbView: UIView = .init()
    public final var tapRecongizer = UITapGestureRecognizer()

    // 未选中颜色后背景色   默认0xFFFFFF
    open var offTintColor: UIColor = NXKit.color(0xFFFFFF, 1) {
        didSet {
            offBackgroundView.backgroundColor = offTintColor
        }
    }

    // 选中颜色后背景色   默认0xFFFFFF
    open var onTintColor: UIColor = NXKit.color(0xFFFFFF, 1) {
        didSet {
            onBackgroundView.backgroundColor = onTintColor
        }
    }

    // 未中颜色后背景边框颜色
    open var offTintBorderColor: UIColor? = nil {
        didSet {
            if offTintBorderColor != nil {
                offBackgroundView.layer.borderColor = offTintBorderColor!.cgColor
                offBackgroundView.layer.borderWidth = 1.0
            }
        }
    }

    // 选中颜色后背景边框颜色
    open var onTintBorderColor: UIColor? = nil {
        didSet {
            if onTintBorderColor != nil {
                onBackgroundView.layer.borderColor = onTintBorderColor!.cgColor
                onBackgroundView.layer.borderWidth = 1.0
            }
        }
    }

    // 未选中后中间圆圈背景色
    open var offThumbTintColor: UIColor? = nil {
        didSet {
            if offThumbTintColor != nil {
                thumbView.backgroundColor = offThumbTintColor!
            }
        }
    }

    // 选中后中间圆圈背景色
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
            updateSubviews("shape")
        }
    }

    /*
     开关状态 默认开
     */
    open var on: Bool = true {
        didSet {
            updateSubviews("on")
        }
    }

    override open func setupSubviews() {
        backgroundColor = UIColor.clear

        onBackgroundView.isUserInteractionEnabled = false
        onBackgroundView.frame = bounds
        onBackgroundView.backgroundColor = onTintColor
        onBackgroundView.layer.cornerRadius = onBackgroundView.y
        onBackgroundView.layer.shouldRasterize = true
        onBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        addSubview(onBackgroundView)

        offBackgroundView.isUserInteractionEnabled = false
        offBackgroundView.frame = bounds
        offBackgroundView.backgroundColor = offTintColor
        offBackgroundView.layer.cornerRadius = onBackgroundView.y
        offBackgroundView.layer.shouldRasterize = true
        offBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        addSubview(offBackgroundView)

        thumbView.frame = CGRect(x: 0, y: 0, width: height - horizontalAdjustment, height: height - horizontalAdjustment)
        thumbView.backgroundColor = UIColor.white
        thumbView.isUserInteractionEnabled = false
        thumbView.layer.cornerRadius = thumbView.width / 2.0
        thumbView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thumbView.layer.shouldRasterize = true
        thumbView.layer.shadowOpacity = shadowOpacity
        thumbView.layer.shadowRadius = shadowRadius
        thumbView.layer.rasterizationScale = UIScreen.main.scale
        addSubview(thumbView)
        thumbView.center = CGPoint(x: thumbView.width / 2.0, y: height / 2.0)

        tapRecongizer.addTarget(self, action: #selector(handleBgTap))
        addGestureRecognizer(tapRecongizer)

        shape = .oval
        on = false
    }

    override open func updateSubviews(_ value: Any?) {
        if let value = value as? String, value == "shape" {
            switch shape {
            case .oval:
                onBackgroundView.layer.cornerRadius = frame.size.height / 2.0
                offBackgroundView.layer.cornerRadius = frame.size.height / 2.0
                thumbView.layer.cornerRadius = (frame.size.height - horizontalAdjustment) / 2.0

            case .rectangle:
                onBackgroundView.layer.cornerRadius = cornerRadius
                offBackgroundView.layer.cornerRadius = cornerRadius
                thumbView.layer.cornerRadius = cornerRadius

            case .rectangleNoCorner:
                onBackgroundView.layer.cornerRadius = 0
                offBackgroundView.layer.cornerRadius = 0
                thumbView.layer.cornerRadius = 0
            }
        } else if let value = value as? String, value == "on" {
            if on {
                onBackgroundView.alpha = 1.0
                offBackgroundView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)

                thumbView.center = CGPoint(x: onBackgroundView.width - (thumbView.width + horizontalAdjustment) / 2.0, y: thumbView.center.y)
                thumbView.backgroundColor = onThumbTintColor ?? NXKit.primaryColor

            } else {
                onBackgroundView.alpha = 0.0
                offBackgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

                thumbView.center = CGPoint(x: (thumbView.width + horizontalAdjustment) / 2.0, y: thumbView.center.y)
                thumbView.backgroundColor = offThumbTintColor ?? NXKit.lightGrayColor
            }
        }
    }

    @objc func handleBgTap(tap: UITapGestureRecognizer) {
        if isUserInteractionEnabled == false {
            return
        }
        if tap.state == .ended {
            let isOn = !on
            isUserInteractionEnabled = false
            startAnimations(duration: animateDuration, isOn: isOn, completion: { [weak self] _ in
                self?.isUserInteractionEnabled = true
            })
        }
    }

    public final func startAnimations(duration: Double, isOn: Bool, completion: ((_ isCompleted: Bool) -> Void)? = nil) {
        var centerPoint = CGPoint.zero
        if isOn {
            centerPoint = CGPoint(x: onBackgroundView.width - (thumbView.width + horizontalAdjustment) / 2.0, y: thumbView.center.y)
        } else {
            centerPoint = CGPoint(x: (thumbView.width + horizontalAdjustment) / 2.0, y: thumbView.center.y)
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
                       }) { _ in
        }
    }

    final func updateSwitch(isOn: Bool) {
        on = isOn

        sendActions(for: .valueChanged)
    }
}
