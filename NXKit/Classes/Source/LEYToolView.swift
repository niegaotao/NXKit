//
//  LEYToolView.swift
//  NXFoundation
//
//  Created by firelonely on 2018/7/2.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


open class LEYToolView: LEYBackgroundView<UIImageView, UIView> {
    open weak var controller : LEYToolViewController?
    public let wrapped = LEYToolView.Wrapped()
    public let centerView = LEYToolView.Bar(frame: CGRect(x: 0, y: 0, width: 56, height: 47))
        
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.contentView.setupSeparator(color: self.wrapped.separator.backgroundColor, side: .top, insets: .zero)
        self.contentView.addSubview(centerView)
    }
    
    override open func updateSubviews(_ action:String, _ value:Any?){
        if action == "elements" {
            guard let dicValue = value as? [String:Any] else {
                return
            }
            guard let __elements = dicValue["elements"] as? [LEYToolView.Element], __elements.count > 0 else {
                return
            }
            self.wrapped.elements.forEach { (element) in
                element.elementView.removeFromSuperview()
            }
            self.wrapped.elements = __elements
            self.wrapped.index = dicValue["index"] as? Int ?? 0
            
            if self.wrapped.center.isHidden == false {
                //如果想要显示中间的加大按钮，必须满足常规按钮的个数是偶数个
                self.wrapped.center.isHidden = (self.wrapped.elements.count % 2 != 0)
            }
            
            if self.wrapped.shadow.isHidden == false {
                //设置阴影
                self.layer.shadowColor = self.wrapped.shadow.color.cgColor;
                self.layer.shadowOffset = self.wrapped.shadow.offset
                self.layer.shadowRadius = self.wrapped.shadow.radius
                self.layer.shadowOpacity = Float(self.wrapped.shadow.opacity)
                self.layer.cornerRadius = self.layer.shadowRadius
                self.layer.masksToBounds = false
            }
            else {
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.masksToBounds = true
            }
            
            self.contentView.proxy?.separator?.isHidden = self.wrapped.separator.isHidden
            self.contentView.proxy?.separator?.backgroundColor = self.wrapped.separator.backgroundColor.cgColor
            
            self.centerView.centerView.image = self.wrapped.center.image
            self.centerView.isHidden = self.wrapped.center.isHidden
            self.centerView.frame = self.wrapped.center.frame
            
            if self.wrapped.center.isHidden == false {
                self.wrapped.width = self.w/CGFloat(self.wrapped.elements.count+1)
            }
            else {
                self.wrapped.width = self.w/CGFloat(self.wrapped.elements.count)
            }
            
            for (index, element) in self.wrapped.elements.enumerated() {
                element.ctxs.size = CGSize(width: self.wrapped.width, height: LEYDevice.toolViewOffset)
                element.elementView.isHidden = false
                element.elementView.frame = CGRect(x: self.wrapped.width * CGFloat(index), y: 0, width: self.wrapped.width, height: LEYDevice.toolViewOffset)
                if index >= self.wrapped.elements.count/2 && self.wrapped.center.isHidden == false {
                    element.elementView.frame = CGRect(x: self.wrapped.width * CGFloat(index+1), y: 0, width: self.wrapped.width, height: LEYDevice.toolViewOffset)
                }
                element.elementView.tag = index
                element.elementView.setupEvents([UIControl.Event.tap]) {[weak self] (e, v) in
                    
                    guard let __toolView = self,
                        let __elementView = v as? LEYToolView.ElementView,
                        let __ctxs = self?.wrapped,
                        __elementView.tag >= 0 && __elementView.tag < __ctxs.elements.count else {
                        return
                    }
                    
                    if __elementView.tag != __ctxs.index {
                        //切换选中
                        self?.didSelectElement(at: __elementView.tag)
                        self?.controller?.didSelectViewController(at: __elementView.tag, animated: false)
                        
                        //选中的回调
                        self?.wrapped.didSelectElement?(__toolView, __elementView.tag)
                    }
                    else{
                        //选中的回调
                        self?.wrapped.didSelectElement?(__toolView, __elementView.tag)
                        //处理连续的双击
                        self?.wrapped.didReselectElement?(__toolView, __elementView.tag)
                    }
                }
                self.contentView.addSubview(element.elementView)
            }
        }
        else if action == "index" {
            guard let dicValue = value as? [String:Any] else {
                return
            }
            let index = dicValue["index"] as? Int ?? 0
            self.wrapped.index = max(min(index, self.wrapped.elements.count), 0)
        }
        
        for (index, element) in self.wrapped.elements.enumerated() {
            element.elementView.isHidden = false
            element.isSelected = index == self.wrapped.index
            element.elementView.updateSubviews("", element)
        }
    }
    
    open func didSelectElement(at idx: Int){
        let newValue = max(min(idx, self.wrapped.elements.count), 0)
        guard self.wrapped.index != newValue else {return}
        
        let element = self.wrapped.elements[newValue]
        if element.isSelectable {
            self.wrapped.index = newValue
            
            if element.attachment.isResetable {
                element.attachment.value = 0
            }
            
            self.updateSubviews("", nil)
        }
    }
}

