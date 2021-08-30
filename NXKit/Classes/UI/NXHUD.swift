//
//  NXHUD.swift
//  NXKit
//
//  Created by niegaotao on 2021/1/12.
//

import UIKit

open class NXHUD {
    
    open class Wrapped {
        open var insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        
        open var alpha : CGFloat = 1.0
        open var backgroundColor = UIColor.white
        
        open var cornerRadius : CGFloat = 6.0
        open var shadowRadius : CGFloat = 6.0
        open var shadowColor = NX.shadowColor.cgColor
        open var shadowOpacity : Float = 0.15
        open var shadowOffset = CGSize.zero
        
        open var ats = NX.Ats.center   //位置默认居中
        
        open var font = NX.font(14)
        open var textColor = UIColor.white        //文字颜色
        open var numberOfLines : Int = 0
        open var text = ""
        
        open var duration : TimeInterval = 2.0
        open var inoutDuration : TimeInterval = 0.2
        
        open var size = CGSize(width: 100.0, height: 100.0)//最小大小
        static var wrappedViewKey = "wrappedViewKey"
        
        init(completion:NX.Completion<String, NXHUD.Wrapped>?) {
            completion?("", self)
        }
    }
    
    open class WrappedView : NXView {
        deinit {
            NX.log{""}
        }
    }
}

extension NXHUD {
    
    open class ToastView : NXHUD.WrappedView {
        public let wrapped = NXHUD.Wrapped { (_, __sender) in
            __sender.ats = .maxY
            __sender.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            __sender.textColor = UIColor.white
            __sender.insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            __sender.size = CGSize(width: 120.0, height: 42.0)
        }
        open var messageView = UILabel(frame: CGRect.zero)
        
        open override func setupSubviews() {
            super.setupSubviews()

            self.layer.masksToBounds = false

            self.messageView.textAlignment = NSTextAlignment.center
            self.messageView.lineBreakMode = .byTruncatingTail;
            self.messageView.backgroundColor = UIColor.clear
            self.messageView.clipsToBounds = true
            self.addSubview(self.messageView)
        }
        
        open override func updateSubviews(_ action: String, _ value: Any?) {
            self.alpha = self.wrapped.alpha
            self.backgroundColor = self.wrapped.backgroundColor
            self.layer.cornerRadius = self.wrapped.cornerRadius
            self.layer.shadowRadius = self.wrapped.shadowRadius
            self.layer.shadowColor = self.wrapped.shadowColor
            self.layer.shadowOpacity = self.wrapped.shadowOpacity
            self.layer.shadowOffset = self.wrapped.shadowOffset
            
            //16.17
            var __size = String.size(of: self.wrapped.text, size: CGSize(width: NXOverlay.frame.width-self.wrapped.insets.left-self.wrapped.insets.right, height: 200), font: self.wrapped.font) { (style) in
                style.lineSpacing = 2.0
            }
            __size.width = __size.width + 1
            __size.height = __size.height + 1

            var __frame = CGRect(x: 0, y: 0, width: __size.width + self.wrapped.insets.left + self.wrapped.insets.right, height: __size.height + self.wrapped.insets.top + self.wrapped.insets.bottom)
            var __super = CGSize(width: NXDevice.width, height: NXDevice.height)
            if let __superview = self.superview {
                __super = __superview.frame.size
            }
            __frame.origin.x = (__super.width -  __frame.size.width)/2.0
            if wrapped.ats == .minY {
                __frame.origin.y = __super.height * 0.20 - __frame.size.height/2.0
            }
            else if wrapped.ats == .center {
                __frame.origin.y = __super.height * 0.5 - __frame.size.height/2.0
            }
            else if wrapped.ats == .maxY {
                __frame.origin.y = __super.height * 0.78 - __frame.size.height/2.0
            }
            self.frame = __frame
            
            self.messageView.textColor = self.wrapped.textColor
            self.messageView.font = self.wrapped.font
            self.messageView.numberOfLines = self.wrapped.numberOfLines
            self.messageView.attributedText = NXString.attributedString(self.wrapped.text, self.wrapped.font, self.wrapped.textColor, 2)
            self.messageView.frame = CGRect(x: self.wrapped.insets.left, y: self.wrapped.insets.top, width: __size.width , height: __size.height)
        }
    }
    
    
    @discardableResult
    open class func makeToast(message: String, ats: NX.Ats, duration: TimeInterval, superview:UIView) -> NXHUD.ToastView? {
        if message.count > 0 {
            let wrapperView = NXHUD.ToastView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
            superview.addSubview(wrapperView)
            
            wrapperView.wrapped.ats = ats
            wrapperView.wrapped.duration = duration
            wrapperView.wrapped.text = message
            wrapperView.updateSubviews("", nil)
                        
            UIView.animate(withDuration: wrapperView.wrapped.inoutDuration,
                           delay: 0,
                           options: [.curveEaseInOut,.allowUserInteraction],
                           animations: {
                            wrapperView.alpha = wrapperView.wrapped.alpha
                           },
                           completion:  { (_) in
                            
                            UIView.animate(withDuration: wrapperView.wrapped.inoutDuration,
                                           delay: wrapperView.wrapped.duration,
                                           options: [.curveEaseInOut,.allowUserInteraction],
                                           animations: {
                                            wrapperView.alpha = 0.0},
                                           completion: { (isCompleted) in
                                            wrapperView.removeFromSuperview()
                            })
            })
            return wrapperView
        }
        return nil
    }
}

