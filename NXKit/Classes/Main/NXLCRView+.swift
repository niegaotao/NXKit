//
//  NXHeaderView.swift
//  NXKit
//
//  Created by firelonely on 2018/11/26.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXHeaderView: NXLCRView<NXButton, UILabel, NXButton> {
    open override func setupSubviews() {
        super.setupSubviews()
        
        lhsView.frame = CGRect(x: 16, y: (self.h-44)/2, width: 84, height: 44)
        lhsView.contentHorizontalAlignment = .left
        lhsView.titleLabel?.font = NX.font(16)
        self.addSubview(lhsView)
        
        centerView.frame = CGRect(x: 100, y: (self.h-44)/2, width:self.w - 100 * 2 , height: 44)
        centerView.textAlignment = .center
        centerView.font = NX.font(17,true)
        centerView.textColor = NX.darkBlackColor
        self.addSubview(centerView)
        
        rhsView.frame = CGRect(x: self.w-16-84, y: (self.h-44)/2, width: 84, height: 44)
        rhsView.contentHorizontalAlignment = .right
        rhsView.titleLabel?.font = NX.font(16)
        self.addSubview(rhsView)
    }
}

open class NXFooterView: NXLCRView<NXButton, NXButton, NXButton> {
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.backgroundColor = NX.backgroundColor
        
        let itemWidth : CGFloat = (self.w - NX.insets.right * 3.0)/2.0
        
        lhsView.frame = CGRect(x: NX.insets.left, y: 10, width: itemWidth, height: 40)
        lhsView.titleLabel?.font = NX.font(14)
        lhsView.layer.masksToBounds = true
        self.addSubview(lhsView)
        
        rhsView.frame = CGRect(x: NX.insets.left * 2.0 + itemWidth, y: 10, width: itemWidth, height: 40)
        rhsView.titleLabel?.font = NX.font(14)
        rhsView.layer.masksToBounds = true
        self.addSubview(rhsView)
        
        //初始化一个button
        centerView.frame = CGRect(x: NX.insets.left, y: 10, width: self.w-NX.insets.left - NX.insets.right, height: 40)
        centerView.titleLabel?.font = NX.font(15)
        centerView.layer.masksToBounds = true
        self.addSubview(centerView)
        
        //设置顶部分割线
        self.setupSeparator(color: NX.separatorColor, ats: .minY)
    }
}
