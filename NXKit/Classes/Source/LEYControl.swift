//
//  LEYControl.swift
//  NXFoundation
//
//  Created by firelonely on 2018/8/12.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


open class LEYControl: UIControl {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    open func setupSubviews(){
        
    }
    
    open func updateSubviews(_ action:String, _ value:Any?){
        
    }
}
