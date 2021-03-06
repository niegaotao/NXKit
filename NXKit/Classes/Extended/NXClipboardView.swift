//
//  NXClipboardView.swift
//  NXKit
//
//  Created by firelonely on 2020/11/26.
//

import UIKit

open class NXClipboardView: NXView {
    open class Line {
        open var width : CGFloat = 10.0
        open var insets : CGFloat =  8.0
        
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
        open var clip = NXAsset.Clip(isResizable: false, width: 1.0, height: 1.0, isHidden: false)
        //线条相关属性
        open var line = NXClipboardView.Line()
        //边
        open var side = NXApp.Rect.Side.unspefified
        //框选区域的frame
        public let frame = NXApp.Wrapped<Bool, CGRect> { (_, __sender) in
            __sender.initialValue = CGRect.zero;__sender.value = CGRect.zero;}
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
        
        public let minXView = NXCView<UIView>(frame: CGRect.zero)
        public let maxXView = NXCView<UIView>(frame: CGRect.zero)
        public let minYView = NXCView<UIView>(frame: CGRect.zero)
        public let maxYView = NXCView<UIView>(frame: CGRect.zero)
        
        open override func setupSubviews() {
            self.minXTHSView.backgroundColor = NXApp.mainColor
            self.minXTHSView.isUserInteractionEnabled = false
            self.addSubview(self.minXTHSView)
            
            self.minXBHSView.backgroundColor = NXApp.mainColor
            self.minXBHSView.isUserInteractionEnabled = false
            self.addSubview(self.minXBHSView)
            
            self.maxXTHSView.backgroundColor = NXApp.mainColor
            self.maxXTHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxXTHSView)
            
            self.maxXBHSView.backgroundColor = NXApp.mainColor
            self.maxXBHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxXBHSView)
            
            self.minYLHSView.backgroundColor = NXApp.mainColor
            self.minYLHSView.isUserInteractionEnabled = false
            self.addSubview(self.minYLHSView)
            
            self.minYRHSView.backgroundColor = NXApp.mainColor
            self.minYRHSView.isUserInteractionEnabled = false
            self.addSubview(self.minYRHSView)
            