extension NXHUD {
    
    open class LoadingView : NXHUD.WrappedView {
        public let wrapped = NXHUD.Wrapped { (_, __sender) in
            __sender.ats = .center
            __sender.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            __sender.textColor = UIColor.white
            __sender.insets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
            __sender.size = CGSize(width: 140.0, height: 92.0)
            __sender.cornerRadius = 9.0
            __sender.shadowRadius = 9.0
        }
        
        open var animationView = NX.UI.AnimationClass.init(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        open var messageView = UILabel(frame: CGRect.zero)
        
        open override func setupSubviews() {
            super.setupSubviews()
            
            self.layer.masksToBounds = false

            
            self.animationView.frame = CGRect(x: (self.bounds.size.width - 50)/2, y: (self.bounds.size.height - 50)/2, width: 50, height: 50)
            self.addSubview(self.animationView)
          
            self.messageView.textAlignment = .center
            self.messageView.lineBreakMode = .byTruncatingTail
            self.messageView.backgroundColor = UIColor.clear
            self.messageView.clipsToBounds = true
            self.addSubview(self.messageView)
        }
        
        open override func updateSubviews(_ action: String, _ value: Any?) {
            self.alpha = self.wrapped.alpha
            self.backgroundColor = self.wrapped.backgroundColor
            
            self.layer.cornerRadius = self.wrapped.cornerRadius
            self.layer.shadowRadius = self.wrapped.shadowRadius
            self.layer.shadowColor = self.wrapped.shadowColor
            self.layer.shadowOpacity = self.wrapped.shadowOpacity
            self.layer.shadowOffset = self.wrapped.shadowOffset
            
            
            
            if self.wrapped.text.count > 0 {
                var __size = String.size(of: self.wrapped.text, size: CGSize(width: NXOverlay.frame.width-self.wrapped.insets.left-self.wrapped.insets.right, height: 200), font: self.wrapped.font) { (style) in
                    style.lineSpacing = 2.0
                }
                __size.width = max(self.wrapped.size.width - self.wrapped.insets.left - self.wrapped.insets.right, __size.width + 1)
                __size.height = max(20, __size.height + 1)
               
                var __frame = CGRect(x: 0, y: 0, width: __size.width+self.wrapped.insets.left+self.wrapped.insets.right, height: self.wrapped.insets.top+self.animationView.frame.size.height+10+__size.height+self.wrapped.insets.bottom)
                var __super = CGSize(width:NXDevice.width, height:NXDevice.height)
                if let __superview = self.superview {
                    __super = __superview.frame.size
                }
                __frame.origin.x = (__super.width -  __frame.size.width)/2.0
                if wrapped.ats == .minY {
                    __frame.origin.y = __super.height * 0.20 - __frame.size.height/2.0
                }
                else if wrapped.ats == .center {
                    __frame.origin.y = __super.height * 0.5 - __frame.size.height/2.0
                }
                else if wrapped.ats == .maxY {
                    __frame.origin.y = __super.height * 0.78 - __frame.size.height/2.0
                }
                self.frame = __frame
                
                
                self.animationView.frame = CGRect(origin: CGPoint(x: (__frame.size.width-self.animationView.frame.size.width)/2, y: self.wrapped.insets.top), size: self.animationView.frame.size)

                self.messageView.isHidden = false
                self.messageView.textColor = self.wrapped.textColor
                self.messageView.font = self.wrapped.font
                self.messageView.numberOfLines = self.wrapped.numberOfLines
                self.messageView.attributedText = NXString.attributedString(self.wrapped.text, self.wrapped.font, self.wrapped.textColor, 2)
                self.messageView.textAlignment = .center
                self.messageView.frame = CGRect(x: self.wrapped.insets.left, y: self.wrapped.insets.top+self.animationView.frame.size.height+10, width: __size.width, height: __size.height)
            }
            else {
                //不需要展示loading的文字
                var __frame = CGRect(x: 0, y: 0, width: self.wrapped.insets.left + self.animationView.frame.size.width + self.wrapped.insets.right, height: self.wrapped.insets.top + self.animationView.frame.size.height + self.wrapped.insets.bottom)
                var __super = CGSize(width:NXDevice.width, height:NXDevice.height)
                if let __superview = self.superview {
                    __super = __superview.frame.size
                }
                __frame.origin.x = (__super.width -  __frame.size.width)/2.0
                if wrapped.ats == .minY {
                    __frame.origin.y = __super.height * 0.20 - __frame.size.height/2.0
                }
                else if wrapped.ats == .center {
                    __frame.origin.y = __super.height * 0.5 - __frame.size.height/2.0
                }
                else if wrapped.ats == .maxY {
                    __frame.origin.y = __super.height * 0.78 - __frame.size.height/2.0
                }
                self.frame = __frame
                
                self.animationView.frame = CGRect(origin: CGPoint(x: (__frame.size.width-self.animationView.frame.size.width)/2, y: self.wrapped.insets.top), size: self.animationView.frame.size)
                
                self.messageView.isHidden = true
                self.messageView.text = ""
            }
        }
    }
    