extension LEYToolView {
    open class Wrapped : NSObject {
        public fileprivate(set) var index : Int = 0
        public fileprivate(set) var width : CGFloat = 0
        public fileprivate(set) var elements = [LEYToolView.Element]()
        open var didSelectElement : LEYApp.Completion<LEYToolView, Int>? = nil //没次点击都会调用
        open var didReselectElement : LEYApp.Completion<LEYToolView, Int>? = nil //已经选中的再次点击
        
        public let separator = LEYApp.Separator { (_, __sender) in
            __sender.isHidden = false
            __sender.backgroundColor = LEYApp.separatorColor
        }
        
        public let shadow = LEYApp.Shadow { (_, __sender) in
            __sender.color = LEYApp.shadowColor
            __sender.isHidden = true
            __sender.offset = CGSize(width: 0, height: -2)
            __sender.radius = 2.0
            __sender.opacity = 0.15
        }
        
        public let center = LEYApp.Attribute { (_, __sender) in
            __sender.isHidden = true
        }
    }
    
    open class Bar : LEYControl {
        open var centerView = UIImageView(frame: CGRect.zero)
        override open func setupSubviews() {
            self.backgroundColor = UIColor.clear
            
            centerView.frame = self.bounds
            centerView.contentMode = .scaleAspectFill
            centerView.layer.cornerRadius = 0
            centerView.layer.masksToBounds = true
            self.addSubview(centerView)
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            centerView.frame = self.bounds
        }
    }
    
    open class Element : LEYItem {
        open var accessKey : String = ""
        
        open var title = LEYApp.Selectable<String>(completion: { (_, __sender) in
            __sender.selected = ""
            __sender.unselected = ""
        })
        
        open var color = LEYApp.SelectableObjectValue<UIColor>(completion: { (_, __sender) in
            __sender.selected = LEYApp.mainColor
            __sender.unselected = LEYApp.darkGrayColor
        })
        
        open var image = LEYApp.SelectableAnyValue<UIImage>(completion:  { (_, __sender) in
            __sender.selected = nil
            __sender.unselected = nil
        })
        
        open var space : CGFloat = 0.0
        
        open var isSelected  = false
        open var isSelectable = true

        //消息数量
        //消息背景色
        //消息前景色
        //是否直接显示数字
        //点击后数字是否清0
        open var attachment : (
            value:Int,
            backgroundColor:UIColor,
            color:UIColor,
            borderColor:UIColor,
            borderWidth:CGFloat,
            size:CGFloat,
            insets:UIEdgeInsets,
            isValue:Bool,
            isResetable:Bool) = (0, UIColor.red, UIColor.white, UIColor.red, 0, 11, UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5), true, false)
        
