//
//  NXAbstractViewCell.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/17.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit


open class NXAbstractTableViewCell<T:UIView>: NXTableViewCell {
    public let abstractView = T(frame: CGRect.zero)
    
    open override func setupSubviews(){
        
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.selectedBackgroundView?.backgroundColor = NXUI.selectedBackgroundColor
        
        if let __abstractView = self.abstractView as? NXAbstractView {
            __abstractView.assetView.backgroundColor = UIColor.white
            __abstractView.assetView.layer.cornerRadius = 12
            __abstractView.assetView.layer.masksToBounds = true
            __abstractView.assetView.contentMode = .scaleAspectFill
            __abstractView.titleView.textAlignment = .center
            __abstractView.titleView.textColor = NXUI.darkBlackColor
            __abstractView.titleView.font = NXUI.font(16)
            __abstractView.titleView.numberOfLines = 0
            __abstractView.subtitleView.textAlignment = .center
            __abstractView.subtitleView.textColor = NXUI.darkGrayColor
            __abstractView.subtitleView.font = NXUI.font(13)
            __abstractView.subtitleView.numberOfLines = 0
            __abstractView.subtitleView.isHidden = true
        }
        self.contentView.addSubview(self.abstractView)
        
        self.contentView.bringSubviewToFront(self.arrowView)
        
        separator.backgroundColor = NXUI.separatorColor.cgColor
        separator.isHidden = true
    }
    
    open override func updateSubviews(_ action:String, _ value: Any?){
        self.abstractView.frame = self.contentView.bounds
        if let __abstractView = self.abstractView as? NXAbstractView {
            __abstractView.updateSubviews(action, value)
            
            if let __wrapped = value as? NXAction, __wrapped.raw.isHighlighted {
                self.selectedBackgroundView?.backgroundColor = __wrapped.raw.selectedBackgroundColor
            }
            else{
                self.selectedBackgroundView?.backgroundColor = UIColor.clear
            }
            self.arrowView.isHidden = true
            self.separator.isHidden = true
        }
        else if let __abstractView = self.abstractView as? NXView  {
            __abstractView.updateSubviews(action, value)
            self.selectedBackgroundView?.backgroundColor = UIColor.clear
        }
    }
}

open class NXAbstractCollectionViewCell<T:UIView>: NXCollectionViewCell {
    public let abstractView = T(frame: CGRect.zero)
    
    open override func setupSubviews(){
        
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.selectedBackgroundView?.backgroundColor = NXUI.selectedBackgroundColor
        
        if let __abstractView = self.abstractView as? NXAbstractView {
            __abstractView.assetView.backgroundColor = UIColor.white
            __abstractView.assetView.layer.cornerRadius = 12
            __abstractView.assetView.layer.masksToBounds = true
            __abstractView.assetView.contentMode = .scaleAspectFill
            __abstractView.titleView.textAlignment = .center
            __abstractView.titleView.textColor = NXUI.darkBlackColor
            __abstractView.titleView.font = NXUI.font(16)
            __abstractView.titleView.numberOfLines = 0
            __abstractView.subtitleView.textAlignment = .center
            __abstractView.subtitleView.textColor = NXUI.darkGrayColor
            __abstractView.subtitleView.font = NXUI.font(13)
            __abstractView.subtitleView.numberOfLines = 0
            __abstractView.subtitleView.isHidden = true
        }
        self.contentView.addSubview(self.abstractView)
        
        self.contentView.bringSubviewToFront(self.arrowView)
        
        self.separator.backgroundColor = NXUI.separatorColor.cgColor
        self.separator.isHidden = true
    }
    
    open override func updateSubviews(_ action:String, _ value: Any?){
        self.abstractView.frame = self.contentView.bounds
        if let __abstractView = self.abstractView as? NXAbstractView {
            __abstractView.updateSubviews(action, value)
            
            if let __wrapped = value as? NXAction, __wrapped.raw.isHighlighted {
                self.selectedBackgroundView?.backgroundColor = __wrapped.raw.selectedBackgroundColor
            }
            else{
                self.selectedBackgroundView?.backgroundColor = UIColor.clear
            }
            self.arrowView.isHidden = true
            self.separator.isHidden = true
        }
        else if let __abstractView = self.abstractView as? NXView  {
            __abstractView.updateSubviews(action, value)
            self.selectedBackgroundView?.backgroundColor = UIColor.clear
        }
    }
}

open class NXAbstractViewCell : NXAbstractTableViewCell<NXAbstractView> {}

open class NXActionViewCell : NXAbstractCollectionViewCell<NXAbstractView> {}


