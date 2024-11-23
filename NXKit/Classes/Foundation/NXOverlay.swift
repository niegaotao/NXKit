//
//  NXOverlay.swift
//  NXKit
//
//  Created by niegaotao on 2020/11/9.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXOverlay: NXBackgroundView<UIControl, UIView> {
    public enum Animation: String {
        case none

        case header // 从顶部进入->从顶部退出[在屏幕顶部显示]

        case drop // 从上方淡入->从下方退出[在屏幕中间显示]
        case center // 从中间淡入->从中间淡出[在屏幕中间显示]
        case raise // 从下方进入->从上方退出[在屏幕中间显示]

        case footer // 从下方进入->从下方退出[在屏幕底部显示]
    }

    public static let frame = NXKit.Rect { __sender in
        __sender.width = max(min(350.0, NXKit.width * 0.8), 300.0)
        __sender.x = (NXKit.width - __sender.width) / 2.0
    }

    public static let inset = NXKit.Rect { __sender in
        __sender.x = 20.0
        __sender.width = NXOverlay.frame.width - __sender.x * 2.0
    }
}

public extension NXOverlay {
    static var overlays = NSHashTable<NXOverlay>(options: [.weakMemory], capacity: 2)

    // 加入一个弹框
    class func push(_ overlay: NXOverlay) {
        NXOverlay.overlays.add(overlay)
    }

    // 移除一个弹框
    @discardableResult
    class func pop(_ overlay: NXOverlay?) -> NXOverlay? {
        if let __overlay = overlay, NXOverlay.overlays.contains(__overlay) {
            __overlay.removeFromSuperview()
            NXOverlay.overlays.remove(__overlay)
            return __overlay
        }
        return nil
    }
}

open class NXOverlayAttributes: NXKit.Rect {
    open var inoutBackgroundColor = NXKit.transitionInoutBackgroundColor
    open var backgroundColor = NXKit.transitionBackgroundColor

    // 关闭的回调, background,lhs,rhs,close,footer
    open var close: NXKit.Event<String, Any?>? = nil

    // 点击选项或者左右按钮消失的回调
    open var completion: NXKit.Event<String, Int>? = nil

    // 弹框打开/关闭的动画
    open var animation = NXOverlay.Animation.center.rawValue

    public required init() {
        super.init()
    }
}

open class NXAbstractOverlay<Attributes: NXOverlayAttributes>: NXOverlay {
    // 上下文
    public let ctxs = Attributes()

    // 创建基础的容器试图
    override open func setupSubviews() {
        super.setupSubviews()

        // 这里用作设置背景色或者设置毛玻璃效果
        backgroundView.frame = bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(backgroundView)

        // 这里用作添加子控件
        contentView.frame = CGRect.zero
        addSubview(contentView)
    }

