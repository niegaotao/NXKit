//
//  LEYDrawableView.swift
//  NXFoundation
//
//  Created by firelonely on 2020/3/11.
//

import UIKit

open class LEYDrawableView: LEYXView {
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.completion?("draw", rect)
    }
}
