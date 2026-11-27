//
//  NXPlaceholderView.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/7.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

//占位图
open class NXPlaceholderView : NXCView<NXLCRView<UIImageView, UILabel, UIButton>> {
    public let ctxs = NXPlaceholderViewDescriptor()
    
    open var assetView : UIImageView { return self.contentView.lhsView }
    open var descriptionView : UILabel { return self.contentView.centerView }
    open var footerView : UIButton { return self.contentView.rhsView }
    open var customizableView : UIView? = nil //自定义的默认图

    open override func setupSubviews() {
        super.setupSubviews()
        
        self.layer.masksToBounds = true
        self.contentView.setupEvent(UIControl.Event.tap) { [weak self](e, v) in
            self?.ctxs.event?("", nil)
        }
    }
    
    open override func updateSubviews(_ value: Any?) {
        if self.ctxs.isHidden == false {
            if let __customizableView = customizableView {
                __customizableView.isHidden = false
                __customizableView.frame = CGRect(x: (self.bounds.width-__customizableView.width)/2, y: (self.bounds.height - __customizableView.height)/2, width: __customizableView.width, height: __customizableView.height)
                self.addSubview(__customizableView)
                
                self.contentView.isHidden = true
            }
            else{
                self.contentView.isHidden = false
                self.contentView.frame = self.ctxs.frame
                self.contentView.frame = CGRect(x: (self.bounds.width-self.ctxs.frame.size.width)/2, y: (self.bounds.height - self.ctxs.frame.size.height)/2, width: self.ctxs.frame.size.width, height: self.ctxs.frame.size.height)
                self.addSubview(self.contentView)
                
                
                self.contentView.lhsView.frame = self.ctxs.m.frame
                if self.ctxs.m.image != nil {
                    self.contentView.lhsView.image = self.ctxs.m.image
                }
                else if self.ctxs.m.value.count > 0 {
                    if self.ctxs.t.value.hasPrefix("http") {
                        NXKit.image(self.contentView.lhsView, self.ctxs.m.value)
                    }
                    else {
                        self.contentView.lhsView.image = UIImage(named: self.ctxs.m.value)
                    }
                }
                else {
                    self.contentView.lhsView.image = nil
                }
                self.contentView.lhsView.contentMode = .scaleAspectFit
                    
                self.contentView.centerView.frame = self.ctxs.t.frame
                self.contentView.centerView.text = self.ctxs.t.value
                self.contentView.centerView.textAlignment = self.ctxs.t.textAlignment
                self.contentView.centerView.numberOfLines = self.ctxs.t.numberOfLines
                self.contentView.centerView.font = self.ctxs.t.font
                self.contentView.centerView.textColor = self.ctxs.t.color
                
                self.contentView.rhsView.isHidden = true
                
                
                self.customizableView?.isHidden = true
            }
        }
        else {
            self.customizableView?.isHidden = true
            self.contentView.isHidden = true
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.center = self.center
    }
}

open class NXPlaceholderViewDescriptor {
    open var isHidden = true
    
    open var event : NXKit.Event<String, Any?>? = nil
    
    open var frame = CGRect(x: 0, y: 0, width: 320, height: 256)
    
    public let m = NXKit.Attribute { (__sender) in
        __sender.frame = CGRect(x: 0, y: 0, width: 320, height: 170)
    }
    
    public let t = NXKit.Attribute { (__sender) in
        __sender.frame = CGRect(x: 0, y: 175, width: 320, height: 55)
        __sender.value = "暂无数据～"
        __sender.textAlignment = .center
        __sender.numberOfLines = 0
        __sender.font = NXKit.font(16)
        __sender.color = NXKit.lightGrayColor
    }
}

open class NXPlaceholderDescriptor : NXItem, NXCollectionViewAttributesProtocol {
    open var placeholderView: NXPlaceholderView?
    open var attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))
}


open class NXTablePlaceholderViewCell : NXTableViewCell {
    override open func setupSubviews() {
        super.setupSubviews()
        selectionStyle = .none
        accessoryType = .none
        self.arrowView.isHidden = true
    }
    
    override open func updateSubviews(_ value: Any?) {
        guard let item = value as? NXPlaceholderDescriptor, let placeholderView = item.placeholderView else {
            return;
        }
        placeholderView.frame = CGRect(x: 0, y: 0, width: item.ctxs.width, height: item.ctxs.height)
        placeholderView.updateSubviews(value)
        self.backgroundView?.backgroundColor = placeholderView.backgroundColor
        self.contentView.addSubview(placeholderView)
    }
}

open class NXCollectionPlaceholderViewCell : NXCollectionViewCell {
    override open func setupSubviews() {
        super.setupSubviews()
    }
    
    override open func updateSubviews(_ value: Any?) {
        guard let item = value as? NXPlaceholderDescriptor, let placeholderView = item.placeholderView else {
            return;
        }
        
        placeholderView.frame = CGRect(x: 0, y: 0, width: item.ctxs.width, height: item.ctxs.height)
        placeholderView.updateSubviews(value)
        self.backgroundView?.backgroundColor = placeholderView.backgroundColor
        self.contentView.addSubview(placeholderView)
    }
}







