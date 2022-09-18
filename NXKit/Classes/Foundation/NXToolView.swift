//
//  NXToolView.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit


open class NXToolView: NXBackgroundView<UIImageView, UIView> {
    open weak var controller : NXToolViewController?
    public fileprivate(set) var index : Int = 0
    open var didSelect : NX.Completion<Int, Int>? = nil //每次点击都会调用
    public let separator = NX.Separator { (_, __sender) in
        __sender.isHidden = false
        __sender.backgroundColor = NX.separatorColor
    }
    
    public let shadow = NX.Layer { (_, __sender) in
        __sender.isHidden = true
        __sender.shadowColor = NX.shadowColor
        __sender.shadowOffset = CGSize(width: 0, height: -2)
        __sender.shadowRadius = 2.0
        __sender.shadowOpacity = 0.15
    }
    
    open var elements = [NXToolView.Element]()
    public let centerView = NXToolView.Center { (_, __sender) in
        __sender.isHidden = true
    }

    override open func setupSubviews() {
        super.setupSubviews()
        
        self.contentView.addSubview(centerView.centerView)
    }
    
    override open func updateSubviews(_ action:String, _ value:Any?){
        if let dicValue = value as? [String:Any] {
            if let elements = dicValue["elements"] as? [NXToolView.Element], elements.count > 0 {
                self.elements.forEach { element in
                    element.elementView.removeFromSuperview()
                }
                self.elements = elements
            }
            
            if let index = dicValue["index"] as? Int {
                self.index = max(min(index, self.elements.count), 0)
            }
        }
        
        if self.centerView.isHidden == false {
            //如果想要显示中间的加大按钮，必须满足常规按钮的个数是偶数个
            self.centerView.isHidden = (self.elements.count % 2 != 0)
        }
        
        //设置阴影
        if self.shadow.isHidden == false {
            self.layer.shadowColor = self.shadow.shadowColor.cgColor;
            self.layer.shadowOffset = self.shadow.shadowOffset
            self.layer.shadowRadius = self.shadow.shadowRadius
            self.layer.shadowOpacity = Float(self.shadow.shadowOpacity)
            self.layer.cornerRadius = self.layer.shadowRadius
            self.layer.masksToBounds = false
        }
        else {
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.masksToBounds = true
        }
        
        //分隔线
        if self.separator.isHidden == false {
            self.contentView.setupSeparator(color: self.separator.backgroundColor, ats: .minY, insets: .zero)
            self.contentView.association?.separator?.isHidden = false
            self.contentView.association?.separator?.backgroundColor = self.separator.backgroundColor.cgColor
        }
        else {
            self.contentView.association?.separator?.isHidden = true
        }
        
        //中间按钮
        self.centerView.centerView.updateSubviews("", self.centerView)
        
        //tab
        let size = CGSize(width: self.centerView.isHidden ? self.width/max(CGFloat(self.elements.count), 1) : self.width/CGFloat(self.elements.count+1), height: NX.toolViewOffset)
        for (index, element) in self.elements.enumerated() {
            element.size = CGSize(width: size.width, height: size.height)
            element.elementView.isHidden = false
            element.elementView.frame = CGRect(x: size.width * CGFloat(index), y: 0, width: size.width, height: size.height)
            if index >= self.elements.count/2 && self.centerView.isHidden == false {
                element.elementView.frame = CGRect(x: size.width * CGFloat(index+1), y: 0, width: size.width, height: size.height)
            }
            element.elementView.tag = index
            element.elementView.setupEvent(UIControl.Event.tap) {[weak self] (e, v) in
                
                guard let __toolView = self,
                    let __elementView = v as? NXToolView.ElementView,
                    __elementView.tag >= 0 && __elementView.tag < __toolView.elements.count else {
                    return
                }
                
                let fromValue = __toolView.index
                let toValue = __elementView.tag
                if toValue != fromValue {
                    //切换选中
                    self?.didSelect(fromValue:fromValue, toValue: toValue)
                    self?.controller?.didSelectViewController(fromValue:fromValue, toValue: toValue, animated: false)
                }
                
                //选中的回调
                self?.didSelect?(fromValue, toValue)
            }
            self.contentView.addSubview(element.elementView)
        }
        
        for (index, element) in self.elements.enumerated() {
            element.elementView.isHidden = false
            element.isSelected = index == self.index
            element.elementView.updateSubviews("", element)
        }
    }
    
    public func didSelect(fromValue:Int, toValue: Int){
        let newValue = max(min(toValue, self.elements.count), 0)
        guard self.index != newValue else {return}
        
        let element = self.elements[newValue]
        if element.isSelectable {
            self.index = newValue
            
            if element.attachment.isResetable {
                element.attachment.value = 0
            }
            
            self.updateSubviews("", nil)
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //设置阴影
        if self.shadow.isHidden == false {
            self.layer.shadowColor = self.shadow.shadowColor.cgColor;
            self.layer.shadowOffset = self.shadow.shadowOffset
            self.layer.shadowRadius = self.shadow.shadowRadius
            self.layer.shadowOpacity = Float(self.shadow.shadowOpacity)
            self.layer.cornerRadius = self.layer.shadowRadius
            self.layer.masksToBounds = false
        }
        else {
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.masksToBounds = true
        }
    }
}

extension NXToolView {
    open class Center : NX.Attribute {
        fileprivate let centerView = NXToolView.CenterView(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
    }
    
    open class CenterView : NXControl {
        open var centerView = UIImageView(frame: CGRect.zero)
        override open func setupSubviews() {
            self.backgroundColor = UIColor.clear
            
            centerView.frame = self.bounds
            centerView.contentMode = .scaleAspectFit
            centerView.layer.cornerRadius = 0
            centerView.layer.masksToBounds = true
            self.addSubview(centerView)
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            centerView.frame = self.bounds
        }
        
        open override func updateSubviews(_ action: String, _ value: Any?) {
            guard let element = value as? NXToolView.Center else {
                return
            }
            
            self.isHidden = element.isHidden
            self.frame = element.frame
            self.backgroundColor  = element.backgroundColor
            self.layer.cornerRadius = element.cornerRadius
            self.centerView.image = element.image
        }
    }
}

extension NXToolView {
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
            isNumeric:Bool,
            isResetable:Bool) = (0, UIColor.red, UIColor.white, UIColor.red, 0, 11, UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5), true, false)
        
        fileprivate let elementView = NXToolView.ElementView(frame: CGRect(x: 0, y: 0, width: NX.width/4.0, height: NX.toolViewOffset))
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
            titleView.frame = CGRect(x: 0, y: assetView.frame.maxY + element.space, width: self.width, height: __raw.height)
            
            
            if element.isSelected {
                assetView.image = element.image.selected.withRenderingMode(.alwaysTemplate)
                assetView.tintColor = element.color.selected

                titleView.text = element.title.selected
                titleView.textColor = element.color.selected
            }
            else {
                assetView.image = element.image.unselected.withRenderingMode(.alwaysTemplate)
                assetView.tintColor = element.color.unselected

                titleView.text = element.title.unselected
                titleView.textColor = element.color.unselected
            }
            
            if element.attachment.value > 0 {
                markupView.isHidden = false
                if element.attachment.isNumeric {
                    
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
