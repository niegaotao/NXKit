//
//  NXOverlay.swift
//  NXKit
//
//  Created by niegaotao on 2020/11/9.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

extension NXOverlay {
    public enum Animation : String {
        case none = "none"
        
        case header = "header"   //从顶部进入->从顶部退出[在屏幕顶部显示]
        
        case drop = "drop"       //从上方淡入->从下方退出[在屏幕中间显示]
        case center = "center"   //从中间淡入->从中间淡出[在屏幕中间显示]
        case raise = "raise"     //从下方进入->从上方退出[在屏幕中间显示]

        case footer = "footer"   //从下方进入->从下方退出[在屏幕底部显示]
    }
    
    public static let frame = NX.Rect { (_, __sender) in
        __sender.width = max(min(350.0, NXDevice.width * 0.8), 300.0)
        __sender.x = (NXDevice.width - __sender.width)/2.0
    }
    
    public static let inset = NX.Rect { (_, __sender) in
        __sender.x = 20.0
        __sender.width = NXOverlay.frame.width - __sender.x * 2.0
    }
}

extension NXOverlay {
    public static var overlays = NSHashTable<NXOverlay>(options:[.weakMemory], capacity: 2)
    
    //加入一个弹框
    open class func push(_ overlay: NXOverlay){
        NXOverlay.overlays.add(overlay)
    }
    
    //移除一个弹框
    @discardableResult
    open class func pop(_ overlay: NXOverlay?) -> NXOverlay? {
        if let __overlay = overlay, NXOverlay.overlays.contains(__overlay) {
            __overlay.removeFromSuperview()
            NXOverlay.overlays.remove(__overlay)
            return __overlay
        }
        return nil
    }
}

open class NXOverlay: NXBackgroundView<UIControl, UIView> {
    //关闭的回调, background,lhs,rhs,close,footer
    open var closeCompletion : NX.Completion<String, Any?>? = nil
    
    //点击选项或者左右按钮消失的回调
    open var completion : NX.Completion<String, Int>? = nil
    
    //弹框打开/关闭的动画
    open var animation = NXOverlay.Animation.center.rawValue
    
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
    open func open(animation: NXOverlay.Animation.RawValue, completion: ((_ isCompleted: Bool) -> ())?){
        UIApplication.shared.keyWindow?.addSubview(self)
        if animation == NXOverlay.Animation.center.rawValue {
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
        else if animation == NXOverlay.Animation.footer.rawValue {
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
        else if animation == NXOverlay.Animation.header.rawValue {
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
        else if animation == NXOverlay.Animation.drop.rawValue {
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
        else if animation == NXOverlay.Animation.raise.rawValue {
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
        else if animation == NXOverlay.Animation.none.rawValue {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            completion?(true)
        }
    }
    
    
    //移除：动画结束后才会回调
    open func close(animation: NXOverlay.Animation.RawValue, completion:((_ isCompleted: Bool) -> ())?){
        if animation == NXOverlay.Animation.center.rawValue {
            
            UIView.animate(withDuration: 0.27, animations: {
                self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.96, y: 0.96)
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.001)
                self.contentView.alpha = 0.0
            }, completion: { (completed) in
                self.removeFromSuperview()
                completion?(true)
            })
        }
        else if animation == NXOverlay.Animation.footer.rawValue {
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
        else if animation == NXOverlay.Animation.header.rawValue {
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
        else if animation == NXOverlay.Animation.drop.rawValue {
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
        else if animation == NXOverlay.Animation.raise.rawValue {
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
        NX.log { return ""}
    }
}
