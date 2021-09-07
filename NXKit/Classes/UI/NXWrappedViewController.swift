//
//  NXWrappedViewController.swift
//  NXKit
//
//  Created by niegaotao on 2021/7/13.
//

import UIKit

open class NXWrappedViewController<C:NXViewController>: NXViewController {
    public let viewController = C()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.isHidden = true
        self.contentView.isHidden = true
        
        self.viewController.ctxs.superviewController = self
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
    }
}
