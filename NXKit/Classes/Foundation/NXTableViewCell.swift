//
//  NXTableViewCell.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/15.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXTableViewCell: UITableViewCell, NXViewProtocol {
    open var value : Any? = nil
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setupSubviews()
    }
    
    open func setup(){
        arrowView.frame = CGRect(x: contentView.width-16.0-6, y: (contentView.height-12)/2, width: 6, height: 12)
        arrowView.image = NXKit.image(named:"icon-arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        self.contentView.addSubview(arrowView)
        
        if self.backgroundView == nil {
            self.backgroundView = UIView(frame: CGRect.zero)
            self.backgroundView?.backgroundColor = NXKit.cellBackgroundColor
            self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        separator.backgroundColor = NXKit.separatorColor.cgColor
        separator.isHidden = true
        self.backgroundView?.layer.addSublayer(separator)
    }
    
    open func setupSubviews(){
        
    }
    
    open func updateSubviews(_ value: Any?){
        
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.separator.backgroundColor = NXKit.separatorColor.cgColor
    }
}
