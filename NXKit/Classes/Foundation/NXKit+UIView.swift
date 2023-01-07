//
//  UIView+NXFoundation.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/19.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

/*
 UIView 的大小属性
 */
extension UIView {
    public var x : CGFloat {
        set{
            var __frame = self.frame
            __frame.origin.x = newValue
            self.frame = __frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    public var y : CGFloat {
        set{
            var __frame = self.frame
            __frame.origin.y = newValue
            self.frame = __frame
        }
        get{
           return self.frame.origin.y
        }
    }
    
    public var width : CGFloat {
        set{
            var __frame = self.frame
            __frame.size.width = newValue
            self.frame = __frame
        }
        get{
            return self.frame.size.width
        }
    }
    
    public var height : CGFloat {
        set{
            var __frame = self.frame
            __frame.size.height = newValue
            self.frame = __frame
        }
        get{
           return self.frame.size.height
        }
    }
    
    public var maxX : CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    public var maxY : CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
}


/*
 UIView 的layer设置
 */
extension UIView {
    public var association : NXViewAssociation? {
        set {
            objc_setAssociatedObject(self, &NXViewAssociation.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &NXViewAssociation.key) as? NXViewAssociation
        }
    }
    
    //
    public func setupEvent(_ event:UIControl.Event, action:NX.Event<UIControl.Event, UIView>?) {
        if self.association == nil {
            self.association = NXViewAssociation()
        }
        self.association?.addTarget(self, event:event, action: action)
    }
    
    //设置圆角
    public func setupCorner(rect:CGRect, corners:UIRectCorner, radii:CGSize) {
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        if let maskLayer = self.layer.mask as? CAShapeLayer {
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
        else {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    //设置边框+圆角
    public func setupBorder(color: UIColor, width: CGFloat, radius: CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    //设置阴影效果
    public func setupShadow(color: UIColor, offset: CGSize, radius: CGFloat){
        //设置阴影
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.15
        //设置圆角
        self.layer.cornerRadius = self.layer.shadowRadius
        self.layer.masksToBounds = false
    }
    
    //添加上下/左右的边缘分割线
    public func setupSeparator(color:UIColor, ats: NX.Ats, insets: UIEdgeInsets = UIEdgeInsets.zero, width:CGFloat = NX.pixel){
        let __color = color
        let __width = width
        
        if ats.contains(.minY) && ats.contains(.minX) && ats.contains(.maxY) && ats.contains(.maxX) {
            ///四周都添加分割线
            self.association?.separator?.isHidden = true
            self.setupBorder(color: __color, width: __width, radius: 0)
        }
        else if ats.isEmpty {
            ///无分割线
            self.association?.separator?.isHidden = true
        }
        else {
            ///只有一边添加分割线
            var separator = self.association?.separator
            if separator == nil {
                separator = CALayer()
                self.layer.addSublayer(separator!)
                if self.association == nil {
                    self.association = NXViewAssociation()
                }
                self.association?.separator = separator
            }
            separator?.isHidden = false
            separator?.backgroundColor = color.cgColor;

            if ats.contains(.minY) {
                separator?.frame = CGRect(x: insets.left, y: 0, width: self.width-insets.left-insets.right, height: width)
            }
            else if ats.contains(.minX) {
                separator?.frame = CGRect(x: 0, y: insets.top, width: __width, height: self.height-insets.top-insets.bottom)
            }
            else if ats.contains(.maxY) {
                separator?.frame = CGRect(x: insets.left, y: self.height-__width, width: self.width-insets.left-insets.right, height: __width)
            }
            else if ats.contains(.maxX) {
                separator?.frame = CGRect(x: self.width-__width, y: 0, width: __width, height: self.height-insets.top-insets.bottom)
            }
        }
    }
    
    
}



/*
 UIView 的功能
 */
extension UIView {
    /*
     *  获取当前view的viewcontroller
     */
    public var nextViewController : UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}


//添加虚线边框
extension UIView {
    public func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 3, lineSpacing: Int = 3, ats: NX.Ats) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = strokeColor.cgColor

        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        if ats.contains(.minX) {
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
        
        if ats.contains(.minY){
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
        }
        
        if ats.contains(.maxX){
            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
        }
        
        if ats.contains(.maxY){
            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
    
    ///画实线边框
    func drawLine(strokeColor: UIColor, lineWidth: CGFloat, ats: NX.Ats) {
        if ats.contains(.minY) && ats.contains(.minX) && ats.contains(.maxY) && ats.contains(.maxX) {
            self.layer.borderWidth = lineWidth
            self.layer.borderColor = strokeColor.cgColor
        }
        else {
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = self.bounds
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = lineWidth
            
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round

            let path = CGMutablePath()
            if ats.contains(.minX) {
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
            }
            
            if ats.contains(.minY){
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            }
            
            if ats.contains(.maxX){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            }
            
            if ats.contains(.maxY){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            }
            shapeLayer.path = path
            
            self.layer.addSublayer(shapeLayer)
        }
    }
}

extension UIControl.Event {
    public static var tap = UIControl.Event(rawValue: 100)//UITapGestureRecognizer
    public static var longPress = UIControl.Event(rawValue: 101)//UILongPressGestureRecognizer
    public static var pan = UIControl.Event(rawValue: 102)//UIPanGestureRecognizer
    public static var pinch = UIControl.Event(rawValue: 103)//UIPinchGestureRecognizer
    public static var rotation = UIControl.Event(rawValue: 104)//UIRotationGestureRecognizer
    public static var swipe = UIControl.Event(rawValue: 105)//UISwipeGestureRecognizer
}

extension UIControl {
    public class Target : NXAny {
        public weak var view : UIView?
        public var event = UIControl.Event.touchUpInside
        public var recognizer : UIGestureRecognizer?
        public var completion : NX.Event<UIControl.Event, UIView>?
        
        public init(view:UIView, event: UIControl.Event, completion: NX.Event<UIControl.Event, UIView>?) {
            self.view = view
            self.event = event
            self.completion = completion
        }
        
        public required init() {
            fatalError("init() has not been implemented")
        }
        
        @objc public func invoke(){
            if event.rawValue < UIControl.Event.tap.rawValue || event.rawValue > UIControl.Event.swipe.rawValue {
                if let __view = self.view as? UIControl {
                    self.completion?(self.event, __view)
                }
            }
            else {
                if let recognizer = self.recognizer, let __view = self.view  {
                    if recognizer.isKind(of: UILongPressGestureRecognizer.self) {
                        if recognizer.state == .began {
                            self.completion?(self.event, __view)
                        }
                    }
                    else {
                        self.completion?(self.event, __view)
                    }
                }
            }
        }
    }
}

public class NXViewAssociation {
    static var key = "key"
    open weak var separator : CALayer? = nil
    public private(set) var targets = [UIControl.Event.RawValue : UIControl.Target]()
    
    public func addTarget(_ targetView: UIView, event:UIControl.Event, action:NX.Event<UIControl.Event, UIView>?) {
        if let target = self.targets[event.rawValue] {
            target.completion = action
            return
        }
        
        let wrapped = UIControl.Target(view: targetView, event: event, completion: action)
        if event.rawValue < UIControl.Event.tap.rawValue || event.rawValue > UIControl.Event.swipe.rawValue {
            if let control = targetView as? UIControl {
                control.addTarget(wrapped, action: #selector(UIControl.Target.invoke), for: event)
                self.targets[event.rawValue] = wrapped
            }
        }
        else {
            if event == .tap {
                wrapped.recognizer = UITapGestureRecognizer()
            }
            else if event == .longPress {
                wrapped.recognizer = UILongPressGestureRecognizer()
            }
            else if event == .pan {
                wrapped.recognizer = UIPanGestureRecognizer()
            }
            else if event == .pinch {
                wrapped.recognizer = UIPinchGestureRecognizer()
            }
            else if event == .rotation {
                wrapped.recognizer = UIRotationGestureRecognizer()
            }
            else if event == .swipe {
                wrapped.recognizer = UISwipeGestureRecognizer()
            }
            
            if let __recognizer = wrapped.recognizer {
                __recognizer.addTarget(wrapped, action: #selector(UIControl.Target.invoke))
                targetView.addGestureRecognizer(__recognizer)
                targetView.isUserInteractionEnabled = true
                wrapped.recognizer = __recognizer
                self.targets[event.rawValue] = wrapped
            }
        }
    }
    
    public func removeTarget(_ targetView: UIView, _ event:UIControl.Event) {
        if let target = self.targets[event.rawValue] {
            if let recognizer = target.recognizer {
                targetView.removeGestureRecognizer(recognizer)
            }
            self.targets.removeValue(forKey: event.rawValue)
        }
    }
}

