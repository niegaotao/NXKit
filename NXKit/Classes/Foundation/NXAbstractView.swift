//
//  NXAbstractView.swift
//  NXKit
//
//  Created by niegaotao on 2021/4/7.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXAbstractView: NXView {
    public let assetView = UIImageView(frame: CGRect.zero)
    public let titleView = UILabel(frame: CGRect.zero)
    public let subtitleView = UILabel(frame: CGRect.zero)
    public let valueView = UILabel(frame: CGRect.zero)
    public let arrowView = UIImageView(frame:CGRect.zero)
    public let separator = CALayer()

    open override func setupSubviews() {
        
        assetView.contentMode = .scaleAspectFill
        assetView.layer.masksToBounds = true
        self.addSubview(assetView)
        
        titleView.font = NX.font(16)
        titleView.textAlignment = .left
        titleView.textColor = NX.darkBlackColor
        titleView.layer.masksToBounds = true
        self.addSubview(titleView)
        
        subtitleView.font = NX.font(14)
        subtitleView.textAlignment = .left
        subtitleView.textColor = NX.darkGrayColor
        subtitleView.layer.masksToBounds = true
        self.addSubview(subtitleView)
        
        valueView.font = NX.font(14)
        valueView.textAlignment = .right
        valueView.textColor = NX.darkGrayColor
        valueView.layer.masksToBounds = true
        self.addSubview(valueView)
        
        arrowView.contentMode = .scaleAspectFill
        arrowView.layer.masksToBounds = true
        self.addSubview(arrowView)
        
        separator.backgroundColor = NX.separatorColor.cgColor
        separator.isHidden = true
        self.layer.addSublayer(separator)
    }
    
    open override func updateSubviews(_ action:String, _ value:Any?){
        guard let __abstract = value as? NXAbstract else {
            return
        }
        
        NX.View.update(__abstract.raw, self)
        NX.View.update(__abstract.asset, self.assetView)
        NX.View.update(__abstract.title, self.titleView)
        NX.View.update(__abstract.subtitle, self.subtitleView)
        NX.View.update(__abstract.value, self.valueView)
        NX.View.update(__abstract.arrow, self.arrowView)
        
        
        let __separator = __abstract.raw.separator
        var __isHidden = false
        if __separator.ats.contains(.maxY) || __separator.ats.contains(.maxX) {
            __isHidden = __abstract.ctxs.at.last
        }
        else if __separator.ats.contains(.minY) || __separator.ats.contains(.minX) {
            __isHidden = __abstract.ctxs.at.first
        }
        else {
            __isHidden = true
        }
        
        if __isHidden {
            self.separator.isHidden = true
        }
        else {
            self.separator.isHidden = false
            var __frame = CGRect.zero
            if __separator.ats.contains(.minY) || __separator.ats.contains(.maxY) {
                __frame = CGRect(x: __separator.insets.left, y: 0, width: __abstract.ctxs.width-__separator.insets.left-__separator.insets.right, height: NX.pixel)
                if __abstract.raw.separator.ats.contains(.maxY) {
                    __frame.origin.y = __abstract.ctxs.height-NX.pixel
                }
            }
            else if __separator.ats.contains(.minX) || __separator.ats.contains(.maxX){
                __frame = CGRect(x: 0, y: __separator.insets.top, width: NX.pixel, height: __abstract.ctxs.height-__separator.insets.top-__separator.insets.bottom)
                if __separator.ats.contains(.maxX) {
                    __frame.origin.x = __abstract.ctxs.width-NX.pixel
                }
            }
            
            self.separator.frame = __frame
            self.separator.backgroundColor = __separator.backgroundColor.cgColor
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.separator.backgroundColor = NX.separatorColor.cgColor
    }
}

