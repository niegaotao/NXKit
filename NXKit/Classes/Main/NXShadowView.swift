//
//  NXShadowView.swift
//  NXKit
//
//  Created by firelonely on 2018/10/12.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXShadowView: NXCView<UIView> {
    
    public convenience init(frame: CGRect, radius: CGFloat = 6.0) {
        self.init(frame: frame)
        self.layer.cornerRadius = radius
        self.layer.shadowRadius = radius
        self.contentView.layer.cornerRadius = radius
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.autoinsetsSubviews = true
        self.backgroundColor = NXApp.backgroundColor
        self.layer.cornerRadius = 6.0
        self.layer.shadowRadius = 6.0
        self.layer.shadowColor = NXApp.shadowColor.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.backgroundColor = NXApp.backgroundColor
        self.contentView.layer.cornerRadius = 6.0
        self.contentView.layer.masksToBounds = true
        self.addSubview(contentView)
    }
    
    override open func addSubview(_ view: UIView) {
        if view == self.contentView {
            super.addSubview(view)
        }
        else{
            self.contentView.addSubview(view)
        }
    }
}
