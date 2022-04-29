//
//  NXViewControllerView.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/1.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXViewControllerView<N:UIView, C:UIView> : NXView {
    open var naviView = N(frame: CGRect(x: 0, y: 0, width: NX.width, height: NX.topOffset))
    open var contentView = C(frame: CGRect(x: 0, y: NX.topOffset, width: NX.width, height: NX.height-NX.topOffset))
    open weak var controller : NXViewController? = nil

    open override func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.contentView)
        self.addSubview(self.naviView)
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?) {
        if let __naviView = self.naviView as? NXView {
            __naviView.updateSubviews(action, value)
        }
        
        if let __contentView =  self.contentView as? NXView {
            __contentView.updateSubviews(action, value)
        }
    }
}

open class NXViewControllerWrappedView: NXViewControllerView<NXNaviView, UIView> {
    
}

