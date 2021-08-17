//
//  NXLCRView.swift
//  NXKit
//
//  Created by niegaotao on 2020/3/8.
//

import UIKit

open class NXLCRView<L:UIView, C:UIView, R:UIView>: NXView {
    public var lhsView = L(frame: CGRect.zero) //左侧
    public var centerView = C(frame: CGRect.zero) //中间
    public var rhsView = R(frame: CGRect.zero) //右侧
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.addSubview(lhsView)
        
        self.addSubview(centerView)
        
        self.addSubview(rhsView)
    }
}
