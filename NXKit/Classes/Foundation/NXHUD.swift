//
//  NXHUD.swift
//  NXKit
//
//  Created by niegaotao on 2020/1/12.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXHUD {
    public enum Key: String {
        case toast
        case loading
    }

    open class Wrapped {
        open var key = NXHUD.Key.toast.rawValue

        open var insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)

        open var alpha: CGFloat = 1.0
        open var backgroundColor = UIColor.black.withAlphaComponent(0.8)
        open var shadowColor = NXKit.shadowColor.cgColor
        open var shadowOpacity: Float = 0.15
        open var shadowOffset = CGSize.zero

        open var ats = NXKit.Ats.center // 位置默认居中

        open var image: UIImage?

        open var font = NXKit.font(14)
        open var textColor = UIColor.white // 文字颜色
        open var numberOfLines: Int = 0
        open var message = ""

        open var duration: TimeInterval = 2.0
        open var inoutDuration: TimeInterval = 0.2

        static var wrappedViewKey = "wrappedViewKey"

        init(completion: NXKit.Event<String, NXHUD.Wrapped>?) {
            completion?("", self)
        }
    }

    open class WrappedView: NXView {
        open var stateView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        open var animationView = NXAnimationWrappedView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        open var messageView = UILabel(frame: CGRect.zero)

        public let ctxs = NXHUD.Wrapped { _, __sender in
            __sender.ats = .center
            __sender.textColor = UIColor.white
            __sender.insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        }

        override open func setupSubviews() {
            super.setupSubviews()

            layer.masksToBounds = false

            stateView.frame = CGRect(x: (bounds.size.width - 50) / 2, y: (bounds.size.height - 50) / 2, width: 50, height: 50)
            addSubview(stateView)

            animationView.frame = CGRect(x: (bounds.size.width - 50) / 2, y: (bounds.size.height - 50) / 2, width: 50, height: 50)
            addSubview(animationView)

            messageView.textAlignment = NSTextAlignment.center
            messageView.lineBreakMode = .byTruncatingTail
            messageView.backgroundColor = UIColor.clear
            messageView.clipsToBounds = true
            addSubview(messageView)
        }

        override open func updateSubviews(_: Any?) {
            let state = NXKit.Wrappable<Int, CGRect, CGRect> { __sender in
                __sender.oldValue.size = CGSize(width: 0, height: 0)
                __sender.value.size = CGSize(width: 0, height: 0)
            }

            if let image = ctxs.image, image.size.width > 0 {
                state.oldValue.size.width = 50
                state.oldValue.size.height = 50
            }

            if ctxs.message.count > 0 {
                let __size = String.size(of: ctxs.message, size: CGSize(width: NXOverlay.frame.width - ctxs.insets.left - ctxs.insets.right - 1.0, height: 200), font: ctxs.font) { style in
                    style.lineSpacing = 2.0
                }
                state.value.size.width = __size.width + 1
                state.value.size.height = __size.height + 1
            }

            var __frame = CGRect.zero
            if state.oldValue.size.height > 0 && state.value.size.height > 0 {
                __frame.size.width = ctxs.insets.left + max(state.oldValue.size.width, state.value.size.width) + ctxs.insets.right
                __frame.size.height = ctxs.insets.top + state.oldValue.size.height + 10.0 + state.value.size.height + ctxs.insets.bottom

                state.oldValue.origin.x = (__frame.size.width - state.oldValue.size.width) / 2.0
                state.oldValue.origin.y = ctxs.insets.top

                state.value.origin.x = (__frame.size.width - state.value.size.width) / 2.0
                state.value.origin.y = ctxs.insets.top + state.oldValue.size.height + 10.0
            } else if state.oldValue.size.height > 0 {
                __frame.size.width = ctxs.insets.left + state.oldValue.size.width + ctxs.insets.right
                __frame.size.height = ctxs.insets.top + state.oldValue.size.height + ctxs.insets.bottom

                state.oldValue.origin.x = (__frame.size.width - state.oldValue.size.width) / 2.0
                state.oldValue.origin.y = ctxs.insets.top
            } else if state.value.size.height > 0 {
                __frame.size.width = ctxs.insets.left + state.value.size.width + ctxs.insets.right
                __frame.size.height = ctxs.insets.top + state.value.size.height + ctxs.insets.bottom

                state.value.origin.x = (__frame.size.width - state.value.size.width) / 2.0
                state.value.origin.y = ctxs.insets.top
            }
            __frame.size.width = ceil(__frame.size.width)
            __frame.size.height = ceil(__frame.size.height)

            var __super = CGSize(width: NXKit.width, height: NXKit.height)
            if let __superview = superview {
                __super = __superview.frame.size
            }
            __frame.origin.x = (__super.width - __frame.size.width) / 2.0
            if ctxs.ats == .minY {
                __frame.origin.y = __super.height * 0.20 - __frame.size.height / 2.0
            } else if ctxs.ats == .center {
                __frame.origin.y = __super.height * 0.5 - __frame.size.height / 2.0
            } else if ctxs.ats == .maxY {
                __frame.origin.y = __super.height * 0.78 - __frame.size.height / 2.0
            }
            frame = __frame

            alpha = ctxs.alpha
            backgroundColor = ctxs.backgroundColor
            layer.shadowColor = ctxs.shadowColor
            layer.shadowOpacity = ctxs.shadowOpacity
            layer.shadowOffset = ctxs.shadowOffset
            layer.cornerRadius = 6.0 + min(round(max(__frame.size.height - 40, 0) / 25.0), 4)
            layer.shadowRadius = 6.0 + min(round(max(__frame.size.height - 40, 0) / 25.0), 4)

            if let image = ctxs.image {
                if ctxs.key == NXHUD.Key.toast.rawValue {
                    stateView.isHidden = false
                    stateView.image = image
                    stateView.frame = state.oldValue

                    animationView.isHidden = true
                    animationView.stopAnimating()
                } else if ctxs.key == NXHUD.Key.loading.rawValue {
                    stateView.isHidden = true

                    animationView.frame = state.oldValue
                    animationView.isHidden = false
                    animationView.contentView.image = image
                    animationView.startAnimating()
                }
            } else {
                stateView.isHidden = true

                animationView.isHidden = true
                animationView.stopAnimating()
            }

            if ctxs.message.count > 0 {
                messageView.isHidden = false
                messageView.textColor = ctxs.textColor
                messageView.font = ctxs.font
                messageView.numberOfLines = ctxs.numberOfLines
                messageView.attributedText = NXString.attributedString(ctxs.message, ctxs.font, ctxs.textColor, 2)
                messageView.textAlignment = .center
                messageView.frame = state.value
            } else {
                messageView.isHidden = true
            }
        }

        deinit {
            NXKit.print(NSStringFromClass(self.classForCoder))
        }
    }
}

