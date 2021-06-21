//
//  LEYActionView.swift
//  NXFoundation
//
//  Created by firelonely on 2018/5/31.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


extension LEYActionView {
    public enum Key : String {
        public enum Center : String {
            case alert = "center.alert"             //中部弹框
            case customize = "center.customize"     //中部弹出自定义样式
        }
        public enum Footer : String {
            case action = "footer.action"           //底部弹出一横排的排列
            case mix = "footer.mix"                 //底部弹出混合式排列
            case customize = "footer.customize"     //底部弹出自定义样式
        }
        case unknown = "unknown"
    }
    
    open class Wrapped<H:LEYActionView.HeaderView, C:LEYActionView.CenterView, F:LEYActionView.FooterView> {
        open var attributeKey = LEYActionView.Key.Footer.action.rawValue
        open var header = LEYActionView.Appearance<H>()
        open var center = LEYActionView.Appearance<C>()
        open var footer = LEYActionView.Appearance<F>()
        open var size = CGSize(width: 0, height: 0)
        open var devide = CGFloat(6.0) //底部分开的高度，默认是6pt(只有在底部高度>0的时候有效)
        open var max = LEYDevice.height * 0.80
    }
    
    open class Component : NSObject {
        open var attributeKey = LEYActionView.Key.Footer.action.rawValue
        open var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        open var backgroundColor : UIColor = LEYApp.backgroundColor
        open var isHidden : Bool = false
        open var isAnimation : Bool = true
        
        public let title = LEYApp.Attribute { (_, __attribute) in
            __attribute.textAlignment = .center
            __attribute.font = LEYApp.font(18, true)
            __attribute.color = LEYApp.darkBlackColor
        }
        
        public let lhs = LEYApp.Attribute { (_, __attribute) in
            __attribute.frame = CGRect(x: 16, y: (60-44)/2, width: 84, height: 44)
            __attribute.font = LEYApp.font(16, false)
            __attribute.color = LEYApp.mainColor
            __attribute.textAlignment = .left
        }
        
        public let center = LEYApp.Attribute { (_, __attribute) in
            __attribute.frame = CGRect(x: 100, y: (60-44)/2, width: LEYDevice.width-200, height: 44)
            __attribute.font = LEYApp.font(16, true)
            __attribute.color = LEYApp.darkBlackColor
            __attribute.textAlignment = .center
        }
        
        public let rhs = LEYApp.Attribute { (_, __attribute) in
            __attribute.frame = CGRect(x: LEYDevice.width-16-84, y: (60-44)/2, width: 84, height: 44)
            __attribute.color = LEYApp.mainColor
            __attribute.textAlignment = .right
        }
        
        public let separator = LEYApp.Separator{(_, __attribute) in
            
        }
        
        open var customView: UIView? = nil
        
        open var actions = [LEYAction]()
        open var insets = UIEdgeInsets.zero
        
        convenience public init(actions:[LEYAction]) {
            self.init()
            self.actions = actions
            self.frame.size = CGSize(width: LEYDevice.width, height: 0)
        }
        