    @discardableResult
    open class func makeLoading(message: String, ats: NX.Ats, superview:UIView) -> NXHUD.LoadingView? {
        if let _ = objc_getAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey) as? NXHUD.LoadingView  {
            return nil
        }

        let wrapperView = NXHUD.LoadingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        superview.addSubview(wrapperView)
        objc_setAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey, wrapperView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        wrapperView.wrapped.ats = ats
        
        wrapperView.animationView.frame = CGRect(x: (wrapperView.bounds.size.width - 50)/2, y: (wrapperView.bounds.size.height - 50)/2, width: 50, height: 50)
        wrapperView.animationView.startAnimating()
        wrapperView.wrapped.text = message
        wrapperView.updateSubviews("", nil)
        wrapperView.alpha = 0.0

        UIView.animate(withDuration: wrapperView.wrapped.inoutDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        wrapperView.alpha = wrapperView.wrapped.alpha
        },
                       completion: nil)
        return wrapperView
    }
    
    @discardableResult
    open class func hideLoading(superview:UIView) -> Bool{
        guard let wrapperView = objc_getAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey) as? NXHUD.LoadingView else {
            return false
        }
        UIView.animate(withDuration: wrapperView.wrapped.inoutDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        wrapperView.alpha = 0.0
                    },
                       completion: { (finished: Bool) in
                        wrapperView.removeFromSuperview()
                        objc_setAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            })
        return true
    }
}

extension UIView {
    
    @discardableResult
    open func makeToast(message: String, ats: NX.Ats = .maxY, duration: TimeInterval = 2.0) -> NXHUD.ToastView? {
        return NXHUD.makeToast(message: message, ats: ats, duration: duration, superview: self)
    }

    @discardableResult
    open func makeLoading(message: String = "", ats: NX.Ats = .center) -> NXHUD.LoadingView? {
        return NXHUD.makeLoading(message: message, ats: ats, superview: self)
    }

    @discardableResult
    open func hideLoading() -> Bool{
        return NXHUD.hideLoading(superview: self)
    }
}

