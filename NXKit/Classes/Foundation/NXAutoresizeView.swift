//
//  NXAutoresizeView.swift
//  NXKit
//
//  Created by niegaotao on 2021/3/11.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXAutoresizeView<C: UIView>: NXView {
    open var contentView = C(frame: CGRect.zero)
    
    open var completion : NXKit.Event<String, Any?>? = nil
    open var insets = UIEdgeInsets.zero
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.autoresizesSubviews = true
        
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    open override func updateSubviews(_ value: Any?) {
        super.updateSubviews(value)
        
        self.completion?("updateSubviews", self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.autoresizesSubviews {
            self.contentView.frame = CGRect(x: self.insets.left,
                                            y: self.insets.top,
                                            width: self.frame.size.width-self.insets.left-self.insets.right,
                                            height: self.frame.size.height-self.insets.top-self.insets.bottom)
        }
        
        self.completion?("layoutSubviews", self)
    }
    
    open override func draw(_ rect: CGRect) {
        self.completion?("draw", self)
    }
}



