//
//  NXView.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    //只需要重载该方法做视图的初始化（以免使用继承的时候写构造方法的同时，还需要写 init?(coder:)）
    open func setupSubviews(){
        
    }
    
    //只需要重载该方法做视图的更新
    open func updateSubviews(_ value:Any?){
    
    }
}
