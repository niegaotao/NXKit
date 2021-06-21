//
//  LEYOverlay.swift
//  NXFoundation
//
//  Created by firelonely on 2018/11/9.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

extension LEYOverlay {
    public enum Animation : String {
        case none = "none"
        
        case header = "header"   //从顶部进入->从顶部退出[在屏幕顶部显示]
        
        case drop = "drop"       //从上方淡入->从下方退出[在屏幕中间显示]
        case center = "center"   //从中间淡入->从中间淡出[在屏幕中间显示]
        case raise = "raise"     //从下方进入->从上方退出[在屏幕中间显示]

        case footer = "footer"   //从下方进入->从下方退出[在屏幕底部显示]
    }
    
    public static let frame = LEYApp.Rect { (_, __sender) in
        __sender.width = max(min(350.0, LEYDevice.width * 0.8), 300.0)
        __sender.x = (LEYDevice.width - __sender.width)/2.0
    }
    
    public static let inset = LEYApp.Rect { (_, __sender) in
        __sender.x = 20.0
        __sender.width = LEYOverlay.frame.width - __sender.x * 2.0
    }
}

extension LEYOverlay {
    public static var overlays = [LEYOverlay]()
    
    //展示出来一个弹框
    open class func push(_ overlay: LEYOverlay){
        LEYOverlay.overlays.append(overlay)
    }
    
    //移除一个弹框
    @discardableResult
    open class func pop(_ overlay: LEYOverlay?) -> LEYOverlay? {
        if LEYOverlay.overlays.count == 0 {
            return nil
        }
        
        if let __overlay = overlay {
            if let index = LEYOverlay.overlays.lastIndex(of: __overlay) {
                __overlay.removeFromSuperview()
                LEYOverlay.overlays.remove(at: index)
                return __overlay
            }
        }
        else{
            if let __overlay = LEYOverlay.overlays.last {
                __overlay.removeFromSuperview()
                LEYOverlay.overlays.removeLast()
                return __overlay
            }
        }
        return nil
    }
    
    //全部移除
    open class func removeAll() {
        LEYOverlay.overlays.forEach { (overlay) in
            overlay.removeFromSuperview()
        }
        LEYOverlay.overlays.removeAll()
    }
}

open class LEYOverlay: LEYBackgroundView<UIControl, UIView> {
    //关闭的回调, background,lhs,rhs,close,footer
    open var closeCompletion : LEYApp.Completion<String, Any?>? = nil
    
    //点击选项或者左右按钮消失的回调
    open var completion : LEYApp.Completion<String, Int>? = nil
    
    //弹框打开/关闭的动画
    open var animation = LEYOverlay.Animation.center.rawValue
    
