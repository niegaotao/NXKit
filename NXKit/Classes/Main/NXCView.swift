//
//  NXCView.swift
//  NXKit
//
//  Created by firelonely on 2020/6/4.
//

import UIKit

open class NXCView<C:UIView>: NXView {
    open var contentView = C(frame: CGRect.zero)
    open var insets = UIEdgeInsets.zero
    open var autoinsetsSubviews = false
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.autoinsetsSubviews == true {
            self.contentView.frame = CGRect(x: self.insets.left,
                                            y: self.insets.top,
                                            width: self.frame.width - self.insets.left - self.insets.right,
                                            height: self.frame.height - self.insets.top - self.insets.bottom)
        }
    }
}
