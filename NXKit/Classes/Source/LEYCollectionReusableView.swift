//
//  LEYCollectionReusableView.swift
//  NXFoundation
//
//  Created by firelonely on 2019/3/9.
//  Copyright © 2019 firelonely. All rights reserved.
//

import UIKit

open class LEYCollectionReusableView: UICollectionReusableView {
    open var arrowView : UIImageView = UIImageView(frame: CGRect.zero)
    open var separator : CALayer = CALayer()
    open var value : Any? = nil
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupSubviews()
    }
    
    @objc open func setup(){
        arrowView.frame = CGRect(x: self.w-LEYApp.insets.right-6, y: (self.h-12)/2, width: 6, height: 12)
        arrowView.image = LEYApp.image(named:"uiapp_arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        self.addSubview(arrowView)
        
        separator.backgroundColor = LEYApp.separatorColor.cgColor
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
