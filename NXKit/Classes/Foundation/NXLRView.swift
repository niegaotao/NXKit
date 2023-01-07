//
//  NXLRView.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/16.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXLRView<L:UIView, R:UIView>: NXView {
    public var lhsView = L(frame: CGRect.zero) //左侧
    public var rhsView = R(frame: CGRect.zero) //右侧
    
    open override func setupSubviews() {
        super.setupSubviews()
        self.addSubview(lhsView)
        self.addSubview(rhsView)
    }
}

open class NXMTView: NXLRView<UIImageView, UILabel> {
    open var mView : UIImageView  {
        return self.lhsView
    }
    
    open var tView : UILabel  {
        return self.rhsView
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        mView.frame = CGRect(x: 0, y: 0, width: self.height, height: self.height)
        mView.contentMode = .scaleAspectFill
        
        tView.frame = CGRect(x: self.height, y: 0, width: self.width-self.height, height: self.height)
        tView.textAlignment = .left
        tView.font = NX.font(13)
        tView.textColor = NX.lightGrayColor
    }
    
    open var index : Int = 0
    open var value : [String:Any]? = nil
}

//纵向的2个label
open class NXTTView: NXLRView<UILabel, UILabel> {
    open var topView: UILabel {
        return self.lhsView
    }
    
    open var bottomView: UILabel {
        return self.rhsView
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        topView.frame = CGRect(x: self.height, y: 0, width: self.width-self.height, height: self.height)
        topView.textAlignment = .center
        topView.font = NX.font(13)
        topView.textColor = NX.lightGrayColor
        
        bottomView.frame = CGRect(x: self.height, y: 0, width: self.width-self.height, height: self.height)
        bottomView.textAlignment = .center
        bottomView.font = NX.font(13)
        bottomView.textColor = NX.lightGrayColor
    }
}


