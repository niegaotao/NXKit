//
//  LEYApplicationView.swift
//  NXFoundation
//
//  Created by firelonely on 2020/4/7.
//

import UIKit

open class LEYApplicationView: LEYView {
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
        
        titleView.font = LEYApp.font(16)
        titleView.textAlignment = .left
        titleView.textColor = LEYApp.darkBlackColor
        titleView.layer.masksToBounds = true
        self.addSubview(titleView)
        
        subtitleView.font = LEYApp.font(14)
        subtitleView.textAlignment = .left
        subtitleView.textColor = LEYApp.darkGrayColor
        subtitleView.layer.masksToBounds = true
        self.addSubview(subtitleView)
        
        accessView.font = LEYApp.font(14)
        accessView.textAlignment = .right
        accessView.textColor = LEYApp.darkGrayColor
        accessView.layer.masksToBounds = true
        self.addSubview(accessView)
        
        arrowView.contentMode = .scaleAspectFill
        arrowView.layer.masksToBounds = true
        self.addSubview(arrowView)
        
        separator.backgroundColor = LEYApp.separatorColor.cgColor
        separator.isHidden = true
        self.layer.addSublayer(separator)
    }
    
    open override func updateSubviews(_ action:String, _ value:Any?){
        guard let __wrapped = value as? LEYAction else {
            return
        }
        
        if __wrapped.asset.isHidden == false {
            self.assetView.isHidden = false
            self.assetView.frame = __wrapped.asset.frame
            if __wrapped.asset.image != nil {
                self.assetView.image = __wrapped.asset.image
            }
            else if __wrapped.asset.value.contains("http") {
                LEYApp.image(self.assetView, __wrapped.asset.value)
            }
            else if !__wrapped.asset.value.isEmpty {
                self.assetView.image = UIImage(named: __wrapped.asset.value)
            }
            else {
                self.assetView.image = nil
            }
            self.assetView.layer.cornerRadius = __wrapped.asset.radius
        }
        else {
            self.assetView.isHidden = true
        }
        
        if __wrapped.title.isHidden == false {
            self.titleView.isHidden = false
            self.titleView.frame = __wrapped.title.frame
            self.titleView.backgroundColor = __wrapped.title.backgroundColor
            self.titleView.layer.cornerRadius = __wrapped.title.radius
            self.titleView.text = __wrapped.title.value
            self.titleView.textColor = __wrapped.title.color
            self.titleView.textAlignment = __wrapped.title.textAlignment
            self.titleView.font = __wrapped.title.font
            self.titleView.numberOfLines = __wrapped.title.numberOfLines
        }
        else {
            self.titleView.isHidden = true
        }
        
        if __wrapped.subtitle.isHidden == false {
            self.subtitleView.isHidden = false
            self.subtitleView.frame = __wrapped.subtitle.frame
            self.subtitleView.backgroundColor = __wrapped.subtitle.backgroundColor
            self.subtitleView.layer.cornerRadius = __wrapped.subtitle.radius
            self.subtitleView.text = __wrapped.subtitle.value
            self.subtitleView.textColor = __wrapped.subtitle.color
            self.subtitleView.textAlignment = __wrapped.subtitle.textAlignment
            self.subtitleView.font = __wrapped.subtitle.font
            self.subtitleView.numberOfLines = __wrapped.subtitle.numberOfLines
        }
        else {
            self.subtitleView.isHidden = true
        }
        
        if __wrapped.access.isHidden == false {
            self.accessView.isHidden = false
            self.accessView.frame = __wrapped.access.frame
            self.accessView.backgroundColor = __wrapped.access.backgroundColor
            self.accessView.layer.cornerRadius = __wrapped.access.radius
            self.accessView.text = __wrapped.access.value
            self.accessView.textColor = __wrapped.access.color
            self.accessView.textAlignment = __wrapped.access.textAlignment
            self.accessView.font = __wrapped.access.font
            self.accessView.numberOfLines = __wrapped.access.numberOfLines
        }
        else {
            self.accessView.isHidden = true
        }
        
        if __wrapped.arrow.isHidden == false {
            self.arrowView.isHidden = false
            self.arrowView.frame = __wrapped.arrow.frame
            if __wrapped.arrow.image != nil {
                self.arrowView.image = __wrapped.arrow.image
            }
            else if __wrapped.arrow.value.contains("http") {
                LEYApp.image(self.arrowView, __wrapped.arrow.value)
            }
            else if !__wrapped.arrow.value.isEmpty {
                self.arrowView.image = UIImage(named: __wrapped.arrow.value)
            }
            else {
                self.arrowView.image = nil
            }
            self.arrowView.layer.cornerRadius = __wrapped.arrow.radius
        }
        else {
            self.arrowView.isHidden = true
        }
        
        if __wrapped.separator.side.isEmpty {
            self.separator.isHidden = true
        }
        else{
            self.separator.isHidden = false
            let __separator = __wrapped.separator
            
            var __frame = CGRect.zero
            if __separator.side.contains(.top) || __separator.side.contains(.bottom) {
                __frame = CGRect(x: __separator.insets.left, y: 0, width: __wrapped.ctxs.w-__separator.insets.left-__separator.insets.right, height: LEYDevice.pixel)
                if __wrapped.separator.side.contains(.bottom) {
                    __frame.origin.y = __wrapped.ctxs.h-LEYDevice.pixel
                }
            }
            else {
                __frame = CGRect(x: 0, y: __separator.insets.top, width: LEYDevice.pixel, height: __wrapped.ctxs.h-__separator.insets.top-__separator.insets.bottom)
                if __separator.side.contains(.right) {
                    __frame.origin.x = __wrapped.ctxs.w-LEYDevice.pixel
                }
            }
            self.separator.frame = __frame

            self.separator.backgroundColor = __separator.backgroundColor.cgColor
        }
    }
}

