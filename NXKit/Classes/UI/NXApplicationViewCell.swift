//
//  NXApplicationViewCell.swift
//  NXKit
//
//  Created by niegaotao on 2021/8/17.
//

import UIKit


open class NXTableSubviewCell<T:UIView>: NXTableViewCell {
    public let applicationView = T(frame: CGRect.zero)
    
    open override func setupSubviews(){
        
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.selectedBackgroundView?.backgroundColor = NX.selectedBackgroundColor
        
        if let __applicationView = self.applicationView as? NXApplicationView {
            __applicationView.assetView.backgroundColor = UIColor.white
            __applicationView.assetView.layer.cornerRadius = 12
            __applicationView.assetView.layer.masksToBounds = true
            __applicationView.assetView.contentMode = .scaleAspectFill
            __applicationView.titleView.textAlignment = .center
            __applicationView.titleView.textColor = NX.darkBlackColor
            __applicationView.titleView.font = NX.font(16)
            __applicationView.titleView.numberOfLines = 0
            __applicationView.subtitleView.textAlignment = .center
            __applicationView.subtitleView.textColor = NX.darkGrayColor
            __applicationView.subtitleView.font = NX.font(13)
            __applicationView.subtitleView.numberOfLines = 0
            __applicationView.subtitleView.isHidden = true
        }
        self.contentView.addSubview(self.applicationView)
        
        self.contentView.bringSubviewToFront(self.arrowView)
        
        separator.backgroundColor = NX.separatorColor.cgColor
        separator.isHidden = true
    }
    
    open override func updateSubviews(_ action:String, _ value: Any?){
        self.applicationView.frame = self.contentView.bounds.offsetBy(dx: 100, dy: 0)
        if let __applicationView = self.applicationView as? NXApplicationView {
            __applicationView.updateSubviews(action, value)
            
            if let __wrapped = value as? NXAction, __wrapped.appearance.isHighlighted {
                self.selectedBackgroundView?.backgroundColor = __wrapped.appearance.selectedBackgroundColor
            }
            else{
                self.selectedBackgroundView?.backgroundColor = UIColor.clear
            }
            self.arrowView.isHidden = true
            self.separator.isHidden = true
        }
        else if let __applicationView = self.applicationView as? NXView  {
            __applicationView.updateSubviews(action, value)
            self.selectedBackgroundView?.backgroundColor = UIColor.clear
        }
    }
}

open class NXCollectionSubviewCell<T:UIView>: NXCollectionViewCell {
    public let applicationView = T(frame: CGRect.zero)
    
    open override func setupSubviews(){
        
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.selectedBackgroundView?.backgroundColor = NX.selectedBackgroundColor
        
        if let __applicationView = self.applicationView as? NXApplicationView {
            __applicationView.assetView.backgroundColor = UIColor.white
            __applicationView.assetView.layer.cornerRadius = 12
            __applicationView.assetView.layer.masksToBounds = true
            __applicationView.assetView.contentMode = .scaleAspectFill
            __applicationView.titleView.textAlignment = .center
            __applicationView.titleView.textColor = NX.darkBlackColor
            __applicationView.titleView.font = NX.font(16)
            __applicationView.titleView.numberOfLines = 0
            __applicationView.subtitleView.textAlignment = .center
            __applicationView.subtitleView.textColor = NX.darkGrayColor
            __applicationView.subtitleView.font = NX.font(13)
            __applicationView.subtitleView.numberOfLines = 0
            __applicationView.subtitleView.isHidden = true
        }
        self.contentView.addSubview(self.applicationView)
        
        self.contentView.bringSubviewToFront(self.arrowView)
        
        self.separator.backgroundColor = NX.separatorColor.cgColor
        self.separator.isHidden = true
    }
    
    open override func updateSubviews(_ action:String, _ value: Any?){
        self.applicationView.frame = self.contentView.bounds
        if let __applicationView = self.applicationView as? NXApplicationView {
            __applicationView.updateSubviews(action, value)
            
            if let __wrapped = value as? NXAction, __wrapped.appearance.isHighlighted {
                self.selectedBackgroundView?.backgroundColor = __wrapped.appearance.selectedBackgroundColor
            }
            else{
                self.selectedBackgroundView?.backgroundColor = UIColor.clear
            }
            self.arrowView.isHidden = true
            self.separator.isHidden = true
        }
        else if let __applicationView = self.applicationView as? NXView  {
            __applicationView.updateSubviews(action, value)
            self.selectedBackgroundView?.backgroundColor = UIColor.clear
        }
    }
}

open class NXApplicationViewCell : NXTableSubviewCell<NXApplicationView> {}

open class NXActionViewCell : NXCollectionSubviewCell<NXApplicationView> {}


