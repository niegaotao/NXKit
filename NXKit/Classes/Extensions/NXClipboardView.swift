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
        open var width : CGFloat = 20.0
        open var insets : CGFloat = 18.0
        
        public init(){}
        
        public init(width:CGFloat, insets:CGFloat) {
            self.width = width
            self.insets = insets
        }
    }
    
    open class Wrapped : NSObject {
        //整个可以展示区域的宽高
        open var size = CGSize(width: CGFloat.zero, height: CGFloat.zero)
        //约束宽高
        open var clip = NXClip(name: "1:1", isResizable: false, width: 1.0, height: 1.0, isHidden: false)
        //线条相关属性
        open var line = NXClipboardView.Line()
        //边
        open var ats = NX.Ats.unspefified
        //框选区域的frame
        public let frame = NX.Wrappable<Bool, CGRect, CGRect> { (_, __sender) in
            __sender.oldValue = CGRect.zero;__sender.value = CGRect.zero;}
    }

    open class WrappedView : NXView {
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
        
        open override func setupSubviews() {
            self.minXTHSView.backgroundColor = NXUI.mainColor
            self.minXTHSView.isUserInteractionEnabled = false
            self.addSubview(self.minXTHSView)
            
            self.minXBHSView.backgroundColor = NXUI.mainColor
            self.minXBHSView.isUserInteractionEnabled = false
            self.addSubview(self.minXBHSView)
            
            self.maxXTHSView.backgroundColor = NXUI.mainColor
            self.maxXTHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxXTHSView)
            
            self.maxXBHSView.backgroundColor = NXUI.mainColor
            self.maxXBHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxXBHSView)
            
            self.minYLHSView.backgroundColor = NXUI.mainColor
            self.minYLHSView.isUserInteractionEnabled = false
            self.addSubview(self.minYLHSView)
            
            self.minYRHSView.backgroundColor = NXUI.mainColor
            self.minYRHSView.isUserInteractionEnabled = false
            self.addSubview(self.minYRHSView)
            
            self.maxYLHSView.backgroundColor = NXUI.mainColor
            self.maxYLHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxYLHSView)
            
            self.maxYRHSView.backgroundColor = NXUI.mainColor
            self.maxYRHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxYRHSView)
            
            self.minXView.autoresizesSubviews = true
            self.minXView.backgroundColor = UIColor.clear
            self.minXView.contentView.backgroundColor = NXUI.mainColor
            self.addSubview(self.minXView)
            
            self.maxXView.autoresizesSubviews = true
            self.maxXView.backgroundColor = UIColor.clear
            self.maxXView.contentView.backgroundColor = NXUI.mainColor
            self.addSubview(self.maxXView)
            
            self.minYView.autoresizesSubviews = true
            self.minYView.backgroundColor = UIColor.clear
            self.minYView.contentView.backgroundColor = NXUI.mainColor
            self.addSubview(self.minYView)
            
            self.maxYView.autoresizesSubviews = true
            self.maxYView.backgroundColor = UIColor.clear
            self.maxYView.contentView.backgroundColor = NXUI.mainColor
            self.addSubview(self.maxYView)
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            self.minXView.frame = CGRect(x: 0, y: 0, width: self.minXView.w, height: self.h)
            self.maxXView.frame = CGRect(x: self.w-self.maxXView.w, y: 0, width: self.maxXView.w, height: self.h)
            self.minYView.frame = CGRect(x: 0, y: 0, width: self.w, height: self.minYView.h)
            self.maxYView.frame = CGRect(x: 0, y: self.h-self.maxYView.h, width: self.w, height: self.maxYView.h)
            
            self.minYLHSView.frame = CGRect(x: 0, y: 0, width: self.minYLHSView.w, height: self.minYLHSView.h)
            self.minYRHSView.frame = CGRect(x: self.w-self.minYRHSView.w, y: 0, width: self.minYRHSView.w, height: self.minYRHSView.h)
            
            self.maxYLHSView.frame = CGRect(x: 0, y: self.h-self.maxYLHSView.h, width: self.maxYLHSView.w, height: self.maxYLHSView.h)
            self.maxYRHSView.frame = CGRect(x: self.w-self.maxYRHSView.w, y: self.h-self.maxYRHSView.h, width: self.maxYRHSView.w, height: self.maxYRHSView.h)
            
            self.minXTHSView.frame = CGRect(x: 0, y: 0, width: self.minXTHSView.w, height: self.minXTHSView.h)
            self.minXBHSView.frame = CGRect(x: 0, y: self.h-minXBHSView.h, width: self.minXBHSView.w, height: self.minXBHSView.h)
            
            self.maxXTHSView.frame = CGRect(x: self.w-self.maxXTHSView.w, y: 0, width: self.maxXTHSView.w, height: self.maxXTHSView.h)
            self.maxXBHSView.frame = CGRect(x: self.w-self.maxXBHSView.w, y: self.h-self.maxXBHSView.h, width: self.maxXBHSView.w, height: self.maxXBHSView.h)
        }
    }
    

    public let ctxs = NXClipboardView.Wrapped()
    public let wrappedView = NXClipboardView.WrappedView(frame:CGRect.zero)
    public let panRecognizer = UIPanGestureRecognizer()
    public let point = NX.Wrappable<UIGestureRecognizer.State, CGPoint, CGPoint>{ (_, __sender) in
        __sender.key = UIGestureRecognizer.State.possible;__sender.oldValue = CGPoint.zero;__sender.value = CGPoint.zero;}
    public let pinchRecognizer = UIPinchGestureRecognizer()
    
    open override func setupSubviews() {
        self.wrappedView.clipsToBounds = true
        self.addSubview(self.wrappedView)
        
        self.pinchRecognizer.addTarget(self, action: #selector(pinchRecognizerAction(_:)))
        self.addGestureRecognizer(self.pinchRecognizer)
        
        self.panRecognizer.addTarget(self, action: #selector(panRecognizerAction(_:)))
        self.addGestureRecognizer(self.panRecognizer)
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?) {
        
        if self.ctxs.clip.width <= 0 || self.ctxs.clip.height <= 0 {
            self.ctxs.clip.name = "1:1"
            self.ctxs.clip.width = 1.0
            self.ctxs.clip.height = 1.0
        }
        
        self.wrappedView.minXView.w = self.ctxs.line.width
        self.wrappedView.minXView.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.ctxs.line.insets)
        
        self.wrappedView.maxXView.w = self.ctxs.line.width
        self.wrappedView.maxXView.insets = UIEdgeInsets(top: 0, left: self.ctxs.line.insets, bottom: 0, right: 0)
        
        self.wrappedView.minYView.h = self.ctxs.line.width
        self.wrappedView.minYView.insets = UIEdgeInsets(top: 0, left: 0, bottom: self.ctxs.line.insets, right: 0)
        
        self.wrappedView.maxYView.h = self.ctxs.line.width
        self.wrappedView.maxYView.insets = UIEdgeInsets(top: self.ctxs.line.insets, left: 0, bottom: 0, right: 0)
        
        self.wrappedView.minYLHSView.w = self.ctxs.line.width * 1.25
        self.wrappedView.minYLHSView.h = self.ctxs.line.width * 0.5
        
        self.wrappedView.minYRHSView.w = self.ctxs.line.width * 1.25
        self.wrappedView.minYRHSView.h = self.ctxs.line.width * 0.5

        self.wrappedView.maxYLHSView.w = self.ctxs.line.width * 1.25
        self.wrappedView.maxYLHSView.h = self.ctxs.line.width * 0.5
        
        self.wrappedView.maxYRHSView.w = self.ctxs.line.width * 1.25
        self.wrappedView.maxYRHSView.h = self.ctxs.line.width * 0.5
        
        self.wrappedView.minXTHSView.w = self.ctxs.line.width * 0.5
        self.wrappedView.minXTHSView.h = self.ctxs.line.width * 1.25
        
        self.wrappedView.minXBHSView.w = self.ctxs.line.width * 0.5
        self.wrappedView.minXBHSView.h = self.ctxs.line.width * 1.25
        
        self.wrappedView.maxXTHSView.w = self.ctxs.line.width * 0.5
        self.wrappedView.maxXTHSView.h = self.ctxs.line.width * 1.25
        
        self.wrappedView.maxXBHSView.w = self.ctxs.line.width * 0.5
        self.wrappedView.maxXBHSView.h = self.ctxs.line.width * 1.25
        
        if self.ctxs.clip.isHidden == false {
            self.wrappedView.isHidden = false
            
            let pfsValue = NX.Rect(completion:nil)
            pfsValue.x = self.ctxs.clip.width / self.ctxs.size.width
            pfsValue.y = self.ctxs.clip.height / self.ctxs.size.height
            if pfsValue.x >= pfsValue.y {
                //宽度撑满
                pfsValue.width = self.ctxs.size.width
                pfsValue.height = pfsValue.width * (self.ctxs.clip.height / self.ctxs.clip.width)
            }
            else {
                //高度撑满
                pfsValue.height = self.ctxs.size.height
                pfsValue.width = pfsValue.height * (self.ctxs.clip.width / self.ctxs.clip.height)
            }
            self.ctxs.frame.oldValue = CGRect(x:(self.ctxs.size.width - pfsValue.width)/2.0, y:(self.ctxs.size.height - pfsValue.height)/2.0, width:pfsValue.width, height:pfsValue.height)
            self.ctxs.frame.value = self.ctxs.frame.oldValue
            self.wrappedView.frame = self.ctxs.frame.value
            
            self.panRecognizer.isEnabled = true
            self.pinchRecognizer.isEnabled = true
        }
        else {
            self.wrappedView.isHidden = true
            
            self.ctxs.frame.oldValue = CGRect.zero
            self.ctxs.frame.value = self.ctxs.frame.oldValue
            self.wrappedView.frame = self.ctxs.frame.value

            self.panRecognizer.isEnabled = true
            self.pinchRecognizer.isEnabled = false
        }
        
        self.wrappedView.setNeedsLayout()
        
        self.setNeedsLayout()
    }
    
    @objc func panRecognizerAction(_ panRecognizer:UIPanGestureRecognizer) {
        let __translation = panRecognizer.translation(in: self)
        self.point.key = panRecognizer.state
        self.point.value = panRecognizer.location(in: self)
        panRecognizer.setTranslation(CGPoint.zero, in: self)
        
        if self.point.key == .began {
            self.point.oldValue = self.point.value
        }
        
        if self.ctxs.clip.isHidden == false {
            if self.point.key == .began {
                
                if self.ctxs.clip.isResizable && self.wrappedView.convert(self.wrappedView.minXView.frame, to: self).contains(self.point.oldValue) {
                    self.ctxs.ats = .minX
                }
                else if self.ctxs.clip.isResizable && self.wrappedView.convert(self.wrappedView.maxXView.frame, to: self).contains(self.point.oldValue) {
                    self.ctxs.ats = .maxX
                }
                else if self.ctxs.clip.isResizable && self.wrappedView.convert(self.wrappedView.minYView.frame, to: self).contains(self.point.oldValue) {
                    self.ctxs.ats = .minY
                }
                else if self.ctxs.clip.isResizable && self.wrappedView.convert(self.wrappedView.maxYView.frame, to: self).contains(self.point.oldValue) {
                    self.ctxs.ats = .maxY
                }
                else {
                    self.ctxs.ats = .center
                }
            }
            
            if self.point.key == .began || self.point.key == .changed {
                if self.ctxs.ats == .center {
                    self.wrappedView.center = CGPoint(x: self.wrappedView.center.x + __translation.x, y: self.wrappedView.center.y + __translation.y)
                    self.ctxs.frame.value = self.wrappedView.frame
                }
                else if self.ctxs.ats == .minX {
                    var __frame = self.wrappedView.frame
                    __frame.origin.x = __frame.origin.x + __translation.x
                    __frame.size.width = __frame.size.width - __translation.x
                    if __frame.size.width >= self.ctxs.line.width * 2.0
                        && __frame.size.width <= self.ctxs.size.width {
                        self.ctxs.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
                else if self.ctxs.ats == .maxX {
                    var __frame = self.wrappedView.frame
                    __frame.size.width = __frame.size.width + __translation.x
                    if __frame.size.width >= self.ctxs.line.width * 2.0
                        && __frame.size.width <= self.ctxs.size.width {
                        self.ctxs.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
                else if self.ctxs.ats == .minY {
                    var __frame = self.wrappedView.frame
                    __frame.origin.y = __frame.origin.y + __translation.y
                    __frame.size.height = __frame.size.height - __translation.y
                    if __frame.size.height >= self.ctxs.line.width * 2.0
                        && __frame.size.height <= self.ctxs.size.height {
                        self.ctxs.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
                else if self.ctxs.ats == .maxY {
                    var __frame = self.wrappedView.frame
                    __frame.size.height = __frame.size.height + __translation.y
                    if __frame.size.height >= self.ctxs.line.width * 2.0
                        && __frame.size.height <= self.ctxs.size.height {
                        self.ctxs.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
            }
            else {
                var __frame = self.wrappedView.frame
                if __frame.width > self.ctxs.size.width {
                    __frame.size.width = self.ctxs.size.width
                    if self.ctxs.clip.isResizable == false {
                        __frame.size.height = __frame.size.width * (self.ctxs.clip.height / self.ctxs.clip.width)
                    }
                }
                
                if __frame.height > self.ctxs.size.height {
                    __frame.size.height = self.ctxs.size.height
                    if self.ctxs.clip.isResizable == false {
                        __frame.size.width = __frame.size.height * (self.ctxs.clip.width / self.ctxs.clip.height)
                    }
                }
                if __frame.minX < 0 {
                    __frame.origin.x = 0
                }
                
                if __frame.maxX > self.ctxs.size.width {
                    __frame.origin.x = self.ctxs.size.width - __frame.width
                }
                
                if __frame.minY < 0 {
                    __frame.origin.y = 0
                }
                
                if __frame.maxY > self.ctxs.size.height {
                    __frame.origin.y =  self.ctxs.size.height - __frame.height
                }
                self.ctxs.frame.value = __frame
                UIView.animate(withDuration: 0.15) {
                    self.wrappedView.frame = __frame
                }
            }
        }
        else {
            var __frame = CGRect.zero
            if self.point.oldValue.x <= self.point.value.x {
                __frame.origin.x = self.point.oldValue.x
                __frame.size.width = self.point.value.x - self.point.oldValue.x
            }
            else {
                __frame.origin.x = self.point.value.x
                __frame.size.width = self.point.oldValue.x - self.point.value.x
            }
            
            if self.point.oldValue.y <= self.point.value.y {
                __frame.origin.y = self.point.oldValue.y
                __frame.size.height = self.point.value.y - self.point.oldValue.y
            }
            else {
                __frame.origin.y = self.point.value.y
                __frame.size.height = self.point.oldValue.y - self.point.value.y
            }
            
            if __frame.minX < 0 {
                __frame.origin.x = 0
            }
            
            if __frame.maxX > self.ctxs.size.width {
                __frame.size.width = self.ctxs.size.width - __frame.origin.x
            }
            
            if __frame.minY < 0 {
                __frame.origin.y = 0
            }
            
            if __frame.maxY > self.ctxs.size.height {
                __frame.size.height = self.ctxs.size.height - __frame.origin.y
            }
            
            if self.point.key == .began || self.point.key == .changed {
                self.ctxs.frame.value = __frame
                self.wrappedView.frame = self.ctxs.frame.value
                self.wrappedView.isHidden = false
            }
            else {
                if self.ctxs.clip.isResizable == false {
                    //不动左上角,缩小比例
                    let rateValue = CGPoint(x: __frame.size.width/self.ctxs.clip.width, y: __frame.size.height/self.ctxs.clip.height)
                    if rateValue.x >= rateValue.y {
                        //宽度过大，收缩宽度
                        __frame.size.width = __frame.size.height * (self.ctxs.clip.width / self.ctxs.clip.height)
                    }
                    else {
                        __frame.size.height = __frame.size.width * (self.ctxs.clip.height / self.ctxs.clip.width)
                    }
                }
                
                //一次手势时间结束了
                if __frame.size.width >=  self.ctxs.line.width * 2.0 && __frame.size.height >= self.ctxs.line.width * 2.0 {
                    self.ctxs.clip.isHidden = false
                    
                    self.ctxs.frame.value = __frame
                    self.wrappedView.frame = self.ctxs.frame.value
                    self.wrappedView.isHidden = false
                    
                    self.panRecognizer.isEnabled = true
                    self.pinchRecognizer.isEnabled = true
                }
                else {
                    self.ctxs.clip.isHidden = true
                    
                    self.ctxs.frame.value = CGRect.zero
                    self.wrappedView.frame = self.ctxs.frame.value
                    self.wrappedView.isHidden = true
                    
                    self.panRecognizer.isEnabled = true
                    self.pinchRecognizer.isEnabled = false
                }
            }
        }
    }
    
    @objc func pinchRecognizerAction(_ pinchRecognizer: UIPinchGestureRecognizer) {
        if pinchRecognizer.state == .began || pinchRecognizer.state == .changed {

            var __ctxs : (center:CGPoint, scale:CGFloat, x:CGFloat, y:CGFloat, mX:CGFloat, mY:CGFloat) = (CGPoint.zero, 0.0, 0.0, 0.0, 0.0, 0.0)
            __ctxs.center = pinchRecognizer.location(in: self)
            __ctxs.scale = pinchRecognizer.scale
            __ctxs.x = self.wrappedView.x - __ctxs.center.x
            __ctxs.y = self.wrappedView.y - __ctxs.center.y
            __ctxs.mX = __ctxs.x * __ctxs.scale
            __ctxs.mY = __ctxs.y * __ctxs.scale

            var __frame = CGRect.zero
            __frame.origin.x = self.wrappedView.x + __ctxs.mX - __ctxs.x
            __frame.origin.y = self.wrappedView.y + __ctxs.mY - __ctxs.y
            __frame.size.width = self.wrappedView.w * __ctxs.scale
            __frame.size.height = self.wrappedView.h * __ctxs.scale
            
            if __frame.size.width >= self.ctxs.line.width * 2.0
                && __frame.size.height >= self.ctxs.line.width * 2.0
                && __frame.size.width <= self.ctxs.size.width
                && __frame.size.height <= self.ctxs.size.height {
                self.ctxs.frame.value = __frame
                self.wrappedView.frame = __frame
            }
        }
        else {
            var __frame = self.wrappedView.frame

            if __frame.width > self.ctxs.size.width {
                __frame.size.width = self.ctxs.size.width
                if self.ctxs.clip.isResizable == false {
                    __frame.size.height = __frame.size.width * (self.ctxs.clip.height / self.ctxs.clip.width)
                }
            }
            
            if __frame.height > self.ctxs.size.height {
                __frame.size.height = self.ctxs.size.height
                if self.ctxs.clip.isResizable == false {
                    __frame.size.width = __frame.size.height * (self.ctxs.clip.width / self.ctxs.clip.height)
                }
            }
            
            if __frame.minX < 0 {
                __frame.origin.x = 0
            }
            
            if __frame.maxX > self.ctxs.size.width {
                __frame.origin.x = self.ctxs.size.width - __frame.width
            }
            
            if __frame.minY < 0 {
                __frame.origin.y = 0
            }
            
            if __frame.maxY > self.ctxs.size.height {
                __frame.origin.y = self.ctxs.size.height - __frame.height
            }
            
            self.ctxs.frame.value = __frame
            UIView.animate(withDuration: 0.15) {
                self.wrappedView.frame = __frame
            }
        }
        
        pinchRecognizer.scale = 1.0
    }
    
    
}
