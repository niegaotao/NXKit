//
//  NXView.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public protocol NXViewProtocol: NSObject {
    func setupSubviews()
    func updateSubviews(_ value: Any?)
}

open class NXView: UIView, NXViewProtocol {
    
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
    
    open func updateSubviews(_ value: Any?){
    
    }
}
