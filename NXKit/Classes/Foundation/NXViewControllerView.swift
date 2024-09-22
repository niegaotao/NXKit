//
//  NXViewControllerView.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/1.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXViewControllerView<N: UIView, C: UIView> : NXView {
    open var navigationView = N(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: NXKit.safeAreaInsets.top + 44.0))
    open var contentView = C(frame: CGRect(x: 0, y: NXKit.safeAreaInsets.top + 44.0, width: NXKit.width, height: NXKit.height-NXKit.safeAreaInsets.top - 44.0))
    open weak var controller : NXViewController? = nil

    open override func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.contentView)
        self.addSubview(self.navigationView)
    }
    
    open override func updateSubviews(_ value: Any?) {
        if let __navigationView = self.navigationView as? NXView {
            __navigationView.updateSubviews(value)
        }
        
        if let __contentView =  self.contentView as? NXView {
            __contentView.updateSubviews(value)
        }
    }
}

open class NXViewControllerWrappedView: NXViewControllerView<NXNavigationView, UIView> {
    
}

