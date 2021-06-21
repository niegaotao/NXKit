//
//  LEYCollectionViewCell.swift
//  NXFoundation
//
//  Created by firelonely on 2018/6/20.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class LEYCollectionViewCell: UICollectionViewCell {
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()
    open var value : Any? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupSubviews()
    }
    
    @objc open func setup(){
        arrowView.frame = CGRect(x: contentView.w-LEYApp.insets.right-6, y: (contentView.h-12)/2, width: 6, height: 12)
        arrowView.image = LEYApp.image(named:"uiapp_arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        self.contentView.addSubview(arrowView)
        
        if self.backgroundView == nil {
            self.backgroundView = UIView(frame: CGRect.zero)
            self.backgroundView?.backgroundColor = LEYApp.backgroundColor
            self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        separator.backgroundColor = LEYApp.separatorColor.cgColor
        separator.isHidden = true
        self.contentView.layer.addSublayer(separator)
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
    
    @objc open func willDisplay(_ item: Any?) {}
    @objc open func didEndDisplay(_ item: Any?) {}
}