        open var elementView = LEYToolView.ElementView(frame: CGRect(x: 0, y: 0, width: LEYDevice.width/4.0, height: LEYDevice.toolViewOffset))
    }
    
    open class ElementView : LEYView {
        public let assetView  = UIImageView(frame: CGRect.zero)
        public let titleView  = UILabel(frame: CGRect.zero)
        public let markupView  = UILabel(frame: CGRect.zero)
        
        override open func setupSubviews() {
            super.setupSubviews()
            self.addSubview(assetView)
            
            titleView.font = LEYApp.font(11)
            titleView.textAlignment = .center
            self.addSubview(titleView)
            
            markupView.layer.masksToBounds = true
            markupView.textAlignment = .center
            self.addSubview(markupView)
        }
        
        override open func updateSubviews(_ action:String, _ value: Any?) {
            super.updateSubviews(action, value)
            
            guard let element = value as? LEYToolView.Element else {
                return
            }
            var __raw : (size:CGSize, height:CGFloat) = (CGSize(width: 28.0, height: 28.0), 14.0)
            if element.isSelected {
                if let __image = element.image.selected {
                    __raw.size.width = __image.size.width
                    __raw.size.height = __image.size.height
                }
            }
            else {
                if let __image = element.image.unselected {
                    __raw.size.width = __image.size.width
                    __raw.size.height = __image.size.height
                }
            }
            
            let space : CGFloat = __raw.size.height + element.space + __raw.height
            assetView.frame = CGRect(x: (element.ctxs.w-__raw.size.width)/2.0, y: (element.ctxs.h - space)/2.0, width: __raw.size.width, height: __raw.size.height)
            titleView.frame = CGRect(x: 0, y: assetView.frame.maxY + element.space, width: self.w, height: __raw.height)
            
            
            if element.isSelected {
                assetView.image = element.image.selected
                titleView.text = element.title.selected
                titleView.textColor = element.color.selected
            }
            else {
                assetView.image = element.image.unselected
                titleView.text = element.title.unselected
                titleView.textColor = element.color.unselected
            }
            
            if element.attachment.value > 0 {
                markupView.isHidden = false
                if element.attachment.isValue {
                    
                    var attachmentValue = "\(element.attachment.value)"
                    if element.attachment.value > 99 {
                        attachmentValue = "99+"
                    }
                    //6.87, 13.13
                    var __size = attachmentValue.stringSize(font: LEYApp.font(element.attachment.size), size: CGSize(width: 100, height: 100))
                    __size.width = max(element.attachment.insets.left, 0) + __size.width + max(element.attachment.insets.right, 0)
                    __size.height = max(element.attachment.insets.top, 0) + __size.height + max(element.attachment.insets.bottom, 0)
                    if __size.width < __size.height {
                        __size.width = __size.height
                    }
                    markupView.layer.borderWidth = element.attachment.borderWidth
                    markupView.layer.borderColor = element.attachment.borderColor.cgColor
                    markupView.layer.cornerRadius = __size.height/2.0
                    markupView.backgroundColor = element.attachment.backgroundColor
                    markupView.text = attachmentValue
                    markupView.textColor = element.attachment.color
                    markupView.font = LEYApp.font(element.attachment.size)
                    markupView.frame = CGRect(x: assetView.frame.maxX-__size.width/2.0, y: assetView.frame.minY, width: __size.width, height: __size.height)
                }
                else {
                    let __size = CGSize(width: 6, height: 6)
                    markupView.layer.borderWidth = 0
                    markupView.layer.cornerRadius = __size.height/2.0
                    markupView.backgroundColor = element.attachment.backgroundColor
                    markupView.text = ""
                    markupView.frame = CGRect(x: assetView.frame.maxX-__size.width, y: assetView.frame.minY, width: __size.width, height: __size.height)
                }
            }
            else {
                markupView.isHidden = true
            }
        }
    }
}
