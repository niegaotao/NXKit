//
//  NXLRView.swift
//  NXKit
//
//  Created by firelonely on 2020/5/16.
//

import UIKit

open class NXLRView<L:UIView, R:UIView>: NXView {
    public var lhsView = L(frame: CGRect.zero) //左侧
    public var rhsView = R(frame: CGRect.zero) //右侧
    
    open override func setupSubviews() {
        super.setupSubviews()
        self.addSubview(lhsView)
        self.addSubview(rhsView)
    }
}
