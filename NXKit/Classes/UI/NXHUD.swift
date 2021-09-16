//
//  NXHUD.swift
//  NXKit
//
//  Created by niegaotao on 2021/1/12.
//

import UIKit

open class NXHUD {
    
    public enum Key : String {
        case toast = "toast"
        case loading = "loading"
    }
    
    open class Wrapped {
        open var key = NXHUD.Key.toast.rawValue
        
        open var insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        
        open var alpha : CGFloat = 1.0
        open var backgroundColor = UIColor.black.withAlphaComponent(0.8)
        open var shadowColor = NX.shadowColor.cgColor
        open var shadowOpacity : Float = 0.15
        open var shadowOffset = CGSize.zero
        
        open var ats = NX.Ats.center   //位置默认居中
        
        open var image : UIImage? = nil
        
        open var font = NX.font(14)
        open var textColor = UIColor.white        //文字颜色
        open var numberOfLines : Int = 0
        open var message = ""
        
        open var duration : TimeInterval = 2.0
        open var inoutDuration : TimeInterval = 0.2
        
        static var wrappedViewKey = "wrappedViewKey"
        
        init(completion:NX.Completion<String, NXHUD.Wrapped>?) {
            completion?("", self)
        }
    }
    
    open class WrappedView : NXView {
        open var stateView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        open var animationView = NX.UI.HUDAnimationClass.init(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
        open var messageView = UILabel(frame: CGRect.zero)
        
        public let wrapped = NXHUD.Wrapped { (_, __sender) in
            __sender.ats = .center
            __sender.textColor = UIColor.white
            __sender.insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        }
        
        open override func setupSubviews() {
            super.setupSubviews()

            self.layer.masksToBounds = false
            
            self.stateView.frame = CGRect(x: (self.bounds.size.width - 50)/2, y: (self.bounds.size.height - 50)/2, width: 50, height: 50)
            self.addSubview(self.stateView)
            
            self.animationView.frame = CGRect(x: (self.bounds.size.width - 50)/2, y: (self.bounds.size.height - 50)/2, width: 50, height: 50)
            self.addSubview(self.animationView)

            self.messageView.textAlignment = NSTextAlignment.center
            self.messageView.lineBreakMode = .byTruncatingTail;
            self.messageView.backgroundColor = UIColor.clear
            self.messageView.clipsToBounds = true
            self.addSubview(self.messageView)
        }
        
        open override func updateSubviews(_ action: String, _ value: Any?) {
            
            let state = NX.Wrappable<Int,CGRect, CGRect> { _, __sender in
                __sender.oldValue.size = CGSize(width: 0, height: 0)
                __sender.value.size = CGSize(width: 0, height: 0)
            }

            if let image = self.wrapped.image, image.size.width > 0 {
                state.oldValue.size.width = 50
                state.oldValue.size.height = 50
            }
            
            if self.wrapped.message.count > 0 {
                let __size = String.size(of: self.wrapped.message, size: CGSize(width: NXOverlay.frame.width-self.wrapped.insets.left-self.wrapped.insets.right-1, height: 200), font: self.wrapped.font) { (style) in
                    style.lineSpacing = 2.0
                }
                state.value.size.width = __size.width + 1
                state.value.size.height = __size.height + 1
            }
            
            var __frame = CGRect.zero
            if state.oldValue.size.height > 0 && state.value.size.height > 0 {
                __frame.size.width = self.wrapped.insets.left + max(state.oldValue.size.width, state.value.size.width) + self.wrapped.insets.right
                __frame.size.height = self.wrapped.insets.top + state.oldValue.size.height + 10.0 + state.value.size.height + self.wrapped.insets.bottom

                state.oldValue.origin.x = (__frame.size.width - state.oldValue.size.width)/2.0
                state.oldValue.origin.y = self.wrapped.insets.top
                
                state.value.origin.x = (__frame.size.width - state.value.size.width)/2.0
                state.value.origin.y = self.wrapped.insets.top + state.oldValue.size.height + 10.0
            }
            else if state.oldValue.size.height > 0 {
                __frame.size.width = self.wrapped.insets.left + state.oldValue.size.width + self.wrapped.insets.right
                __frame.size.height = self.wrapped.insets.top + state.oldValue.size.height + self.wrapped.insets.bottom

                state.oldValue.origin.x = (__frame.size.width - state.oldValue.size.width)/2.0
                state.oldValue.origin.y = self.wrapped.insets.top
            }
            else if state.value.size.height > 0 {
                __frame.size.width = self.wrapped.insets.left + state.value.size.width + self.wrapped.insets.right
                __frame.size.height = self.wrapped.insets.top + state.value.size.height + self.wrapped.insets.bottom
                
                state.value.origin.x = (__frame.size.width - state.value.size.width)/2.0
                state.value.origin.y = self.wrapped.insets.top
            }
            __frame.size.width = ceil(__frame.size.width)
            __frame.size.height = ceil(__frame.size.height)

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
            
            
            self.alpha = self.wrapped.alpha
            self.backgroundColor = self.wrapped.backgroundColor
            self.layer.shadowColor = self.wrapped.shadowColor
            self.layer.shadowOpacity = self.wrapped.shadowOpacity
            self.layer.shadowOffset = self.wrapped.shadowOffset
            self.layer.cornerRadius = 6.0 + min(round(max(__frame.size.height - 40, 0)/25.0), 4)
            self.layer.shadowRadius = 6.0 + min(round(max(__frame.size.height - 40, 0)/25.0), 4)
            
            if let image = self.wrapped.image {
                if self.wrapped.key == NXHUD.Key.toast.rawValue {
                    self.stateView.isHidden = false
                    self.stateView.image = image
                    self.stateView.frame = state.oldValue
                    
                    self.animationView.isHidden = true
                    self.animationView.stopAnimating()
                }
                else if self.wrapped.key == NXHUD.Key.loading.rawValue {
                    self.stateView.isHidden = true
                    
                    self.animationView.frame = state.oldValue
                    self.animationView.isHidden = false
                    self.animationView.contentView.image = image
                    self.animationView.startAnimating()
                }
            }
            else {
                self.stateView.isHidden = true
                
                self.animationView.isHidden = true
                self.animationView.stopAnimating()
            }
            
            if self.wrapped.message.count > 0 {
                self.messageView.isHidden = false
                self.messageView.textColor = self.wrapped.textColor
                self.messageView.font = self.wrapped.font
                self.messageView.numberOfLines = self.wrapped.numberOfLines
                self.messageView.attributedText = NXString.attributedString(self.wrapped.message, self.wrapped.font, self.wrapped.textColor, 2)
                self.messageView.textAlignment = .center
                self.messageView.frame = state.value
            }
            else {
                self.messageView.isHidden = true
            }
        }
        
        deinit {
            NX.print(NSStringFromClass(self.classForCoder))
        }
    }
}

extension NXHUD {
    @discardableResult
    open class func showSubview(key:String, image:UIImage?, message:String, ats:NX.Ats, duration:TimeInterval, superview:UIView) -> NXHUD.WrappedView? {
        if image == nil && message.count <= 0 {
            return nil
        }
        
