//
//  NXLCRView.swift
//  NXKit
//
//  Created by niegaotao on 2021/3/8.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXLCRView<L: UIView, C: UIView, R: UIView>: NXView {
    public var lhsView = L(frame: CGRect.zero) //左侧
    public var centerView = C(frame: CGRect.zero) //中间
    public var rhsView = R(frame: CGRect.zero) //右侧
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.addSubview(lhsView)
        
        self.addSubview(centerView)
        
        self.addSubview(rhsView)
    }
}

open class NXHeaderView: NXLCRView<NXButton, UILabel, NXButton> {
    open override func setupSubviews() {
        super.setupSubviews()
        
        lhsView.frame = CGRect(x: 16, y: (self.height-44)/2, width: 84, height: 44)
        lhsView.contentHorizontalAlignment = .left
        lhsView.titleLabel?.font = NXKit.font(16)
        self.addSubview(lhsView)
        
        centerView.frame = CGRect(x: 100, y: (self.height-44)/2, width:self.width - 100 * 2 , height: 44)
        centerView.textAlignment = .center
        centerView.font = NXKit.font(17, .bold)
        centerView.textColor = NXKit.blackColor
        self.addSubview(centerView)
        
        rhsView.frame = CGRect(x: self.width-16-84, y: (self.height-44)/2, width: 84, height: 44)
        rhsView.contentHorizontalAlignment = .right
        rhsView.titleLabel?.font = NXKit.font(16)
        self.addSubview(rhsView)
    }
}

open class NXFooterView: NXLCRView<NXButton, NXButton, NXButton> {
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.backgroundColor = NXKit.backgroundColor
        
        let itemWidth : CGFloat = (self.width - 16.0 * 3.0)/2.0
        
        lhsView.frame = CGRect(x: 16.0, y: 10, width: itemWidth, height: 40)
        lhsView.titleLabel?.font = NXKit.font(14)
        lhsView.layer.masksToBounds = true
        self.addSubview(lhsView)
        
        rhsView.frame = CGRect(x: 16.0 * 2.0 + itemWidth, y: 10, width: itemWidth, height: 40)
        rhsView.titleLabel?.font = NXKit.font(14)
        rhsView.layer.masksToBounds = true
        self.addSubview(rhsView)
        
        //初始化一个button
        centerView.frame = CGRect(x: 16.0, y: 10, width: self.width-16.0 - 16.0, height: 40)
        centerView.titleLabel?.font = NXKit.font(15)
        centerView.layer.masksToBounds = true
        self.addSubview(centerView)
        
        //设置顶部分割线
        self.setupSeparator(color: NXKit.separatorColor, ats: .minY)
    }
}

