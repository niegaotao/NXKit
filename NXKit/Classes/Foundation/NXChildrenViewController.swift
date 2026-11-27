//
//  NXChildrenViewController.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/8.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXChildrenViewController: NXViewController {
    // 子控制器数组
    open var viewControllers = [UIViewController]()
    // 当前选中(展示)的视图控制器
    open var currentViewController: UIViewController? = nil

    override open var childForStatusBarStyle: UIViewController? {
        return currentViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        return currentViewController
    }
}