        open class func size(_ appearance:LEYActionView.Component) -> CGSize {
            var contentSize = CGSize(width: appearance.frame.width, height: 0)
            if appearance.attributeKey == LEYActionView.Key.Center.alert.rawValue {
                if appearance.actions.count == 2 {
                    for index in 0...1 {
                        let action = appearance.actions[index]
                        action.ctxs.w = appearance.frame.width * 0.5
                        action.title.frame = CGRect(x: 0, y: 0, width: action.ctxs.w, height: action.ctxs.h)
                        action.appearance.isHighlighted = true
                        action.appearance.isEnabled = true
                        if(index == 0){
                            action.separator.side = .right
                        }
                        else{
                            action.separator.side = []
                        }
                        contentSize.height = action.ctxs.h
                    }
                }
                else {
                    //1个/3个/4个
                    for index in 0...appearance.actions.count-1 {
                        let action = appearance.actions[index]
                        action.ctxs.w = appearance.frame.width
                        action.title.frame = CGRect(x: 0, y: 0, width: action.ctxs.w, height: action.ctxs.h)
                        action.appearance.isHighlighted = true
                        action.appearance.isEnabled = true
                        action.separator.side = (index == appearance.actions.count-1) ? [] : .bottom;
                        
                        contentSize.height = contentSize.height + action.ctxs.h
                    }
                }
                appearance.isAnimation = false
            }
            else if appearance.attributeKey == LEYActionView.Key.Footer.action.rawValue {
                for (index, action) in appearance.actions.enumerated() {
                    action.ctxs.w = appearance.frame.width;
                    action.separator.side = (index == appearance.actions.count-1) ? []: .bottom;
                    
                    contentSize.height = contentSize.height + action.ctxs.h
                }
            }
            else if appearance.attributeKey == LEYActionView.Key.Footer.mix.rawValue {
                var offsetValue : (x:CGFloat, y:CGFloat, max:CGFloat) = (0,0,0)
                for (idx, action) in appearance.actions.enumerated() {
                    if offsetValue.x + action.ctxs.w <= appearance.frame.width {
                        //可以排在同一行
                        offsetValue.x = offsetValue.x + action.ctxs.w
                        if offsetValue.max < action.ctxs.h {
                            offsetValue.max = action.ctxs.h
                        }
                    }
                    else {
                        //新开一行
                        offsetValue.y = offsetValue.y + offsetValue.max
                        
                        offsetValue.x = action.ctxs.w
                        offsetValue.max = action.ctxs.h
                    }
                    if idx == appearance.actions.count - 1 {
                        offsetValue.y = offsetValue.y + offsetValue.max
                    }
                }
                contentSize.height = contentSize.height + offsetValue.y
            }
            else if let __customView = appearance.customView {
                contentSize.height = __customView.frame.size.height
            }
            else {
                contentSize.height = 0.0
            }
            contentSize.height = contentSize.height + appearance.insets.top + appearance.insets.bottom
            return contentSize
        }
    }
    
    open class Appearance<ComponentView:UIView> : Component {
        public let componentView = ComponentView(frame:CGRect.zero)
    }
}

