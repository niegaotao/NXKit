//
//  NXKit+UIView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/19.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

/*
 UIView 的大小属性
 */
public extension UIView {
    var x: CGFloat {
        set {
            var __frame = frame
            __frame.origin.x = newValue
            frame = __frame
        }
        get {
            return frame.origin.x
        }
    }

    var y: CGFloat {
        set {
            var __frame = frame
            __frame.origin.y = newValue
            frame = __frame
        }
        get {
            return frame.origin.y
        }
    }

    var width: CGFloat {
        set {
            var __frame = frame
            __frame.size.width = newValue
            frame = __frame
        }
        get {
            return frame.size.width
        }
    }

    var height: CGFloat {
        set {
            var __frame = frame
            __frame.size.height = newValue
            frame = __frame
        }
        get {
            return frame.size.height
        }
    }

    var maxX: CGFloat {
        return frame.origin.x + frame.size.width
    }

    var maxY: CGFloat {
        return frame.origin.y + frame.size.height
    }
}

/*
 UIView 的layer设置
 */
public extension UIView {
    var association: NXViewAssociation? {
        set {
            objc_setAssociatedObject(self, &NXViewAssociation.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &NXViewAssociation.key) as? NXViewAssociation
        }
    }

    //
    func setupEvent(_ event: UIControl.Event, action: NXKit.Event<UIControl.Event, UIView>?) {
        if association == nil {
            association = NXViewAssociation()
        }
        if let action = action {
            association?.addTarget(self, event: event, action: action)
        } else {
            association?.removeTarget(self, event: event)
        }
    }

    // 设置圆角
    func setupCorner(rect: CGRect, corners: UIRectCorner, radii: CGSize) {
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        if let maskLayer = layer.mask as? CAShapeLayer {
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        } else {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
    }

    // 设置边框+圆角
    func setupBorder(color: UIColor, width: CGFloat, radius: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    // 设置阴影效果
    func setupShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        // 设置阴影
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.15
        // 设置圆角
        layer.cornerRadius = layer.shadowRadius
        layer.masksToBounds = false
    }

    // 添加上下/左右的边缘分割线
    func setupSeparator(color: UIColor, ats: NXKit.Ats, insets: UIEdgeInsets = UIEdgeInsets.zero, width: CGFloat = NXKit.pixel) {
        let __color = color
        let __width = width

        if ats.contains(.minY), ats.contains(.minX), ats.contains(.maxY), ats.contains(.maxX) {
            /// 四周都添加分割线
            association?.separator?.isHidden = true
            setupBorder(color: __color, width: __width, radius: 0)
        } else if ats.isEmpty {
            /// 无分割线
            association?.separator?.isHidden = true
        } else {
            /// 只有一边添加分割线
            var separator = association?.separator
            if separator == nil {
                separator = CALayer()
                layer.addSublayer(separator!)
                if association == nil {
                    association = NXViewAssociation()
                }
                association?.separator = separator
            }
            separator?.isHidden = false
            separator?.backgroundColor = color.cgColor

            if ats.contains(.minY) {
                separator?.frame = CGRect(x: insets.left, y: 0, width: self.width - insets.left - insets.right, height: width)
            } else if ats.contains(.minX) {
                separator?.frame = CGRect(x: 0, y: insets.top, width: __width, height: height - insets.top - insets.bottom)
            } else if ats.contains(.maxY) {
                separator?.frame = CGRect(x: insets.left, y: height - __width, width: self.width - insets.left - insets.right, height: __width)
            } else if ats.contains(.maxX) {
                separator?.frame = CGRect(x: self.width - __width, y: 0, width: __width, height: height - insets.top - insets.bottom)
            }
        }
    }
}

/*
 UIView 的功能
 */
public extension UIView {
    /*
     *  获取当前view的viewcontroller
     */
    var nextViewController: UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

// 添加虚线边框
extension UIView {
    public func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 3, lineSpacing: Int = 3, ats: NXKit.Ats) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = strokeColor.cgColor

        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        // 每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        if ats.contains(.minX) {
            path.move(to: CGPoint(x: 0, y: layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }

        if ats.contains(.minY) {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: layer.bounds.width, y: 0))
        }

        if ats.contains(.maxX) {
            path.move(to: CGPoint(x: layer.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height))
        }

