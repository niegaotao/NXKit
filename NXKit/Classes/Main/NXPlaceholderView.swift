//
//  NXPlaceholderView.swift
//  NXKit
//
//  Created by firelonely on 2018/10/7.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


open class NXPlaceholderView : NXCView<NXLCRView<UIImageView, UILabel, UIButton>> {
    public let wrapped = NXPlaceholderView.Wrapped()
    
    open var assetView : UIImageView { return self.contentView.lhsView }
    open var descriptionView : UILabel { return self.contentView.centerView }
    open var footerView : UIButton { return self.contentView.rhsView }

    
    open var customizableView : UIView? = nil //自定义的默认图

    open override func setupSubviews() {
        super.setupSubviews()
        
        self.layer.masksToBounds = true
        self.contentView.frame = self.wrapped.frame
        self.contentView.lhsView.frame = NXApp.Placeholder.m.frame
        if NXApp.Placeholder.m.image != nil {
            self.contentView.lhsView.image = NXApp.Placeholder.m.image
        }
        else if NXApp.Placeholder.m.value.count > 0 {
            if NXApp.Placeholder.t.value.hasPrefix("http") {
                NXApp.image(self.contentView.lhsView, NXApp.Placeholder.m.value)
            }
            else {
                self.contentView.lhsView.image = UIImage(named: NXApp.Placeholder.m.value)
            }
        }
        else {
            self.contentView.lhsView.image = nil
        }
        self.contentView.lhsView.contentMode = .scaleAspectFit
            
        self.contentView.centerView.frame = NXApp.Placeholder.t.frame
        self.contentView.centerView.text = NXApp.Placeholder.t.value
        self.contentView.centerView.textAlignment = NXApp.Placeholder.t.textAlignment
        self.contentView.centerView.numberOfLines = NXApp.Placeholder.t.numberOfLines
        self.contentView.centerView.font = NXApp.Placeholder.t.font
        self.contentView.centerView.textColor = NXApp.Placeholder.t.color
        
        self.contentView.rhsView.isHidden = true
        
        self.contentView.setupEvents([UIControl.Event.tap]) { [weak self](e, v) in
            self?.wrapped.completion?("", nil)
        }
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?) {
        if self.wrapped.isHidden == false {
            
            if let __customizableView = customizableView {
                __customizableView.isHidden = false
                __customizableView.frame = CGRect(x: (self.bounds.width-__customizableView.w)/2, y: (self.bounds.height - __customizableView.h)/2, width: __customizableView.w, height: __customizableView.h)
                self.addSubview(__customizableView)
                
                self.contentView.isHidden = true
            }
            else{
                self.contentView.isHidden = false
                self.contentView.frame = CGRect(x: (self.bounds.width-self.contentView.w)/2, y: (self.bounds.height - self.contentView.h)/2, width: self.contentView.w, height: self.contentView.h)
                self.addSubview(self.contentView)
                
                self.customizableView?.isHidden = true
            }
        }
        else {
            self.customizableView?.isHidden = true
            self.contentView.isHidden = true
        }
    }
}

extension NXPlaceholderView {
    open class Wrapped : NSObject {
        open var isHidden = true
        open var completion : NXApp.Completion<String, Any?>? = nil
        open var frame = NXApp.Placeholder.frame
    }
    
    open class Element : NXItem {
        open var placeholderView: NXPlaceholderView?
    }
    
    
    open class TableViewCell : NXTableViewCell {
        override open func setupSubviews() {
            super.setupSubviews()
            selectionStyle = .none
            accessoryType = .none
            self.arrowView.isHidden = true
        }
        
        override open func updateSubviews(_ action:String, _ value: Any?) {
            guard let item = value as? NXPlaceholderView.Element, let placeholderView = item.placeholderView  else {
                return;
            }
            placeholderView.frame = CGRect(x: 0, y: 0, width: item.ctxs.w, height: item.ctxs.h)
            placeholderView.updateSubviews(action, value)
            self.backgroundView?.backgroundColor = placeholderView.backgroundColor
            self.contentView.addSubview(placeholderView)
        }
    }
    
    open class CollectionViewCell : NXCollectionViewCell {
        override open func setupSubviews() {
            super.setupSubviews()
        }
        
        override open func updateSubviews(_ action:String, _ value: Any?) {
            guard let item = value as? NXPlaceholderView.Element, let placeholderView = item.placeholderView  else {
                return;
            }
            
            placeholderView.frame = CGRect(x: 0, y: 0, width: item.ctxs.w, height: item.ctxs.h)
            placeholderView.updateSubviews(action, value)
            self.backgroundView?.backgroundColor = placeholderView.backgroundColor
            self.contentView.addSubview(placeholderView)
        }
    }
}







