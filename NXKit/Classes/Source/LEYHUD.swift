//
//  LEYHUD.swift
//  NXFoundation
//
//  Created by firelonely on 2021/1/12.
//

import UIKit

open class LEYHUD {

}

extension LEYHUD {
    
    open class Wrapped {
        open var insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        
        open var alpha : CGFloat = 1.0
        open var backgroundColor = UIColor.white
        
        open var cornerRadius : CGFloat = 6.0
        open var shadowRadius : CGFloat = 6.0
        open var shadowColor = LEYApp.shadowColor.cgColor
        open var shadowOpacity : Float = 0.15
        open var shadowOffset = CGSize.zero
        
        open var at = LEYApp.AT.center   //位置默认居中
        
        open var font = LEYApp.font(14)
        open var textColor = UIColor.white        //文字颜色
        open var numberOfLines : Int = 0
        open var text = ""
        
        open var duration : TimeInterval = 2.0
        open var inoutDuration : TimeInterval = 0.2
        
        open var size = CGSize(width: 100.0, height: 100.0)//最小大小
        static var wrappedViewKey = "wrappedViewKey"
        
        init(completion:LEYApp.Completion<String, LEYHUD.Wrapped>?) {
            completion?("", self)
        }
    }
    
    open class WrappedView : LEYView {
        deinit {
            LEYApp.log{""}
        }
    }
}

extension LEYHUD {
    
    open class ToastView : LEYHUD.WrappedView {
        public let wrapped = LEYHUD.Wrapped { (_, __sender) in
            __sender.at = .maxY
            __sender.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            __sender.textColor = UIColor.white
            __sender.insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            __sender.size = CGSize(width: 120.0, height: 42.0)
        }
        open var descriptionView = UILabel(frame: CGRect.zero)
        
        open override func setupSubviews() {
            super.setupSubviews()

            self.layer.masksToBounds = false

            self.descriptionView.textAlignment = NSTextAlignment.center
            self.descriptionView.lineBreakMode = .byTruncatingTail;
            self.descriptionView.backgroundColor = UIColor.clear
            self.descriptionView.clipsToBounds = true
            self.addSubview(self.descriptionView)
        }
        
