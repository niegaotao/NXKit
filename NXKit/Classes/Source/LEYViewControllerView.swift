//
//  LEYViewControllerView.swift
//  NXFoundation
//
//  Created by firelonely on 2020/9/1.
//  Copyright © 2020 无码科技. All rights reserved.
//

import UIKit

open class LEYViewControllerView<N:UIView, C:UIView> : LEYView {
    open var naviView = N(frame: CGRect(x: 0, y: 0, width: LEYDevice.width, height: LEYDevice.topOffset))
    open var contentView = C(frame: CGRect(x: 0, y: LEYDevice.topOffset, width: LEYDevice.width, height: LEYDevice.height-LEYDevice.topOffset))
    open weak var controller : LEYViewController? = nil

    open override func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.contentView)
        self.addSubview(self.naviView)
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?) {
        if let __naviView = self.naviView as? LEYView {
            __naviView.updateSubviews(action, value)
        }
        
        if let __contentView =  self.contentView as? LEYView {
            __contentView.updateSubviews(action, value)
        }
    }
}

open class LEYViewControllerWrappedView: LEYViewControllerView<LEYNaviView, UIView> {
    
}

