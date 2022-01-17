//
//  NXViewControllerView.swift
//  NXKit
//
//  Created by niegaotao on 2021/9/1.
//  Copyright © 2021 无码科技. All rights reserved.
//

import UIKit

open class NXViewControllerView<N:UIView, C:UIView> : NXView {
    open var naviView = N(frame: CGRect(x: 0, y: 0, width: NXDevice.width, height: NXDevice.topOffset))
    open var contentView = C(frame: CGRect(x: 0, y: NXDevice.topOffset, width: NXDevice.width, height: NXDevice.height-NXDevice.topOffset))
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

