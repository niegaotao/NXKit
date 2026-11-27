//
//  NXCollectionReusableView.swift
//  NXKit
//
//  Created by niegaotao on 2020/3/9.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionReusableView: UICollectionReusableView {
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()
    open var value : Any? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setupSubviews()
    }
    
    open func setup(){
        arrowView.frame = CGRect(x: self.width-16.0-6, y: (self.height-12)/2, width: 6, height: 12)
        arrowView.image = NX.image(named:"icon-arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        self.addSubview(arrowView)
        
        separator.backgroundColor = NX.separatorColor.cgColor
        separator.isHidden = true
        self.layer.addSublayer(separator)
    }
    
    open func setupSubviews(){
        
    }
    
    open func updateSubviews(_ value: Any?){
        
    }
}
