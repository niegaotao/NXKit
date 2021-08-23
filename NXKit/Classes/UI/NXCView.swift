//
//  NXCView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/4.
//

import UIKit

open class NXCView<C:UIView>: NXView {
    open var contentView = C(frame: CGRect.zero)
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
}