    //创建基础的容器试图
    override open func setupSubviews() {
        super.setupSubviews()
        
        //这里用作设置背景色或者设置毛玻璃效果
        backgroundView.frame = self.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(backgroundView)
        
        //这里用作添加子控件
        contentView.frame = CGRect.zero
        self.addSubview(contentView)
    }

        
    //展示:先加window上(后期补一个小动画)
    open func open(animation: LEYOverlay.Animation.RawValue, completion: ((_ isCompleted: Bool) -> ())?){
        UIApplication.shared.keyWindow?.addSubview(self)
        if animation == LEYOverlay.Animation.center.rawValue {
            self.contentView.frame = CGRect(x: (self.w-self.contentView.w)/2.0, y: (self.h-self.contentView.h)/2.0, width: self.contentView.w, height: self.contentView.h)

            let fromValue : (frame:CGRect, alpha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame, 0.0, CGAffineTransform.identity.scaledBy(x: 1.08, y: 1.08))
            let toValue : (frame:CGRect, alpha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame, self.contentView.alpha, CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0))
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.001)
            self.contentView.transform = fromValue.transform
            self.contentView.alpha = fromValue.alpha
            
            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.contentView.transform = toValue.transform
                self.contentView.alpha = toValue.alpha
            }, completion: {(v) in
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.footer.rawValue {
            self.contentView.frame = CGRect(x: (self.w-self.contentView.w)/2.0, y: self.h-self.contentView.h, width: self.contentView.w, height: self.contentView.h)
            let toValue : (frame:CGRect, alpha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame, self.contentView.alpha, CGAffineTransform.identity)
            
            let fromValue : (frame:CGRect, alpha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame.offsetBy(dx: 0, dy: self.contentView.h), self.contentView.alpha, CGAffineTransform.identity)
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.001)
            self.contentView.alpha = fromValue.alpha
            self.contentView.frame = fromValue.frame
            
            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.contentView.alpha = toValue.alpha
                self.contentView.frame = toValue.frame
            }, completion: { (finished) in
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.header.rawValue {
            self.contentView.frame = CGRect(x: (self.w-self.contentView.w)/2.0, y: 0, width: self.contentView.w, height: self.contentView.h)
            let toValue : (frame:CGRect, alpha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame, self.contentView.alpha, CGAffineTransform.identity)
            
            let fromValue : (frame:CGRect, alpha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame.offsetBy(dx: 0, dy: -self.contentView.h), self.contentView.alpha, CGAffineTransform.identity)
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.001)
            self.contentView.alpha = fromValue.alpha
            self.contentView.frame = fromValue.frame
            
            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.contentView.alpha = toValue.alpha
                self.contentView.frame = toValue.frame
            }, completion: { (finished) in
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.drop.rawValue {
            self.contentView.frame = CGRect(x: (self.w-self.contentView.w)/2.0, y: (self.h-self.contentView.h)/2.0, width: self.contentView.w, height: self.contentView.h)
            let toValue : (frame:CGRect, aplha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame, self.contentView.alpha, CGAffineTransform.identity)
            
            let fromValue : (frame:CGRect, aplha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame.offsetBy(dx: 0, dy: -toValue.frame.maxY), self.contentView.alpha, CGAffineTransform.identity)
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.001)
            self.contentView.alpha = fromValue.aplha
            self.contentView.frame = fromValue.frame

            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.contentView.alpha = toValue.aplha
                self.contentView.frame = toValue.frame
            }, completion: {(completed) in
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.raise.rawValue {
            self.contentView.frame = CGRect(x: (self.w-self.contentView.w)/2.0, y: (self.h-self.contentView.h)/2.0, width: self.contentView.w, height: self.contentView.h)
            let toValue : (frame:CGRect, aplha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame, self.contentView.alpha, CGAffineTransform.identity)
            
            let fromValue : (frame:CGRect, aplha:CGFloat, transform:CGAffineTransform) = (self.contentView.frame.offsetBy(dx: 0, dy: toValue.frame.maxY), self.contentView.alpha, CGAffineTransform.identity)
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.001)
            self.contentView.alpha = fromValue.aplha
            self.contentView.frame = fromValue.frame

            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.contentView.alpha = toValue.aplha
                self.contentView.frame = toValue.frame
            }, completion: {(completed) in
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.none.rawValue {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            completion?(true)
        }
    }
    
    
    //移除：动画结束后才会回调
    open func close(animation: LEYOverlay.Animation.RawValue, completion:((_ isCompleted: Bool) -> ())?){
        if animation == LEYOverlay.Animation.center.rawValue {
            
            UIView.animate(withDuration: 0.27, animations: {
                self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.96, y: 0.96)
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.001)
                self.contentView.alpha = 0.0
            }, completion: { (completed) in
                self.removeFromSuperview()
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.footer.rawValue {
            let fromValue : (frame:CGRect, aplha:CGFloat) = (self.contentView.frame, self.contentView.alpha)
            let toValue : (frame:CGRect, aplha:CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: self.contentView.h), self.contentView.alpha)
            
            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.01)
                self.contentView.frame = toValue.frame
            }, completion: { (finished) in
                self.removeFromSuperview()
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.header.rawValue {
            let fromValue : (frame:CGRect, aplha:CGFloat) = (self.contentView.frame, self.contentView.alpha)
            let toValue : (frame:CGRect, aplha:CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: -self.contentView.h), self.contentView.alpha)
            
            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.01)
                self.contentView.frame = toValue.frame
            }, completion: { (finished) in
                self.removeFromSuperview()
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.drop.rawValue {
            let fromValue : (frame:CGRect, aplha:CGFloat) = (self.contentView.frame, self.contentView.alpha)
            let toValue : (frame:CGRect, aplha:CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: self.contentView.maxY), self.contentView.alpha)
            
            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.01)
                self.contentView.frame = toValue.frame
            }, completion: {(completed) in
                self.removeFromSuperview()
                completion?(true)
            })
        }
        else if animation == LEYOverlay.Animation.raise.rawValue {
            let fromValue : (frame:CGRect, aplha:CGFloat) = (self.contentView.frame, self.contentView.alpha)
            let toValue : (frame:CGRect, aplha:CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: -self.contentView.maxY), self.contentView.alpha)
            
            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.01)
                self.contentView.frame = toValue.frame
            }, completion: {(completed) in
                self.removeFromSuperview()
                completion?(true)
            })
        }
        else {
            self.removeFromSuperview()
            completion?(true)
        }
    }
    
    deinit {
        LEYApp.log { return ""}
    }
}