            self.maxYLHSView.backgroundColor = NXApp.mainColor
            self.maxYLHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxYLHSView)
            
            self.maxYRHSView.backgroundColor = NXApp.mainColor
            self.maxYRHSView.isUserInteractionEnabled = false
            self.addSubview(self.maxYRHSView)
            
            self.minXView.autoinsetsSubviews = true
            self.minXView.backgroundColor = UIColor.clear
            self.minXView.contentView.backgroundColor = NXApp.mainColor
            self.addSubview(self.minXView)
            
            self.maxXView.autoinsetsSubviews = true
            self.maxXView.backgroundColor = UIColor.clear
            self.maxXView.contentView.backgroundColor = NXApp.mainColor
            self.addSubview(self.maxXView)
            
            self.minYView.autoinsetsSubviews = true
            self.minYView.backgroundColor = UIColor.clear
            self.minYView.contentView.backgroundColor = NXApp.mainColor
            self.addSubview(self.minYView)
            
            self.maxYView.autoinsetsSubviews = true
            self.maxYView.backgroundColor = UIColor.clear
            self.maxYView.contentView.backgroundColor = NXApp.mainColor
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
    

    public let wrapped = NXClipboardView.Wrapped()
    public let wrappedView = NXClipboardView.WrappedView(frame:CGRect.zero)
    public let panRecognizer = UIPanGestureRecognizer()
    public let point = NXApp.Wrapped<UIGestureRecognizer.State, CGPoint>{ (_, __sender) in
        __sender.index = UIGestureRecognizer.State.possible;__sender.initialValue = CGPoint.zero;__sender.value = CGPoint.zero;}
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
        
        if self.wrapped.clip.width <= 0 || self.wrapped.clip.height <= 0 {
            self.wrapped.clip.width = 1.0
            self.wrapped.clip.height = 1.0
        }
        
        self.wrappedView.minXView.w = self.wrapped.line.width
        self.wrappedView.minXView.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.wrapped.line.insets)
        
        self.wrappedView.maxXView.w = self.wrapped.line.width
        self.wrappedView.maxXView.insets = UIEdgeInsets(top: 0, left: self.wrapped.line.insets, bottom: 0, right: 0)
        
        self.wrappedView.minYView.h = self.wrapped.line.width
        self.wrappedView.minYView.insets = UIEdgeInsets(top: 0, left: 0, bottom: self.wrapped.line.insets, right: 0)
        
        self.wrappedView.maxYView.h = self.wrapped.line.width
        self.wrappedView.maxYView.insets = UIEdgeInsets(top: self.wrapped.line.insets, left: 0, bottom: 0, right: 0)
        
        self.wrappedView.minYLHSView.w = self.wrapped.line.width * 2.0
        self.wrappedView.minYLHSView.h = self.wrapped.line.width * 0.5
        
        self.wrappedView.minYRHSView.w = self.wrapped.line.width * 2.0
        self.wrappedView.minYRHSView.h = self.wrapped.line.width * 0.5

        self.wrappedView.maxYLHSView.w = self.wrapped.line.width * 2.0
        self.wrappedView.maxYLHSView.h = self.wrapped.line.width * 0.5
        
        self.wrappedView.maxYRHSView.w = self.wrapped.line.width * 2.0
        self.wrappedView.maxYRHSView.h = self.wrapped.line.width * 0.5
        
        self.wrappedView.minXTHSView.w = self.wrapped.line.width * 0.5
        self.wrappedView.minXTHSView.h = self.wrapped.line.width * 2.0
        
        self.wrappedView.minXBHSView.w = self.wrapped.line.width * 0.5
        self.wrappedView.minXBHSView.h = self.wrapped.line.width * 2.0
        
        self.wrappedView.maxXTHSView.w = self.wrapped.line.width * 0.5
        self.wrappedView.maxXTHSView.h = self.wrapped.line.width * 2.0
        
        self.wrappedView.maxXBHSView.w = self.wrapped.line.width * 0.5
        self.wrappedView.maxXBHSView.h = self.wrapped.line.width * 2.0
        
        if self.wrapped.clip.isHidden == false {
            self.wrappedView.isHidden = false
            
            let pfsValue = NXApp.Rect(completion:nil)
            pfsValue.x = self.wrapped.clip.width / self.wrapped.size.width
            pfsValue.y = self.wrapped.clip.height / self.wrapped.size.height
            if pfsValue.x >= pfsValue.y {
                //宽度撑满
                pfsValue.width = self.wrapped.size.width
                pfsValue.height = pfsValue.width * (self.wrapped.clip.height / self.wrapped.clip.width)
            }
            else {
                //高度撑满
                pfsValue.height = self.wrapped.size.height
                pfsValue.width = pfsValue.height * (self.wrapped.clip.width / self.wrapped.clip.height)
            }
            self.wrapped.frame.initialValue = CGRect(x:(self.wrapped.size.width - pfsValue.width)/2.0, y:(self.wrapped.size.height - pfsValue.height)/2.0, width:pfsValue.width, height:pfsValue.height)
            self.wrapped.frame.value = self.wrapped.frame.initialValue
            self.wrappedView.frame = self.wrapped.frame.value
            
            self.panRecognizer.isEnabled = true
            self.pinchRecognizer.isEnabled = true
        }
        else {
            self.wrappedView.isHidden = true
            
            self.wrapped.frame.initialValue = CGRect.zero
            self.wrapped.frame.value = self.wrapped.frame.initialValue
            self.wrappedView.frame = self.wrapped.frame.value

            self.panRecognizer.isEnabled = true
            self.pinchRecognizer.isEnabled = false
        }
        
        self.wrappedView.setNeedsLayout()
        
        self.setNeedsLayout()
    }
    
    @objc func panRecognizerAction(_ panRecognizer:UIPanGestureRecognizer) {
        let __translation = panRecognizer.translation(in: self)
        self.point.index = panRecognizer.state
        self.point.value = panRecognizer.location(in: self)
        panRecognizer.setTranslation(CGPoint.zero, in: self)
        
        if self.point.index == .began {
            self.point.initialValue = self.point.value
        }
        
        if self.wrapped.clip.isHidden == false {
            if self.point.index == .began {
                
                if self.wrapped.clip.isResizable && self.wrappedView.convert(self.wrappedView.minXView.frame, to: self).contains(self.point.initialValue) {
                    self.wrapped.side = .minX
                }
                else if self.wrapped.clip.isResizable && self.wrappedView.convert(self.wrappedView.maxXView.frame, to: self).contains(self.point.initialValue) {
                    self.wrapped.side = .maxX
                }
                else if self.wrapped.clip.isResizable && self.wrappedView.convert(self.wrappedView.minYView.frame, to: self).contains(self.point.initialValue) {
                    self.wrapped.side = .minY
                }
                else if self.wrapped.clip.isResizable && self.wrappedView.convert(self.wrappedView.maxYView.frame, to: self).contains(self.point.initialValue) {
                    self.wrapped.side = .maxY
                }
                else {
                    self.wrapped.side = .center
                }
            }
            
            if self.point.index == .began || self.point.index == .changed {
                if self.wrapped.side == .center {
                    self.wrappedView.center = CGPoint(x: self.wrappedView.center.x + __translation.x, y: self.wrappedView.center.y + __translation.y)
                    self.wrapped.frame.value = self.wrappedView.frame
                }
                else if self.wrapped.side == .minX {
                    var __frame = self.wrappedView.frame
                    __frame.origin.x = __frame.origin.x + __translation.x
                    __frame.size.width = __frame.size.width - __translation.x
                    if __frame.size.width >= self.wrapped.line.width * 2.0
                        && __frame.size.width <= self.wrapped.size.width {
                        self.wrapped.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
                else if self.wrapped.side == .maxX {
                    var __frame = self.wrappedView.frame
                    __frame.size.width = __frame.size.width + __translation.x
                    if __frame.size.width >= self.wrapped.line.width * 2.0
                        && __frame.size.width <= self.wrapped.size.width {
                        self.wrapped.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
                else if self.wrapped.side == .minY {
                    var __frame = self.wrappedView.frame
                    __frame.origin.y = __frame.origin.y + __translation.y
                    __frame.size.height = __frame.size.height - __translation.y
                    if __frame.size.height >= self.wrapped.line.width * 2.0
                        && __frame.size.height <= self.wrapped.size.height {
                        self.wrapped.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
                else if self.wrapped.side == .maxY {
                    var __frame = self.wrappedView.frame
                    __frame.size.height = __frame.size.height + __translation.y
                    if __frame.size.height >= self.wrapped.line.width * 2.0
                        && __frame.size.height <= self.wrapped.size.height {
                        self.wrapped.frame.value = __frame
                        self.wrappedView.frame = __frame
                    }
                }
            }
            else {
                var __frame = self.wrappedView.frame
                if __frame.width > self.wrapped.size.width {
                    __frame.size.width = self.wrapped.size.width
                    if self.wrapped.clip.isResizable == false {
                        __frame.size.height = __frame.size.width * (self.wrapped.clip.height / self.wrapped.clip.width)
                    }
                }
                
                if __frame.height > self.wrapped.size.height {
                    __frame.size.height = self.wrapped.size.height
                    if self.wrapped.clip.isResizable == false {
                        __frame.size.width = __frame.size.height * (self.wrapped.clip.width / self.wrapped.clip.height)
                    }
                }
                if __frame.minX < 0 {
                    __frame.origin.x = 0
                }
                
                if __frame.maxX > self.wrapped.size.width {
                    __frame.origin.x = self.wrapped.size.width - __frame.width
                }
                
                if __frame.minY < 0 {
                    __frame.origin.y = 0
                }
                
                if __frame.maxY > self.wrapped.size.height {
                    __frame.origin.y =  self.wrapped.size.height - __frame.height
                }
                self.wrapped.frame.value = __frame
                UIView.animate(withDuration: 0.15) {
                    self.wrappedView.frame = __frame
                }
            }
        }
        else {
            var __frame = CGRect.zero
            if self.point.initialValue.x <= self.point.value.x {
                __frame.origin.x = self.point.initialValue.x
                __frame.size.width = self.point.value.x - self.point.initialValue.x
            }
            else {
                __frame.origin.x = self.point.value.x
                __frame.size.width = self.point.initialValue.x - self.point.value.x
            }
            
            if self.point.initialValue.y <= self.point.value.y {
                __frame.origin.y = self.point.initialValue.y
                __frame.size.height = self.point.value.y - self.point.initialValue.y
            }
            else {
                __frame.origin.y = self.point.value.y
                __frame.size.height = self.point.initialValue.y - self.point.value.y
            }
            
            if __frame.minX < 0 {
                __frame.origin.x = 0
            }
            
            if __frame.maxX > self.wrapped.size.width {
                __frame.size.width = self.wrapped.size.width - __frame.origin.x
            }
            
            if __frame.minY < 0 {
                __frame.origin.y = 0
            }
            
            if __frame.maxY > self.wrapped.size.height {
                __frame.size.height = self.wrapped.size.height - __frame.origin.y
            }
            
            if self.point.index == .began || self.point.index == .changed {
                self.wrapped.frame.value = __frame
                self.wrappedView.frame = self.wrapped.frame.value
                self.wrappedView.isHidden = false
            }
            else {
                if self.wrapped.clip.isResizable == false {
                    //不动左上角,缩小比例
                    let rateValue = CGPoint(x: __frame.size.width/self.wrapped.clip.width, y: __frame.size.height/self.wrapped.clip.height)
                    if rateValue.x >= rateValue.y {
                        //宽度过大，收缩宽度
                        __frame.size.width = __frame.size.height * (self.wrapped.clip.width / self.wrapped.clip.height)
                    }
                    else {
                        __frame.size.height = __frame.size.width * (self.wrapped.clip.height / self.wrapped.clip.width)
                    }
                }
                
                //一次手势时间结束了
                if __frame.size.width >=  self.wrapped.line.width * 2.0 && __frame.size.height >= self.wrapped.line.width * 2.0 {
                    self.wrapped.clip.isHidden = false
                    
                    self.wrapped.frame.value = __frame
                    self.wrappedView.frame = self.wrapped.frame.value
                    self.wrappedView.isHidden = false
                    
                    self.panRecognizer.isEnabled = true
                    self.pinchRecognizer.isEnabled = true
                }
                else {
                    self.wrapped.clip.isHidden = true
                    
                    self.wrapped.frame.value = CGRect.zero
                    self.wrappedView.frame = self.wrapped.frame.value
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
            
            if __frame.size.width >= self.wrapped.line.width * 2.0
                && __frame.size.height >= self.wrapped.line.width * 2.0
                && __frame.size.width <= self.wrapped.size.width
                && __frame.size.height <= self.wrapped.size.height {
                self.wrapped.frame.value = __frame
                self.wrappedView.frame = __frame
            }
        }
        else {
            var __frame = self.wrappedView.frame

            if __frame.width > self.wrapped.size.width {
                __frame.size.width = self.wrapped.size.width
                if self.wrapped.clip.isResizable == false {
                    __frame.size.height = __frame.size.width * (self.wrapped.clip.height / self.wrapped.clip.width)
                }
            }
            
            if __frame.height > self.wrapped.size.height {
                __frame.size.height = self.wrapped.size.height
                if self.wrapped.clip.isResizable == false {
                    __frame.size.width = __frame.size.height * (self.wrapped.clip.width / self.wrapped.clip.height)
                }
            }
            
            if __frame.minX < 0 {
                __frame.origin.x = 0
            }
            
            if __frame.maxX > self.wrapped.size.width {
                __frame.origin.x = self.wrapped.size.width - __frame.width
            }
            
            if __frame.minY < 0 {
                __frame.origin.y = 0
            }
            
            if __frame.maxY > self.wrapped.size.height {
                __frame.origin.y = self.wrapped.size.height - __frame.height
            }
            
            self.wrapped.frame.value = __frame
            UIView.animate(withDuration: 0.15) {
                self.wrappedView.frame = __frame
            }
        }
        
        pinchRecognizer.scale = 1.0
    }
    
    
}
