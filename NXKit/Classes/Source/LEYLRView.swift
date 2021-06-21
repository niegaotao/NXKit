//
//  LEYLRView.swift
//  NXFoundation
//
//  Created by firelonely on 2020/5/16.
//

import UIKit

open class LEYLRView<L:UIView, R:UIView>: LEYView {
    public var lhsView = L(frame: CGRect.zero) //左侧
    public var rhsView = R(frame: CGRect.zero) //右侧
    
    open override func setupSubviews() {
        super.setupSubviews()
        self.addSubview(lhsView)
        self.addSubview(rhsView)
    }
}
