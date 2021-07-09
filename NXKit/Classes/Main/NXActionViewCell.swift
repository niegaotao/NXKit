//
//  NXActionViewCell.swift
//  NXKit
//
//  Created by firelonely on 2020/4/7.
//

import UIKit

open class NXActionViewCell : NXCollectionViewCell {
    public let applicationView = NXApplicationView(frame: CGRect.zero)
    
    open override func setupSubviews(){
        
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.selectedBackgroundView?.backgroundColor = NXApp.selectedBackgroundColor
        
        applicationView.assetView.backgroundColor = UIColor.white
        applicationView.assetView.layer.cornerRadius = 12
        applicationView.assetView.layer.masksToBounds = true
        applicationView.assetView.contentMode = .scaleAspectFill
        applicationView.titleView.textAlignment = .center
        applicationView.titleView.textColor = NXApp.darkBlackColor
        applicationView.titleView.font = NXApp.font(16)
        applicationView.titleView.numberOfLines = 0
        applicationView.subtitleView.textAlignment = .center
        applicationView.subtitleView.textColor = NXApp.darkGrayColor
        applicationView.subtitleView.font = NXApp.font(13)
        applicationView.subtitleView.numberOfLines = 0
        applicationView.subtitleView.isHidden = true
        self.contentView.addSubview(self.applicationView)
        
        self.contentView.bringSubviewToFront(self.arrowView)
        
        separator.backgroundColor = NXApp.separatorColor.cgColor
        separator.isHidden = true
    }
    
    open override func updateSubviews(_ action:String, _ value: Any?){
        self.applicationView.frame = self.contentView.bounds
        self.applicationView.updateSubviews(action, value)

        guard let __wrapped = value as? NXAction else {
            return
        }
        
        self.backgroundView?.backgroundColor = __wrapped.appearance.backgroundColor
        
        if __wrapped.appearance.isHighlighted {
            self.selectedBackgroundView?.backgroundColor = __wrapped.appearance.selectedBackgroundColor
        }
        else{
            self.selectedBackgroundView?.backgroundColor = UIColor.clear
        }
        
        self.arrowView.isHidden = true
        self.separator.isHidden = true
    }
}
