//
//  NXToolView.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit


open class NXToolView: NXBackgroundView<UIImageView, UIView> {
    open weak var controller : NXToolViewController?
    public let ctxs = NXToolView.Wrapped()
    public let centerView = NXToolView.Bar(frame: CGRect(x: 0, y: 0, width: 56, height: 47))
        
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.contentView.setupSeparator(color: self.ctxs.separator.backgroundColor, ats: .minY, insets: .zero)
        self.contentView.addSubview(centerView)
    }
    
    override open func updateSubviews(_ action:String, _ value:Any?){
        if action == "elements" {
            guard let dicValue = value as? [String:Any] else {
                return
            }
            guard let __elements = dicValue["elements"] as? [NXToolView.Element], __elements.count > 0 else {
                return
            }
            self.ctxs.elements.forEach { (element) in
                element.elementView.removeFromSuperview()
            }
            self.ctxs.elements = __elements
            self.ctxs.index = dicValue["index"] as? Int ?? 0
            
            if self.ctxs.center.isHidden == false {
                //如果想要显示中间的加大按钮，必须满足常规按钮的个数是偶数个
                self.ctxs.center.isHidden = (self.ctxs.elements.count % 2 != 0)
            }
            
            if self.ctxs.layer.isHidden == false {
                //设置阴影
                self.layer.shadowColor = self.ctxs.layer.shadowColor.cgColor;
                self.layer.shadowOffset = self.ctxs.layer.shadowOffset
                self.layer.shadowRadius = self.ctxs.layer.shadowRadius
                self.layer.shadowOpacity = Float(self.ctxs.layer.shadowOpacity)
                self.layer.cornerRadius = self.layer.shadowRadius
                self.layer.masksToBounds = false
            }
            else {
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.masksToBounds = true
            }
            
            self.contentView.association?.separator?.isHidden = self.ctxs.separator.isHidden
            self.contentView.association?.separator?.backgroundColor = self.ctxs.separator.backgroundColor.cgColor
            
            self.centerView.centerView.image = self.ctxs.center.image
            self.centerView.isHidden = self.ctxs.center.isHidden
            self.centerView.frame = self.ctxs.center.frame
            
            if self.ctxs.center.isHidden == false {
                self.ctxs.width = self.w/CGFloat(self.ctxs.elements.count+1)
            }
            else {
                self.ctxs.width = self.w/CGFloat(self.ctxs.elements.count)
            }
            
            for (index, element) in self.ctxs.elements.enumerated() {
                element.size = CGSize(width: self.ctxs.width, height: NXUI.toolViewOffset)
                element.elementView.isHidden = false
                element.elementView.frame = CGRect(x: self.ctxs.width * CGFloat(index), y: 0, width: self.ctxs.width, height: NXUI.toolViewOffset)
                if index >= self.ctxs.elements.count/2 && self.ctxs.center.isHidden == false {
                    element.elementView.frame = CGRect(x: self.ctxs.width * CGFloat(index+1), y: 0, width: self.ctxs.width, height: NXUI.toolViewOffset)
                }
                element.elementView.tag = index
                element.elementView.setupEvents([UIControl.Event.tap]) {[weak self] (e, v) in
                    
                    guard let __toolView = self,
                        let __elementView = v as? NXToolView.ElementView,
                        let __ctxs = self?.ctxs,
                        __elementView.tag >= 0 && __elementView.tag < __ctxs.elements.count else {
                        return
                    }
                    
                    if __elementView.tag != __ctxs.index {
                        //切换选中
                        self?.didSelect(at: __elementView.tag)
                        self?.controller?.didSelectViewController(at: __elementView.tag, animated: false)
                        
                        //选中的回调
                        self?.ctxs.didSelect?(__toolView, __elementView.tag)
                    }
                    else{
                        //选中的回调
                        self?.ctxs.didSelect?(__toolView, __elementView.tag)
                        //处理连续的双击
                        self?.ctxs.didReselect?(__toolView, __elementView.tag)
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
            self.ctxs.index = max(min(index, self.ctxs.elements.count), 0)
        }
        
        for (index, element) in self.ctxs.elements.enumerated() {
            element.elementView.isHidden = false
            element.isSelected = index == self.ctxs.index
            element.elementView.updateSubviews("", element)
        }
    }
    
    open func didSelect(at idx: Int){
        let newValue = max(min(idx, self.ctxs.elements.count), 0)
        guard self.ctxs.index != newValue else {return}
        
        let element = self.ctxs.elements[newValue]
        if element.isSelectable {
            self.ctxs.index = newValue
            
            if element.attachment.isResetable {
                element.attachment.value = 0
            }
            
            self.updateSubviews("", nil)
        }
    }
}

extension NXToolView {
    open class Wrapped : NSObject {
        public fileprivate(set) var index : Int = 0
        public fileprivate(set) var width : CGFloat = 0
        public fileprivate(set) var elements = [NXToolView.Element]()
        open var didSelect : NX.Completion<NXToolView, Int>? = nil //没次点击都会调用
        open var didReselect : NX.Completion<NXToolView, Int>? = nil //已经选中的再次点击
        
        public let separator = NX.Separator { (_, __sender) in
            __sender.isHidden = false
            __sender.backgroundColor = NX.separatorColor
        }
        
        public let layer = NX.Layer { (_, __sender) in
            __sender.isHidden = true
            __sender.shadowColor = NX.shadowColor
            __sender.shadowOffset = CGSize(width: 0, height: -2)
            __sender.shadowRadius = 2.0
            __sender.shadowOpacity = 0.15
        }
        
        public let center = NX.Attribute { (_, __sender) in
            __sender.isHidden = true
        }
    }
    
    open class Bar : NXControl {
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
    
    open class Element : NX.Rect {
        open var key : String = ""
        
        open var title = NX.Selectable<String>(completion: { (_, __sender) in
            __sender.selected = ""
            __sender.unselected = ""
        })
        
        open var color = NX.Selectable<UIColor>(completion: { (_, __sender) in
            __sender.selected = NX.mainColor
            __sender.unselected = NX.darkGrayColor
        })
        
        open var image = NX.Selectable<UIImage>(completion:  { (_, __sender) in
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
        
        open var elementView = NXToolView.ElementView(frame: CGRect(x: 0, y: 0, width: NXUI.width/4.0, height: NXUI.toolViewOffset))
    }
    
    open class ElementView : NXView {
        public let assetView  = UIImageView(frame: CGRect.zero)
        public let titleView  = UILabel(frame: CGRect.zero)
        public let markupView  = UILabel(frame: CGRect.zero)
        
        override open func setupSubviews() {
            super.setupSubviews()
            self.addSubview(assetView)
            
            titleView.font = NX.font(11)
            titleView.textAlignment = .center
            self.addSubview(titleView)
            
            markupView.layer.masksToBounds = true
            markupView.textAlignment = .center
            self.addSubview(markupView)
        }
        
        override open func updateSubviews(_ action:String, _ value: Any?) {
            super.updateSubviews(action, value)
            
            guard let element = value as? NXToolView.Element else {
                return
            }
            var __raw : (size:CGSize, height:CGFloat) = (CGSize(width: 28.0, height: 28.0), 14.0)
            if element.isSelected {
                __raw.size = element.image.selected.size
            }
            else {
                __raw.size = element.image.unselected.size
            }
            
            let space : CGFloat = __raw.size.height + element.space + __raw.height
            assetView.frame = CGRect(x: (element.width-__raw.size.width)/2.0, y: (element.height - space)/2.0, width: __raw.size.width, height: __raw.size.height)
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
                    var __size = attachmentValue.stringSize(font: NX.font(element.attachment.size), size: CGSize(width: 100, height: 100))
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
                    markupView.font = NX.font(element.attachment.size)
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
