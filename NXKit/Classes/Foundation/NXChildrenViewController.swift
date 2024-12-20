//
//  NXChildrenViewController.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/8.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXChildrenViewController: NXViewController {
    //子控制器数组
    open var viewControllers = [UIViewController]()
    //当前选中(展示)的视图控制器
    open var currentViewController : UIViewController? = nil
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.currentViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.currentViewController
    }
}
