//
//  LEYBackgroundView.swift
//  NXFoundation
//
//  Created by firelonely on 2020/3/8.
//

import UIKit

open class LEYBackgroundView<B:UIView, C:UIView> : LEYView {
    open var backgroundView = B(frame: CGRect.zero)
    open var contentView = C(frame: CGRect.zero)
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView)
        
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
}
