//
//  NXCollectionViewCell.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/20.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionViewCell: UICollectionViewCell {
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()
    open var value : Any? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupSubviews()
    }
    
    open func setup(){
        arrowView.frame = CGRect(x: contentView.width-NX.insets.right-6, y: (contentView.height-12)/2, width: 6, height: 12)
        arrowView.image = NX.image(named:"icon-arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        self.contentView.addSubview(arrowView)
        
        if self.backgroundView == nil {
            self.backgroundView = UIView(frame: CGRect.zero)
            self.backgroundView?.backgroundColor = NX.cellBackgroundColor
            self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        separator.backgroundColor = NX.separatorColor.cgColor
        separator.isHidden = true
        self.contentView.layer.addSublayer(separator)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setupSubviews()
    }
    
    ///MARK: 子类重写该方法初始化视图
    open func setupSubviews(){
        
    }
    
    open func updateSubviews(_ action:String, _ value: Any?){
        
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.separator.backgroundColor = NX.separatorColor.cgColor
    }
}
