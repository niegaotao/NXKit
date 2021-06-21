//
//  LEYMTView.swift
//  NXFoundation
//
//  Created by firelonely on 2018/8/1.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


open class LEYMTView: LEYLRView<UIImageView, UILabel> {
    open var mView : UIImageView  {
        return self.lhsView
    }
    
    open var tView : UILabel  {
        return self.rhsView
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        mView.frame = CGRect(x: 0, y: 0, width: self.h, height: self.h)
        mView.contentMode = .scaleAspectFill
        
        tView.frame = CGRect(x: self.h, y: 0, width: self.w-self.h, height: self.h)
        tView.textAlignment = .left
        tView.font = LEYApp.font(13)
        tView.textColor = LEYApp.darkGrayColor
    }
    
    open var index : Int = 0
    open var value : [String:Any]? = nil
}

//纵向的2个label
open class LEYTTView: LEYLRView<UILabel, UILabel> {
    open var topView: UILabel {
        return self.lhsView
    }
    
    open var bottomView: UILabel {
        return self.rhsView
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        topView.frame = CGRect(x: self.h, y: 0, width: self.w-self.h, height: self.h)
        topView.textAlignment = .center
        topView.font = LEYApp.font(13)
        topView.textColor = LEYApp.darkGrayColor
        
        bottomView.frame = CGRect(x: self.h, y: 0, width: self.w-self.h, height: self.h)
        bottomView.textAlignment = .center
        bottomView.font = LEYApp.font(13)
        bottomView.textColor = LEYApp.darkGrayColor
    }
}


