//
//  NXImageView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/17.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXImageView: UIImageView, NXViewProtocol {
    open var value: [String: Any]?  //给UIImageView赋值
    
    public init(){
        super.init(frame: CGRect.zero)
        self.setupSubviews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    open func setupSubviews(){
        
    }
    
    
    open func updateSubviews(_ value: Any?){
    
    }
}
