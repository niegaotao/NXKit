//
//  NXClipboardView.swift
//  NXKit
//
//  Created by niegaotao on 2021/11/26.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXClipboardView: NXView {
    open class Line {
        open var width: CGFloat = 20.0
        open var insets: CGFloat = 18.0

        public init() {}

        public init(width: CGFloat, insets: CGFloat) {
            self.width = width
            self.insets = insets
        }
    }

    open class Wrapped: NSObject {
        // 整个可以展示区域的宽高
        open var size = CGSize(width: CGFloat.zero, height: CGFloat.zero)
        // 约束宽高
        open var clip = NXClip(name: "1:1", isResizable: false, width: 1.0, height: 1.0, isHidden: false)
        // 线条相关属性
        open var line = NXClipboardView.Line()
        // 边
        open var ats = NXKit.Ats.unspefified
        // 框选区域的frame
        public let frame = NXKit.Wrappable<Bool, CGRect, CGRect> { __sender in
            __sender.oldValue = CGRect.zero; __sender.value = CGRect.zero
        }
    }

    open class WrappedView: NXView {
        public let minXTHSView = UIView(frame: CGRect.zero)
        public let minXBHSView = UIView(frame: CGRect.zero)
        public let maxXTHSView = UIView(frame: CGRect.zero)
        public let maxXBHSView = UIView(frame: CGRect.zero)

        public let minYLHSView = UIView(frame: CGRect.zero)
        public let minYRHSView = UIView(frame: CGRect.zero)
        public let maxYLHSView = UIView(frame: CGRect.zero)
        public let maxYRHSView = UIView(frame: CGRect.zero)

        public let minXView = NXAutoresizeView<UIView>(frame: CGRect.zero)
        public let maxXView = NXAutoresizeView<UIView>(frame: CGRect.zero)
        public let minYView = NXAutoresizeView<UIView>(frame: CGRect.zero)
        public let maxYView = NXAutoresizeView<UIView>(frame: CGRect.zero)

        override open func setupSubviews() {
            minXTHSView.backgroundColor = NXKit.primaryColor
            minXTHSView.isUserInteractionEnabled = false
            addSubview(minXTHSView)

            minXBHSView.backgroundColor = NXKit.primaryColor
            minXBHSView.isUserInteractionEnabled = false
            addSubview(minXBHSView)

            maxXTHSView.backgroundColor = NXKit.primaryColor
            maxXTHSView.isUserInteractionEnabled = false
            addSubview(maxXTHSView)

            maxXBHSView.backgroundColor = NXKit.primaryColor
            maxXBHSView.isUserInteractionEnabled = false
            addSubview(maxXBHSView)

            minYLHSView.backgroundColor = NXKit.primaryColor
            minYLHSView.isUserInteractionEnabled = false
            addSubview(minYLHSView)

            minYRHSView.backgroundColor = NXKit.primaryColor
            minYRHSView.isUserInteractionEnabled = false
            addSubview(minYRHSView)

            maxYLHSView.backgroundColor = NXKit.primaryColor
            maxYLHSView.isUserInteractionEnabled = false
            addSubview(maxYLHSView)

            maxYRHSView.backgroundColor = NXKit.primaryColor
            maxYRHSView.isUserInteractionEnabled = false
            addSubview(maxYRHSView)

            minXView.autoresizesSubviews = true
            minXView.backgroundColor = UIColor.clear
            minXView.contentView.backgroundColor = NXKit.primaryColor
            addSubview(minXView)

            maxXView.autoresizesSubviews = true
            maxXView.backgroundColor = UIColor.clear
            maxXView.contentView.backgroundColor = NXKit.primaryColor
            addSubview(maxXView)

            minYView.autoresizesSubviews = true
            minYView.backgroundColor = UIColor.clear
            minYView.contentView.backgroundColor = NXKit.primaryColor
            addSubview(minYView)

            maxYView.autoresizesSubviews = true
            maxYView.backgroundColor = UIColor.clear
            maxYView.contentView.backgroundColor = NXKit.primaryColor
            addSubview(maxYView)
        }

        override open func layoutSubviews() {
            super.layoutSubviews()

            minXView.frame = CGRect(x: 0, y: 0, width: minXView.width, height: height)
            maxXView.frame = CGRect(x: width - maxXView.width, y: 0, width: maxXView.width, height: height)
            minYView.frame = CGRect(x: 0, y: 0, width: width, height: minYView.height)
            maxYView.frame = CGRect(x: 0, y: height - maxYView.height, width: width, height: maxYView.height)

            minYLHSView.frame = CGRect(x: 0, y: 0, width: minYLHSView.width, height: minYLHSView.height)
            minYRHSView.frame = CGRect(x: width - minYRHSView.width, y: 0, width: minYRHSView.width, height: minYRHSView.height)

            maxYLHSView.frame = CGRect(x: 0, y: height - maxYLHSView.height, width: maxYLHSView.width, height: maxYLHSView.height)
            maxYRHSView.frame = CGRect(x: width - maxYRHSView.width, y: height - maxYRHSView.height, width: maxYRHSView.width, height: maxYRHSView.height)

            minXTHSView.frame = CGRect(x: 0, y: 0, width: minXTHSView.width, height: minXTHSView.height)
            minXBHSView.frame = CGRect(x: 0, y: height - minXBHSView.height, width: minXBHSView.width, height: minXBHSView.height)

            maxXTHSView.frame = CGRect(x: width - maxXTHSView.width, y: 0, width: maxXTHSView.width, height: maxXTHSView.height)
            maxXBHSView.frame = CGRect(x: width - maxXBHSView.width, y: height - maxXBHSView.height, width: maxXBHSView.width, height: maxXBHSView.height)
        }
    }

    public let ctxs = NXClipboardView.Wrapped()
    public let wrappedView = NXClipboardView.WrappedView(frame: CGRect.zero)
    public let panRecognizer = UIPanGestureRecognizer()
    public let point = NXKit.Wrappable<UIGestureRecognizer.State, CGPoint, CGPoint> { __sender in
        __sender.key = UIGestureRecognizer.State.possible; __sender.oldValue = CGPoint.zero; __sender.value = CGPoint.zero
    }

    public let pinchRecognizer = UIPinchGestureRecognizer()

    override open func setupSubviews() {
        wrappedView.clipsToBounds = true
        addSubview(wrappedView)

        pinchRecognizer.addTarget(self, action: #selector(pinchRecognizerAction(_:)))
        addGestureRecognizer(pinchRecognizer)

        panRecognizer.addTarget(self, action: #selector(panRecognizerAction(_:)))
        addGestureRecognizer(panRecognizer)
    }

    override open func updateSubviews(_: Any?) {
        if ctxs.clip.width <= 0 || ctxs.clip.height <= 0 {
            ctxs.clip.name = "1:1"
            ctxs.clip.width = 1.0
            ctxs.clip.height = 1.0
        }

        wrappedView.minXView.width = ctxs.line.width
        wrappedView.minXView.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ctxs.line.insets)

        wrappedView.maxXView.width = ctxs.line.width
        wrappedView.maxXView.insets = UIEdgeInsets(top: 0, left: ctxs.line.insets, bottom: 0, right: 0)

        wrappedView.minYView.height = ctxs.line.width
        wrappedView.minYView.insets = UIEdgeInsets(top: 0, left: 0, bottom: ctxs.line.insets, right: 0)

        wrappedView.maxYView.height = ctxs.line.width
        wrappedView.maxYView.insets = UIEdgeInsets(top: ctxs.line.insets, left: 0, bottom: 0, right: 0)

        wrappedView.minYLHSView.width = ctxs.line.width * 1.25
        wrappedView.minYLHSView.height = ctxs.line.width * 0.5

        wrappedView.minYRHSView.width = ctxs.line.width * 1.25
        wrappedView.minYRHSView.height = ctxs.line.width * 0.5

        wrappedView.maxYLHSView.width = ctxs.line.width * 1.25
        wrappedView.maxYLHSView.height = ctxs.line.width * 0.5

        wrappedView.maxYRHSView.width = ctxs.line.width * 1.25
        wrappedView.maxYRHSView.height = ctxs.line.width * 0.5

        wrappedView.minXTHSView.width = ctxs.line.width * 0.5
        wrappedView.minXTHSView.height = ctxs.line.width * 1.25

        wrappedView.minXBHSView.width = ctxs.line.width * 0.5
        wrappedView.minXBHSView.height = ctxs.line.width * 1.25

        wrappedView.maxXTHSView.width = ctxs.line.width * 0.5
        wrappedView.maxXTHSView.height = ctxs.line.width * 1.25

        wrappedView.maxXBHSView.width = ctxs.line.width * 0.5
        wrappedView.maxXBHSView.height = ctxs.line.width * 1.25

        if ctxs.clip.isHidden == false {
            wrappedView.isHidden = false

            let pfsValue = NXKit.Rect(completion: nil)
            pfsValue.x = ctxs.clip.width / ctxs.size.width
            pfsValue.y = ctxs.clip.height / ctxs.size.height
            if pfsValue.x >= pfsValue.y {
                // 宽度撑满
                pfsValue.width = frame.size.width
                pfsValue.height = pfsValue.width * (ctxs.clip.height / ctxs.clip.width)
            } else {
                // 高度撑满
                pfsValue.height = frame.size.height
                pfsValue.width = pfsValue.height * (ctxs.clip.width / ctxs.clip.height)
            }
            ctxs.frame.oldValue = CGRect(x: (frame.size.width - pfsValue.width) / 2.0, y: (frame.size.height - pfsValue.height) / 2.0, width: pfsValue.width, height: pfsValue.height)
            ctxs.frame.value = ctxs.frame.oldValue
            wrappedView.frame = ctxs.frame.value

            panRecognizer.isEnabled = true
            pinchRecognizer.isEnabled = true
        } else {
            wrappedView.isHidden = true

            ctxs.frame.oldValue = CGRect.zero
            ctxs.frame.value = ctxs.frame.oldValue
            wrappedView.frame = ctxs.frame.value

            panRecognizer.isEnabled = true
            pinchRecognizer.isEnabled = false
        }

        wrappedView.setNeedsLayout()

        setNeedsLayout()
    }

    @objc func panRecognizerAction(_ panRecognizer: UIPanGestureRecognizer) {
        let __translation = panRecognizer.translation(in: self)
        point.key = panRecognizer.state
        point.value = panRecognizer.location(in: self)
        panRecognizer.setTranslation(CGPoint.zero, in: self)

        if point.key == .began {
            point.oldValue = point.value
        }

        if ctxs.clip.isHidden == false {
            if point.key == .began {
                if ctxs.clip.isResizable && wrappedView.convert(wrappedView.minXView.frame, to: self).contains(point.oldValue) {
                    ctxs.ats = .minX
                } else if ctxs.clip.isResizable && wrappedView.convert(wrappedView.maxXView.frame, to: self).contains(point.oldValue) {
                    ctxs.ats = .maxX
                } else if ctxs.clip.isResizable && wrappedView.convert(wrappedView.minYView.frame, to: self).contains(point.oldValue) {
                    ctxs.ats = .minY
                } else if ctxs.clip.isResizable && wrappedView.convert(wrappedView.maxYView.frame, to: self).contains(point.oldValue) {
                    ctxs.ats = .maxY
                } else {
                    ctxs.ats = .center
                }
            }

            if point.key == .began || point.key == .changed {
                if ctxs.ats == .center {
                    wrappedView.center = CGPoint(x: wrappedView.center.x + __translation.x, y: wrappedView.center.y + __translation.y)
                    ctxs.frame.value = wrappedView.frame
                } else if ctxs.ats == .minX {
                    var __frame = wrappedView.frame
                    __frame.origin.x = __frame.origin.x + __translation.x
                    __frame.size.width = __frame.size.width - __translation.x
                    if __frame.size.width >= ctxs.line.width * 2.0
                        && __frame.size.width <= frame.size.width
                    {
                        ctxs.frame.value = __frame
                        wrappedView.frame = __frame
                    }
                } else if ctxs.ats == .maxX {
                    var __frame = wrappedView.frame
                    __frame.size.width = __frame.size.width + __translation.x
                    if __frame.size.width >= ctxs.line.width * 2.0
                        && __frame.size.width <= frame.size.width
                    {
                        ctxs.frame.value = __frame
                        wrappedView.frame = __frame
                    }
                } else if ctxs.ats == .minY {
                    var __frame = wrappedView.frame
                    __frame.origin.y = __frame.origin.y + __translation.y
                    __frame.size.height = __frame.size.height - __translation.y
                    if __frame.size.height >= ctxs.line.width * 2.0
                        && __frame.size.height <= frame.size.height
                    {
                        ctxs.frame.value = __frame
                        wrappedView.frame = __frame
                    }
                } else if ctxs.ats == .maxY {
                    var __frame = wrappedView.frame
                    __frame.size.height = __frame.size.height + __translation.y
                    if __frame.size.height >= ctxs.line.width * 2.0
                        && __frame.size.height <= frame.size.height
                    {
                        ctxs.frame.value = __frame
                        wrappedView.frame = __frame
                    }
                }
            } else {
                var __frame = wrappedView.frame
                if __frame.width > frame.size.width {
                    __frame.size.width = frame.size.width
                    if ctxs.clip.isResizable == false {
                        __frame.size.height = __frame.size.width * (ctxs.clip.height / ctxs.clip.width)
                    }
                }

                if __frame.height > frame.size.height {
                    __frame.size.height = frame.size.height
                    if ctxs.clip.isResizable == false {
                        __frame.size.width = __frame.size.height * (ctxs.clip.width / ctxs.clip.height)
                    }
                }
                if __frame.minX < 0 {
                    __frame.origin.x = 0
                }

                if __frame.maxX > frame.size.width {
                    __frame.origin.x = frame.size.width - __frame.width
                }

                if __frame.minY < 0 {
                    __frame.origin.y = 0
                }

                if __frame.maxY > frame.size.height {
                    __frame.origin.y = frame.size.height - __frame.height
                }
                ctxs.frame.value = __frame
                UIView.animate(withDuration: 0.15) {
                    self.wrappedView.frame = __frame
                }
            }
        } else {
            var __frame = CGRect.zero
            if point.oldValue.x <= point.value.x {
                __frame.origin.x = point.oldValue.x
                __frame.size.width = point.value.x - point.oldValue.x
            } else {
                __frame.origin.x = point.value.x
                __frame.size.width = point.oldValue.x - point.value.x
            }

            if point.oldValue.y <= point.value.y {
                __frame.origin.y = point.oldValue.y
                __frame.size.height = point.value.y - point.oldValue.y
            } else {
                __frame.origin.y = point.value.y
                __frame.size.height = point.oldValue.y - point.value.y
            }

            if __frame.minX < 0 {
                __frame.origin.x = 0
            }

            if __frame.maxX > frame.size.width {
                __frame.size.width = frame.size.width - __frame.origin.x
            }

            if __frame.minY < 0 {
                __frame.origin.y = 0
            }

            if __frame.maxY > frame.size.height {
                __frame.size.height = frame.size.height - __frame.origin.y
            }

            if point.key == .began || point.key == .changed {
                ctxs.frame.value = __frame
                wrappedView.frame = ctxs.frame.value
                wrappedView.isHidden = false
            } else {
                if ctxs.clip.isResizable == false {
                    // 不动左上角,缩小比例
                    let rateValue = CGPoint(x: __frame.size.width / ctxs.clip.width, y: __frame.size.height / ctxs.clip.height)
                    if rateValue.x >= rateValue.y {
                        // 宽度过大，收缩宽度
                        __frame.size.width = __frame.size.height * (ctxs.clip.width / ctxs.clip.height)
                    } else {
                        __frame.size.height = __frame.size.width * (ctxs.clip.height / ctxs.clip.width)
                    }
                }

                // 一次手势时间结束了
                if __frame.size.width >= ctxs.line.width * 2.0 && __frame.size.height >= ctxs.line.width * 2.0 {
                    ctxs.clip.isHidden = false

                    ctxs.frame.value = __frame
                    wrappedView.frame = ctxs.frame.value
                    wrappedView.isHidden = false

                    self.panRecognizer.isEnabled = true
                    pinchRecognizer.isEnabled = true
                } else {
                    ctxs.clip.isHidden = true

                    ctxs.frame.value = CGRect.zero
                    wrappedView.frame = ctxs.frame.value
                    wrappedView.isHidden = true

                    self.panRecognizer.isEnabled = true
                    pinchRecognizer.isEnabled = false
                }
            }
        }
    }

    @objc func pinchRecognizerAction(_ pinchRecognizer: UIPinchGestureRecognizer) {
        if pinchRecognizer.state == .began || pinchRecognizer.state == .changed {
            var __ctxs: (center: CGPoint, scale: CGFloat, x: CGFloat, y: CGFloat, mX: CGFloat, mY: CGFloat) = (CGPoint.zero, 0.0, 0.0, 0.0, 0.0, 0.0)
            __ctxs.center = pinchRecognizer.location(in: self)
            __ctxs.scale = pinchRecognizer.scale
            __ctxs.x = wrappedView.x - __ctxs.center.x
            __ctxs.y = wrappedView.y - __ctxs.center.y
            __ctxs.mX = __ctxs.x * __ctxs.scale
            __ctxs.mY = __ctxs.y * __ctxs.scale

            var __frame = CGRect.zero
            __frame.origin.x = wrappedView.x + __ctxs.mX - __ctxs.x
            __frame.origin.y = wrappedView.y + __ctxs.mY - __ctxs.y
            __frame.size.width = wrappedView.width * __ctxs.scale
            __frame.size.height = wrappedView.height * __ctxs.scale

            if __frame.size.width >= ctxs.line.width * 2.0
                && __frame.size.height >= ctxs.line.width * 2.0
                && __frame.size.width <= frame.size.width
                && __frame.size.height <= frame.size.height
            {
                ctxs.frame.value = __frame
                wrappedView.frame = __frame
            }
        } else {
            var __frame = wrappedView.frame

            if __frame.width > frame.size.width {
                __frame.size.width = frame.size.width
                if ctxs.clip.isResizable == false {
                    __frame.size.height = __frame.size.width * (ctxs.clip.height / ctxs.clip.width)
                }
            }

            if __frame.height > frame.size.height {
                __frame.size.height = frame.size.height
                if ctxs.clip.isResizable == false {
                    __frame.size.width = __frame.size.height * (ctxs.clip.width / ctxs.clip.height)
                }
            }

            if __frame.minX < 0 {
                __frame.origin.x = 0
            }

            if __frame.maxX > frame.size.width {
                __frame.origin.x = frame.size.width - __frame.width
            }

            if __frame.minY < 0 {
                __frame.origin.y = 0
            }

            if __frame.maxY > frame.size.height {
                __frame.origin.y = frame.size.height - __frame.height
            }

            ctxs.frame.value = __frame
            UIView.animate(withDuration: 0.15) {
                self.wrappedView.frame = __frame
            }
        }

        pinchRecognizer.scale = 1.0
    }
}
