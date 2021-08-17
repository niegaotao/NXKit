//
//  NXDrawableView.swift
//  NXKit
//
//  Created by niegaotao on 2020/3/11.
//

import UIKit

open class NXDrawableView: NXXView {
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.completion?("draw", rect)
    }
}