        open func update(description:String) {
            self.wrapped.text = description
            self.updateSubviews("", nil)
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
            var __size = String.size(of: self.wrapped.text, size: CGSize(width: LEYOverlay.frame.width-self.wrapped.insets.left-self.wrapped.insets.right, height: 200), font: self.wrapped.font) { (style) in
                style.lineSpacing = 2.0
            }
            __size.width = __size.width + 1
            __size.height = __size.height + 1

            var __frame = CGRect(x: 0, y: 0, width: __size.width + self.wrapped.insets.left + self.wrapped.insets.right, height: __size.height + self.wrapped.insets.top + self.wrapped.insets.bottom)
            var __super = CGSize(width: LEYDevice.width, height: LEYDevice.height)
            if let __superview = self.superview {
                __super = __superview.frame.size
            }
            __frame.origin.x = (__super.width -  __frame.size.width)/2.0
            if wrapped.at == .minY {
                __frame.origin.y = __super.height * 0.20 - __frame.size.height/2.0
            }
            else if wrapped.at == .center {
                __frame.origin.y = __super.height * 0.5 - __frame.size.height/2.0
            }
            else if wrapped.at == .maxY {
                __frame.origin.y = __super.height * 0.78 - __frame.size.height/2.0
            }
            self.frame = __frame
            
            self.descriptionView.textColor = self.wrapped.textColor
            self.descriptionView.font = self.wrapped.font
            self.descriptionView.numberOfLines = self.wrapped.numberOfLines
            self.descriptionView.attributedText = LEYString.attributedString(self.wrapped.text, self.wrapped.font, self.wrapped.textColor, 2)
            self.descriptionView.frame = CGRect(x: self.wrapped.insets.left, y: self.wrapped.insets.top, width: __size.width , height: __size.height)
        }
    }
    
    
    @discardableResult
    open class func makeToast(message: String, at: LEYApp.AT, duration: TimeInterval, superview:UIView) -> LEYHUD.ToastView? {
        if message.count > 0 {
            let wrapperView = LEYHUD.ToastView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
            superview.addSubview(wrapperView)
            
            wrapperView.wrapped.at = at
            wrapperView.wrapped.duration = duration
            wrapperView.update(description: message)
                        
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

extension LEYHUD {
    
    open class ProgressView : LEYHUD.WrappedView {
        public let wrapped = LEYHUD.Wrapped { (_, __sender) in
            __sender.at = .center
            __sender.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            __sender.textColor = UIColor.white
            __sender.insets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
            __sender.size = CGSize(width: 140.0, height: 92.0)
        }
        
        open var animationView = LEYApp.Animation.animationClass.init(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        open var descriptionView = UILabel(frame: CGRect.zero)
        
        open override func setupSubviews() {
            super.setupSubviews()
            
            self.layer.masksToBounds = false

            self.animationView.frame = CGRect(x: (self.bounds.size.width - 44)/2, y: (self.bounds.size.height - 44)/2, width: 44, height: 44)
            self.addSubview(self.animationView)
          
            self.descriptionView.textAlignment = .center
            self.descriptionView.lineBreakMode = .byTruncatingTail
            self.descriptionView.backgroundColor = UIColor.clear
            self.descriptionView.clipsToBounds = true
            self.addSubview(self.descriptionView)
        }
        
        open func update(description:String) {
            self.wrapped.text = description
            self.updateSubviews("", nil)
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
                var __size = String.size(of: self.wrapped.text, size: CGSize(width: LEYOverlay.frame.width-self.wrapped.insets.left-self.wrapped.insets.right, height: 200), font: self.wrapped.font) { (style) in
                    style.lineSpacing = 2.0
                }
                __size.width = max(self.wrapped.size.width - self.wrapped.insets.left - self.wrapped.insets.right, __size.width + 1)
                __size.height = max(20, __size.height + 1)
               
                var __frame = CGRect(x: 0, y: 0, width: __size.width+self.wrapped.insets.left+self.wrapped.insets.right, height: self.wrapped.insets.top+44+10+__size.height+self.wrapped.insets.bottom)
                var __super = CGSize(width:LEYDevice.width, height:LEYDevice.height)
                if let __superview = self.superview {
                    __super = __superview.frame.size
                }
                __frame.origin.x = (__super.width -  __frame.size.width)/2.0
                if wrapped.at == .minY {
                    __frame.origin.y = __super.height * 0.20 - __frame.size.height/2.0
                }
                else if wrapped.at == .center {
                    __frame.origin.y = __super.height * 0.5 - __frame.size.height/2.0
                }
                else if wrapped.at == .maxY {
                    __frame.origin.y = __super.height * 0.78 - __frame.size.height/2.0
                }
                self.frame = __frame
                
                
                self.animationView.frame = CGRect(x: (__frame.size.width-44)/2, y: self.wrapped.insets.top, width: 44, height: 44)
               
                self.descriptionView.isHidden = false
                self.descriptionView.textColor = self.wrapped.textColor
                self.descriptionView.font = self.wrapped.font
                self.descriptionView.numberOfLines = self.wrapped.numberOfLines
                self.descriptionView.attributedText = LEYString.attributedString(self.wrapped.text, self.wrapped.font, self.wrapped.textColor, 2)
                self.descriptionView.textAlignment = .center
                self.descriptionView.frame = CGRect(x: self.wrapped.insets.left, y: self.wrapped.insets.top+44+10, width: __size.width, height: __size.height)
            }
            else {
                //不需要展示loading的文字
                var __frame = CGRect(x: 0, y: 0, width: self.wrapped.size.width, height: self.wrapped.size.width)
                var __super = CGSize(width:LEYDevice.width, height:LEYDevice.height)
                if let __superview = self.superview {
                    __super = __superview.frame.size
                }
                __frame.origin.x = (__super.width -  __frame.size.width)/2.0
                if wrapped.at == .minY {
                    __frame.origin.y = __super.height * 0.20 - __frame.size.height/2.0
                }
                else if wrapped.at == .center {
                    __frame.origin.y = __super.height * 0.5 - __frame.size.height/2.0
                }
                else if wrapped.at == .maxY {
                    __frame.origin.y = __super.height * 0.78 - __frame.size.height/2.0
                }
                self.frame = __frame
                
                self.animationView.frame = CGRect(x: (__frame.size.width-44)/2, y: (__frame.size.height-44)/2, width: 44, height: 44)
                
                self.descriptionView.isHidden = true
                self.descriptionView.text = ""
            }
        }
    }
    
    @discardableResult
    open class func makeProgress(message: String, at: LEYApp.AT, superview:UIView) -> LEYHUD.ProgressView? {
        if let _ = objc_getAssociatedObject(superview, &LEYHUD.Wrapped.wrappedViewKey) as? LEYHUD.ProgressView  {
            return nil
        }

        let wrapperView = LEYHUD.ProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        superview.addSubview(wrapperView)
        objc_setAssociatedObject(superview, &LEYHUD.Wrapped.wrappedViewKey, wrapperView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        wrapperView.wrapped.at = at
        
        wrapperView.animationView.frame = CGRect(x: (wrapperView.bounds.size.width - 44)/2, y: (wrapperView.bounds.size.height - 44)/2, width: 44, height: 44)
        wrapperView.animationView.startAnimating()
        wrapperView.update(description: message)
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
    open class func hideProgress(superview:UIView) -> Bool{
        guard let wrapperView = objc_getAssociatedObject(superview, &LEYHUD.Wrapped.wrappedViewKey) as? LEYHUD.ProgressView else {
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
                        objc_setAssociatedObject(superview, &LEYHUD.Wrapped.wrappedViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            })
        return true
    }
}

extension UIView {
    
    @discardableResult
    open func ex_makeToast(message: String, at: LEYApp.AT = .maxY, duration: TimeInterval = 2.0) -> LEYHUD.ToastView? {
        return LEYHUD.makeToast(message: message, at: at, duration: duration, superview: self)
    }

    @discardableResult
    open func ex_makeProgress(message: String = "", at: LEYApp.AT = .center) -> LEYHUD.ProgressView? {
        return LEYHUD.makeProgress(message: message, at: at, superview: self)
    }

    @discardableResult
    open func ex_hideProgress() -> Bool{
        return LEYHUD.hideProgress(superview: self)
    }
}