open class LEYActionView: LEYOverlay {
    public let wrapped = LEYActionView.Wrapped<LEYActionView.HeaderView, LEYActionView.CenterView, LEYActionView.FooterView>()
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        //0.背景
        self.backgroundView.setupEvents([.touchUpInside], action: { [weak self] (event, sender) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: { (isCompleted) in
                __weakself.closeCompletion?("background", nil)
            })
        })
        
        //1.头部
        self.wrapped.header.componentView.isHidden = true
        self.wrapped.header.componentView.lhsView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("header.lhs", nil)
            })
        }
        self.wrapped.header.componentView.rhsView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("header.rhs", nil)
            })
        }
        self.contentView.addSubview(self.wrapped.header.componentView)
        
        //2.中间
        self.wrapped.center.componentView.isHidden = true
        self.wrapped.center.componentView.completion = {[weak self] (_ action:LEYAction, _ index: Int) in
            guard let __weakself = self else { return }
            if action.appearance.isCloseable {
                __weakself.close(animation: __weakself.animation, completion: { (isCompleted) in
                    __weakself.completion?("", index)
                })
            }
            else {
                __weakself.completion?("", index)
            }
        }
        self.contentView.addSubview(self.wrapped.center.componentView)
        
        //3.脚部
        self.wrapped.footer.componentView.isHidden = true
        self.wrapped.footer.componentView.lhsView.setupEvents([.touchUpInside]) { [weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("footer.lhs", nil)
            })
        }
        self.wrapped.footer.componentView.centerView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("footer.center", nil)
            })
        }
        self.wrapped.footer.componentView.rhsView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("footer.rhs", nil)
            })
        }
        self.contentView.addSubview(self.wrapped.footer.componentView)
    }
    
    open override func updateSubviews(_ action: LEYActionView.Key.RawValue, _ value: Any?) {
        self.wrapped.attributeKey = action
        self.wrapped.footer.attributeKey = action
        self.wrapped.center.attributeKey = action
        self.wrapped.footer.attributeKey = action
        
        if self.wrapped.attributeKey.contains("center") {
            self.animation = LEYOverlay.Animation.center.rawValue
        }
        else if self.wrapped.attributeKey.contains("footer"){
            self.animation = LEYOverlay.Animation.footer.rawValue
        }
        
        
        //1-1.顶部视图部分
        if self.wrapped.attributeKey.contains("center") {
            self.wrapped.size = CGSize(width: LEYDevice.width * 0.8, height: 0.0)
            self.contentView.layer.cornerRadius = 8
            self.contentView.layer.masksToBounds = true
            self.contentView.backgroundColor = LEYApp.backgroundColor
            self.backgroundView.isUserInteractionEnabled = false
        }
        else if self.wrapped.attributeKey.contains("footer"){
            if self.wrapped.devide > 0 {
                self.contentView.backgroundColor = LEYApp.contentViewBackgroundColor
            }
            else {
                self.contentView.backgroundColor = LEYApp.backgroundColor
            }
            self.wrapped.size = CGSize(width: LEYDevice.width * 1.0, height: 0.0)
        }
        
        self.wrapped.header.frame.size.width = self.wrapped.size.width
        self.wrapped.footer.frame.size.width = self.wrapped.size.width
        self.wrapped.center.frame.size.width = self.wrapped.size.width
        
        
        self.wrapped.center.frame.size.height = LEYActionView.Component.size(self.wrapped.center).height
        self.wrapped.center.frame.size.height = min(self.wrapped.center.frame.height, self.wrapped.max - wrapped.header.frame.size.height - self.wrapped.footer.frame.height) //最优高度

        //1
        if self.wrapped.header.frame.size.height > 0 {
            self.wrapped.header.frame.origin = CGPoint(x: 0, y: 0)
            self.wrapped.header.componentView.frame = self.wrapped.header.frame
            self.wrapped.size.height = self.wrapped.size.height + self.wrapped.header.frame.size.height
            
            self.wrapped.header.componentView.updateSubviews("update",self.wrapped.header)
            self.wrapped.header.componentView.isHidden = false
        }
        else{
            self.wrapped.header.componentView.isHidden = true
        }
        
        //2-2
        if self.wrapped.center.frame.size.height > 0 {
            self.wrapped.center.frame.origin = CGPoint(x: 0, y: self.wrapped.size.height)
            self.wrapped.center.componentView.frame = self.wrapped.center.frame
            self.wrapped.size.height = self.wrapped.size.height + self.wrapped.center.frame.size.height
            
            self.wrapped.center.componentView.updateSubviews("update", self.wrapped.center)
            self.wrapped.center.componentView.isHidden = false
        }
        else {
            self.wrapped.center.componentView.isHidden = true
        }
        
        //2-3
        if self.wrapped.footer.frame.size.height > 0 {
            self.wrapped.size.height = self.wrapped.size.height + wrapped.devide
            
            self.wrapped.footer.frame.origin = CGPoint(x: 0, y: self.wrapped.size.height)
            self.wrapped.footer.componentView.frame = self.wrapped.footer.frame
            self.wrapped.size.height = self.wrapped.size.height + self.wrapped.footer.frame.size.height
            
            self.wrapped.footer.componentView.updateSubviews("update", self.wrapped.footer)
            self.wrapped.footer.componentView.isHidden = false
        }
        else{
            self.wrapped.footer.componentView.isHidden = true
        }
        
        if self.wrapped.attributeKey.contains("center") {
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.wrapped.size.width)/2.0, y: (self.frame.size.height-self.wrapped.size.height)/2.0, width: self.wrapped.size.width, height: self.wrapped.size.height)
        }
        else if self.wrapped.attributeKey.contains("footer"){
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.wrapped.size.width)/2.0, y: self.frame.size.height-self.wrapped.size.height, width: self.wrapped.size.width, height: self.wrapped.size.height)
        }
    }
}
