//
//  NXCollectionReusableView.swift
//  NXKit
//
//  Created by niegaotao on 2021/3/9.
//  Copyright © 2021 niegaotao. All rights reserved.
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
    
    @objc open func setup(){
        arrowView.frame = CGRect(x: self.w-NX.insets.right-6, y: (self.h-12)/2, width: 6, height: 12)
        arrowView.image = NX.image(named:"icon-arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        self.addSubview(arrowView)
        
        separator.backgroundColor = NX.separatorColor.cgColor
        separator.isHidden = true
        self.layer.addSublayer(separator)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setupSubviews()
    }
    
    //MARK: 子类重写该方法初始化视图
    @objc open func setupSubviews(){
        
    }
    
    @objc open func updateSubviews(_ action:String, _ value: Any?){
        
    }
}