        if key == NXHUD.Key.loading.rawValue {
            if let _ = objc_getAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey) as? NXHUD.WrappedView  {
                return nil
            }
        }
        let wrappedView = NXHUD.WrappedView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        superview.addSubview(wrappedView)
        wrappedView.wrapped.key = key
        wrappedView.wrapped.image = image
        wrappedView.wrapped.message = message
        wrappedView.wrapped.ats = ats
        wrappedView.wrapped.duration = duration
        wrappedView.updateSubviews("", nil)
        
        if key == NXHUD.Key.toast.rawValue {
            wrappedView.alpha = 0.0
            UIView.animate(withDuration: wrappedView.wrapped.inoutDuration,
                           delay: 0,
                           options: [.curveEaseInOut, .allowUserInteraction],
                           animations: {
                            wrappedView.alpha = wrappedView.wrapped.alpha
                           },
                           completion: { (isCompleted) in
                            NXHUD.closeSubview(subview: wrappedView, superview: nil)
                           })
        }
        else if key == NXHUD.Key.loading.rawValue {
            objc_setAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey, wrappedView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            wrappedView.alpha = 0.0
            UIView.animate(withDuration: wrappedView.wrapped.inoutDuration,
                           delay: 0.0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                            wrappedView.alpha = wrappedView.wrapped.alpha
            },
                           completion: nil)
        }
        return wrappedView
    }
    
    @discardableResult
    open class func closeSubview(subview:NXHUD.WrappedView?,  superview:UIView?) -> Bool{
        if let wrappedView = subview {
            UIView.animate(withDuration: wrappedView.wrapped.inoutDuration,
                           delay: wrappedView.wrapped.duration,
                           options: [.curveEaseInOut,.allowUserInteraction],
                           animations: {
                            wrappedView.alpha = 0.0},
                           completion: { (isCompleted) in
                            wrappedView.removeFromSuperview()
            })
            return true
        }
        else if let superview = superview, let wrapperView = objc_getAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey) as? NXHUD.WrappedView {
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
        return false
    }
}

extension UIView {
    
    @discardableResult
    open func makeToast(message: String, ats: NX.Ats = .maxY, duration: TimeInterval = 2.0) -> NXHUD.WrappedView? {
        return NXHUD.showSubview(key: NXHUD.Key.toast.rawValue, image: nil, message: message, ats: ats, duration: duration, superview: self)
    }

    @discardableResult
    open func makeLoading(message: String = "", ats: NX.Ats = .center) -> NXHUD.WrappedView? {
        return NXHUD.showSubview(key: NXHUD.Key.loading.rawValue, image: NX.image(named:"icon-animation.png"), message: message, ats: ats, duration: 0, superview: self)
    }

    @discardableResult
    open func hideLoading() -> Bool{
        return NXHUD.closeSubview(subview:nil, superview: self)
    }
}

