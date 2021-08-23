//
//  NXShadowView.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/12.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXShadowView: NXCView<UIView> {
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.backgroundColor = NX.backgroundColor
        self.layer.cornerRadius = 6.0
        self.layer.shadowRadius = 6.0
        self.layer.shadowColor = NX.shadowColor.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.backgroundColor = NX.backgroundColor
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.shadowRadius = self.layer.cornerRadius
        self.contentView.layer.cornerRadius = self.layer.cornerRadius
    }
}
