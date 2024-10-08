//
//  NXCView.swift
//  NXKit
//
//  Created by niegaotao on 2021/6/4.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXCView<C: UIView>: NXView {
    open var contentView = C(frame: CGRect.zero)
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
}