        if ats.contains(.maxY) {
            path.move(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: layer.bounds.height))
        }

        shapeLayer.path = path

        layer.addSublayer(shapeLayer)
    }

    /// 画实线边框
    func drawLine(strokeColor: UIColor, lineWidth: CGFloat, ats: NXKit.Ats) {
        if ats.contains(.minY), ats.contains(.minX), ats.contains(.maxY), ats.contains(.maxX) {
            layer.borderWidth = lineWidth
            layer.borderColor = strokeColor.cgColor
        } else {
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = bounds
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = lineWidth

            shapeLayer.lineJoin = CAShapeLayerLineJoin.round

            let path = CGMutablePath()
            if ats.contains(.minX) {
                path.move(to: CGPoint(x: 0, y: layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
            }

            if ats.contains(.minY) {
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: layer.bounds.width, y: 0))
            }

            if ats.contains(.maxX) {
                path.move(to: CGPoint(x: layer.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height))
            }

            if ats.contains(.maxY) {
                path.move(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: layer.bounds.height))
            }
            shapeLayer.path = path

            layer.addSublayer(shapeLayer)
        }
    }
}

public extension UIControl.Event {
    static var tap = UIControl.Event(rawValue: 100) // UITapGestureRecognizer
    static var longPress = UIControl.Event(rawValue: 101) // UILongPressGestureRecognizer
    static var pan = UIControl.Event(rawValue: 102) // UIPanGestureRecognizer
    static var pinch = UIControl.Event(rawValue: 103) // UIPinchGestureRecognizer
    static var rotation = UIControl.Event(rawValue: 104) // UIRotationGestureRecognizer
    static var swipe = UIControl.Event(rawValue: 105) // UISwipeGestureRecognizer
}

public extension UIControl {
    class Target: NXAny {
        public weak var view: UIView?
        public var event = UIControl.Event.touchUpInside
        public var recognizer: UIGestureRecognizer?
        public var completion: NXKit.Event<UIControl.Event, UIView>?

        public init(view: UIView, event: UIControl.Event, completion: NXKit.Event<UIControl.Event, UIView>?) {
            self.view = view
            self.event = event
            self.completion = completion
        }

        public required init() {
            fatalError("init() has not been implemented")
        }

        @objc public func invoke() {
            if event.rawValue < UIControl.Event.tap.rawValue || event.rawValue > UIControl.Event.swipe.rawValue {
                if let __view = view as? UIControl {
                    completion?(event, __view)
                }
            } else {
                if let recognizer = recognizer, let __view = view {
                    if recognizer.isKind(of: UILongPressGestureRecognizer.self) {
                        if recognizer.state == .began {
                            completion?(event, __view)
                        }
                    } else {
                        completion?(event, __view)
                    }
                }
            }
        }
    }
}

public class NXViewAssociation {
    static var key = "key"
    open weak var separator: CALayer?
    public private(set) var targets = [UIControl.Event.RawValue: UIControl.Target]()

    public func addTarget(_ targetView: UIView, event: UIControl.Event, action: NXKit.Event<UIControl.Event, UIView>?) {
        if let target = targets[event.rawValue] {
            target.completion = action
            return
        }

        let wrapped = UIControl.Target(view: targetView, event: event, completion: action)
        if event.rawValue < UIControl.Event.tap.rawValue || event.rawValue > UIControl.Event.swipe.rawValue {
            if let control = targetView as? UIControl {
                control.addTarget(wrapped, action: #selector(UIControl.Target.invoke), for: event)
                targets[event.rawValue] = wrapped
            }
        } else {
            if event == .tap {
                wrapped.recognizer = UITapGestureRecognizer()
            } else if event == .longPress {
                wrapped.recognizer = UILongPressGestureRecognizer()
            } else if event == .pan {
                wrapped.recognizer = UIPanGestureRecognizer()
            } else if event == .pinch {
                wrapped.recognizer = UIPinchGestureRecognizer()
            } else if event == .rotation {
                wrapped.recognizer = UIRotationGestureRecognizer()
            } else if event == .swipe {
                wrapped.recognizer = UISwipeGestureRecognizer()
            }

            if let __recognizer = wrapped.recognizer {
                __recognizer.addTarget(wrapped, action: #selector(UIControl.Target.invoke))
                targetView.addGestureRecognizer(__recognizer)
                targetView.isUserInteractionEnabled = true
                wrapped.recognizer = __recognizer
                targets[event.rawValue] = wrapped
            }
        }
    }

    public func removeTarget(_ targetView: UIView, event: UIControl.Event) {
        if let wrapped = targets[event.rawValue] {
            if event.rawValue < UIControl.Event.tap.rawValue || event.rawValue > UIControl.Event.swipe.rawValue {
                if let control = targetView as? UIControl {
                    control.removeTarget(wrapped, action: #selector(UIControl.Target.invoke), for: event)
                    targets.removeValue(forKey: event.rawValue)
                }
            } else {
                if let recognizer = wrapped.recognizer {
                    targetView.removeGestureRecognizer(recognizer)
                    targets.removeValue(forKey: event.rawValue)
                    wrapped.recognizer = nil
                }
            }
        }
    }
}