    // 展示:先加window上(后期补一个小动画)
    open func open(animation: NXOverlay.Animation.RawValue, completion: NXKit.Completion<Bool>?) {
        UIApplication.shared.keyWindow?.addSubview(self)
        if animation == NXOverlay.Animation.center.rawValue {
            contentView.frame = CGRect(x: (width - contentView.width) / 2.0, y: (height - contentView.height) / 2.0, width: contentView.width, height: contentView.height)

            let fromValue: (frame: CGRect, alpha: CGFloat, transform: CGAffineTransform) = (contentView.frame, 0.0, CGAffineTransform.identity.scaledBy(x: 1.08, y: 1.08))
            let toValue: (frame: CGRect, alpha: CGFloat, transform: CGAffineTransform) = (contentView.frame, contentView.alpha, CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0))

            backgroundView.backgroundColor = ctxs.inoutBackgroundColor
            contentView.transform = fromValue.transform
            contentView.alpha = fromValue.alpha

            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = self.ctxs.backgroundColor
                self.contentView.transform = toValue.transform
                self.contentView.alpha = toValue.alpha
            }, completion: { _ in
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.footer.rawValue {
            contentView.frame = CGRect(x: (width - contentView.width) / 2.0, y: height - contentView.height, width: contentView.width, height: contentView.height)
            let toValue: (frame: CGRect, alpha: CGFloat, transform: CGAffineTransform) = (contentView.frame, contentView.alpha, CGAffineTransform.identity)

            let fromValue: (frame: CGRect, alpha: CGFloat, transform: CGAffineTransform) = (contentView.frame.offsetBy(dx: 0, dy: contentView.height), contentView.alpha, CGAffineTransform.identity)

            backgroundView.backgroundColor = ctxs.inoutBackgroundColor
            contentView.alpha = fromValue.alpha
            contentView.frame = fromValue.frame

            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = self.ctxs.backgroundColor
                self.contentView.alpha = toValue.alpha
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.header.rawValue {
            contentView.frame = CGRect(x: (width - contentView.width) / 2.0, y: 0, width: contentView.width, height: contentView.height)
            let toValue: (frame: CGRect, alpha: CGFloat, transform: CGAffineTransform) = (contentView.frame, contentView.alpha, CGAffineTransform.identity)

            let fromValue: (frame: CGRect, alpha: CGFloat, transform: CGAffineTransform) = (contentView.frame.offsetBy(dx: 0, dy: -contentView.height), contentView.alpha, CGAffineTransform.identity)

            backgroundView.backgroundColor = ctxs.inoutBackgroundColor
            contentView.alpha = fromValue.alpha
            contentView.frame = fromValue.frame

            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = self.ctxs.backgroundColor
                self.contentView.alpha = toValue.alpha
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.drop.rawValue {
            contentView.frame = CGRect(x: (width - contentView.width) / 2.0, y: (height - contentView.height) / 2.0, width: contentView.width, height: contentView.height)
            let toValue: (frame: CGRect, aplha: CGFloat, transform: CGAffineTransform) = (contentView.frame, contentView.alpha, CGAffineTransform.identity)

            let fromValue: (frame: CGRect, aplha: CGFloat, transform: CGAffineTransform) = (contentView.frame.offsetBy(dx: 0, dy: -toValue.frame.maxY), contentView.alpha, CGAffineTransform.identity)

            backgroundView.backgroundColor = ctxs.inoutBackgroundColor
            contentView.alpha = fromValue.aplha
            contentView.frame = fromValue.frame

            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = self.ctxs.backgroundColor
                self.contentView.alpha = toValue.aplha
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.raise.rawValue {
            contentView.frame = CGRect(x: (width - contentView.width) / 2.0, y: (height - contentView.height) / 2.0, width: contentView.width, height: contentView.height)
            let toValue: (frame: CGRect, aplha: CGFloat, transform: CGAffineTransform) = (contentView.frame, contentView.alpha, CGAffineTransform.identity)

            let fromValue: (frame: CGRect, aplha: CGFloat, transform: CGAffineTransform) = (contentView.frame.offsetBy(dx: 0, dy: toValue.frame.maxY), contentView.alpha, CGAffineTransform.identity)

            backgroundView.backgroundColor = ctxs.inoutBackgroundColor
            contentView.alpha = fromValue.aplha
            contentView.frame = fromValue.frame

            UIView.animate(withDuration: 0.27, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView.backgroundColor = self.ctxs.backgroundColor
                self.contentView.alpha = toValue.aplha
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.none.rawValue {
            backgroundView.backgroundColor = ctxs.backgroundColor
            completion?(true)
        }
    }

    // 移除：动画结束后才会回调
    open func close(animation: NXOverlay.Animation.RawValue, completion: NXKit.Completion<Bool>?) {
        if animation == NXOverlay.Animation.center.rawValue {
            UIView.animate(withDuration: 0.27, animations: {
                self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.96, y: 0.96)
                self.backgroundView.backgroundColor = NXKit.transitionInoutBackgroundColor
                self.contentView.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.footer.rawValue {
            let fromValue: (frame: CGRect, aplha: CGFloat) = (contentView.frame, contentView.alpha)
            let toValue: (frame: CGRect, aplha: CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: contentView.height), contentView.alpha)

            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = NXKit.transitionInoutBackgroundColor
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                self.removeFromSuperview()
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.header.rawValue {
            let fromValue: (frame: CGRect, aplha: CGFloat) = (contentView.frame, contentView.alpha)
            let toValue: (frame: CGRect, aplha: CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: -contentView.height), contentView.alpha)

            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = NXKit.transitionInoutBackgroundColor
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                self.removeFromSuperview()
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.drop.rawValue {
            let fromValue: (frame: CGRect, aplha: CGFloat) = (contentView.frame, contentView.alpha)
            let toValue: (frame: CGRect, aplha: CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: contentView.maxY), contentView.alpha)

            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = NXKit.transitionInoutBackgroundColor
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                self.removeFromSuperview()
                completion?(true)
            })
        } else if animation == NXOverlay.Animation.raise.rawValue {
            let fromValue: (frame: CGRect, aplha: CGFloat) = (contentView.frame, contentView.alpha)
            let toValue: (frame: CGRect, aplha: CGFloat) = (fromValue.frame.offsetBy(dx: 0, dy: -contentView.maxY), contentView.alpha)

            UIView.animate(withDuration: 0.27, animations: {
                self.backgroundView.backgroundColor = NXKit.transitionInoutBackgroundColor
                self.contentView.frame = toValue.frame
            }, completion: { _ in
                self.removeFromSuperview()
                completion?(true)
            })
        } else {
            removeFromSuperview()
            completion?(true)
        }
    }

    deinit {
        NXKit.print(NSStringFromClass(self.classForCoder))
    }
}
