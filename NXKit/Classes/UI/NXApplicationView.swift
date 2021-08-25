//
//  NXApplicationView.swift
//  NXKit
//
//  Created by niegaotao on 2020/4/7.
//

import UIKit

open class NXApplicationView: NXView {
    public let assetView = UIImageView(frame: CGRect.zero)
    public let titleView = UILabel(frame: CGRect.zero)
    public let subtitleView = UILabel(frame: CGRect.zero)
    public let accessView = UILabel(frame: CGRect.zero)
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
        
        accessView.font = NX.font(14)
        accessView.textAlignment = .right
        accessView.textColor = NX.darkGrayColor
        accessView.layer.masksToBounds = true
        self.addSubview(accessView)
        
        arrowView.contentMode = .scaleAspectFill
        arrowView.layer.masksToBounds = true
        self.addSubview(arrowView)
        
        separator.backgroundColor = NX.separatorColor.cgColor
        separator.isHidden = true
        self.layer.addSublayer(separator)
    }
    
    open override func updateSubviews(_ action:String, _ value:Any?){
        guard let __wrapped = value as? NXAction else {
            return
        }
        
        NX.View.update(__wrapped.asset, self.assetView)
        NX.View.update(__wrapped.title, self.titleView)
        NX.View.update(__wrapped.subtitle, self.subtitleView)
        NX.View.update(__wrapped.access, self.accessView)
        NX.View.update(__wrapped.arrow, self.arrowView)
        
        if __wrapped.separator.ats.isEmpty {
            self.separator.isHidden = true
        }
        else{
            self.separator.isHidden = false
            let __separator = __wrapped.separator
            
            var __frame = CGRect.zero
            if __separator.ats.contains(.minY) || __separator.ats.contains(.maxY) {
                __frame = CGRect(x: __separator.insets.left, y: 0, width: __wrapped.ctxs.width-__separator.insets.left-__separator.insets.right, height: NXDevice.pixel)
                if __wrapped.separator.ats.contains(.maxY) {
                    __frame.origin.y = __wrapped.ctxs.height-NXDevice.pixel
                }
            }
            else {
                __frame = CGRect(x: 0, y: __separator.insets.top, width: NXDevice.pixel, height: __wrapped.ctxs.height-__separator.insets.top-__separator.insets.bottom)
                if __separator.ats.contains(.maxX) {
                    __frame.origin.x = __wrapped.ctxs.width-NXDevice.pixel
                }
            }
            self.separator.frame = __frame

            self.separator.backgroundColor = __separator.backgroundColor.cgColor
        }
    }
}