public extension NXHUD {
    @discardableResult
    class func openWrappedView(key: String, image: UIImage?, message: String, ats: NXKit.Ats, duration: TimeInterval, superview: UIView) -> NXHUD.WrappedView? {
        if image == nil, message.count <= 0 {
            return nil
        }

        if key == NXHUD.Key.loading.rawValue {
            if let _ = objc_getAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey) as? NXHUD.WrappedView {
                return nil
            }
        }
        let wrappedView = NXHUD.WrappedView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        superview.addSubview(wrappedView)
        wrappedView.ctxs.key = key
        wrappedView.ctxs.image = image
        wrappedView.ctxs.message = message
        wrappedView.ctxs.ats = ats
        wrappedView.ctxs.duration = duration
        wrappedView.updateSubviews(nil)

        if key == NXHUD.Key.toast.rawValue {
            wrappedView.alpha = 0.0
            UIView.animate(withDuration: wrappedView.ctxs.inoutDuration,
                           delay: 0,
                           options: [.curveEaseInOut, .allowUserInteraction],
                           animations: {
                               wrappedView.alpha = wrappedView.ctxs.alpha
                           },
                           completion: { _ in
                               NXHUD.closeWrappedView(subview: wrappedView, superview: nil)
                           })
        } else if key == NXHUD.Key.loading.rawValue {
            objc_setAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey, wrappedView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            wrappedView.alpha = 0.0
            UIView.animate(withDuration: wrappedView.ctxs.inoutDuration,
                           delay: 0.0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                               wrappedView.alpha = wrappedView.ctxs.alpha
                           },
                           completion: nil)
        }
        return wrappedView
    }

    @discardableResult
    class func closeWrappedView(subview: NXHUD.WrappedView?, superview: UIView?) -> Bool {
        if let wrappedView = subview {
            UIView.animate(withDuration: wrappedView.ctxs.inoutDuration,
                           delay: wrappedView.ctxs.duration,
                           options: [.curveEaseInOut, .allowUserInteraction],
                           animations: {
                               wrappedView.alpha = 0.0
                           },
                           completion: { _ in
                               wrappedView.removeFromSuperview()
                           })
            return true
        } else if let superview = superview, let wrapperView = objc_getAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey) as? NXHUD.WrappedView {
            UIView.animate(withDuration: wrapperView.ctxs.inoutDuration,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: {
                               wrapperView.alpha = 0.0
                           },
                           completion: { (_: Bool) in
                               wrapperView.removeFromSuperview()
                               objc_setAssociatedObject(superview, &NXHUD.Wrapped.wrappedViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                           })
            return true
        }
        return false
    }
}

public extension UIView {
    @discardableResult
    func makeToast(message: String, ats: NXKit.Ats = .maxY, duration: TimeInterval = 2.0) -> NXHUD.WrappedView? {
        return NXHUD.openWrappedView(key: NXHUD.Key.toast.rawValue, image: nil, message: message, ats: ats, duration: duration, superview: self)
    }

    @discardableResult
    func makeLoading(message: String = "", ats: NXKit.Ats = .center) -> NXHUD.WrappedView? {
        return NXHUD.openWrappedView(key: NXHUD.Key.loading.rawValue, image: NXKit.image(named: "icon-animation.png"), message: message, ats: ats, duration: 0, superview: self)
    }

    @discardableResult
    func hideLoading(animationView: NXHUD.WrappedView? = nil) -> Bool {
        return NXHUD.closeWrappedView(subview: animationView, superview: self)
    }
}
