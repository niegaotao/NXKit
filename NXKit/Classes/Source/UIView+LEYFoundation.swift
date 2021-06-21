//
//  UIView+LEYFoundation.swift
//  NXFoundation
//
//  Created by firelonely on 2018/5/19.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

/*
 UIView 的大小属性
 */
extension UIView {
    open var x : CGFloat {
        set(x){
            var __frame = self.frame
            __frame.origin.x = x
            self.frame = __frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    open var y : CGFloat {
        set(y){
            var __frame = self.frame
            __frame.origin.y = y
            self.frame = __frame
        }
        get{
           return self.frame.origin.y
        }
    }
    
    open var w : CGFloat {
        set(w){
            var __frame = self.frame
            __frame.size.width = w
            self.frame = __frame
        }
        get{
            return self.frame.size.width
        }
    }
    
    open var h : CGFloat {
        set(h){
            var __frame = self.frame
            __frame.size.height = h
            self.frame = __frame
        }
        get{
           return self.frame.size.height
        }
    }
    
    open var maxX : CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    open var maxY : CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
}

//是否显示动画，只要是用来关闭layer的隐式动画
extension UIView {
    
    /// 执行的操作是否需要动画
    ///
    /// - Parameters:
    ///   - animation: true：显示动画，false关闭动画
    ///   - action: 执行的操作
    ///   - completion: 完成后的回调
    class func animations(_ animation: Bool, action: (()->()), completion: @escaping (()->())) {
        CATransaction.begin()
        CATransaction.setDisableActions(!animation)
        CATransaction.setCompletionBlock({
            completion()
        })
        action()
        CATransaction.commit()
    }
}


/*
 UIView 的layer设置
 */
extension UIView {
    open var proxy : LEYViewProxy? {
        set(newValue) {
            objc_setAssociatedObject(self, &LEYViewProxy.proxy, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &LEYViewProxy.proxy) as? LEYViewProxy
        }
    }
    
    //
    open func setupEvent(_ event:UIControl.Event, action:((_ event:UIControl.Event, _ sender:UIView) -> ())?) {
        self.setupEvents([event], action: action)
    }
    
    open func setupEvents(_ events:[UIControl.Event], action:((_ event:UIControl.Event, _ sender:UIView) -> ())?) {
        if self.proxy == nil {
            self.proxy = LEYViewProxy()
            self.proxy?.sender = self
        }
        self.proxy?.update(self, events, action: action)
    }
    
    //设置圆角
    public func addCorner(rect:CGRect, corners:UIRectCorner, radii:CGSize) {
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
    public func setupBorder(color: UIColor?, width: CGFloat?, radius: CGFloat = 6.0){
        if(color != nil && width != nil) {
            self.layer.borderColor = color!.cgColor
            self.layer.borderWidth = width!
        }
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    //添加上下/左右的边缘分割线
    public func addBorder(color: UIColor?, side: LEYApp.Side, insets: UIEdgeInsets = UIEdgeInsets.zero){
        self.setupSeparator(color: color, side: side, insets: insets)
    }
    
    public func setupSeparator(color:UIColor?, side: LEYApp.Side, insets: UIEdgeInsets = UIEdgeInsets.zero){
        let color = color ?? LEYApp.separatorColor
        
        
        if side.contains(.top) && side.contains(.left) && side.contains(.bottom) && side.contains(.right) {
            ///四周都添加分割线
            self.proxy?.separator?.isHidden = true
            self.setupBorder(color: color, width: LEYDevice.pixel, radius: 0)
        }
        else if side.isEmpty {
            ///无分割线
            self.proxy?.separator?.isHidden = true
        }
        else {
            ///只有一边添加分割线
            var separator = self.proxy?.separator
            if separator == nil {
                separator = CALayer()
                self.layer.addSublayer(separator!)
                if proxy == nil {
                    self.proxy = LEYViewProxy()
                    self.proxy?.sender = self
                }
                self.proxy?.separator = separator
            }
            separator?.isHidden = false
            separator?.backgroundColor = color.cgColor;

            if side.contains(.top) {
                separator?.frame = CGRect(x: insets.left, y: 0, width: self.w-insets.left-insets.right, height: LEYDevice.pixel)
            }
            else if side.contains(.left) {
                separator?.frame = CGRect(x: 0, y: insets.top, width: LEYDevice.pixel, height: self.h-insets.top-insets.bottom)
            }
            else if side.contains(.bottom) {
                separator?.frame = CGRect(x: insets.left, y: self.h-LEYDevice.pixel, width: self.w-insets.left-insets.right, height: LEYDevice.pixel)
            }
            else if side.contains(.right) {
                separator?.frame = CGRect(x: self.w-LEYDevice.pixel, y: 0, width: LEYDevice.pixel, height: self.h-insets.top-insets.bottom)
            }
        }
    }
    
    //设置阴影效果
    public func setShadow(color: UIColor?, offset: CGSize, radius: CGFloat = 6.0){
        let color = color ?? LEYApp.shadowColor
        
        //设置阴影
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.15
        //设置圆角
        self.layer.cornerRadius = self.layer.shadowRadius
        self.layer.masksToBounds = false
    }
}



/*
 UIView 的功能
 */
extension UIView {
    /*
     *  获取当前view的viewcontroller
     */
    open var superviewController : UIViewController? {
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
    public func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 3, lineSpacing: Int = 3, side: LEYApp.Side) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = strokeColor.cgColor

        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        if side.contains(.left) {
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
        
        if side.contains(.top){
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
        }
        
        if side.contains(.right){
            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
        }
        
        if side.contains(.bottom){
            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
    
    ///画实线边框
    func drawLine(strokeColor: UIColor, lineWidth: CGFloat, side: LEYApp.Side) {
        if side.contains(.top) && side.contains(.left) && side.contains(.bottom) && side.contains(.right) {
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
            if side.contains(.left) {
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
            }
            
            if side.contains(.top){
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            }
            
            if side.contains(.right){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            }
            
            if side.contains(.bottom){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            }
            shapeLayer.path = path
            
            self.layer.addSublayer(shapeLayer)
        }
    }
}

public enum LEYViewShakeDirection {
    case horizontal, vertical
}
