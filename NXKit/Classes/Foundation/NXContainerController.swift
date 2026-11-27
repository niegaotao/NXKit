//
//  NXContainerController.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/8.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXContainerController: NXViewController {
    //子控制器数组
    open var subviewControllers = [NXViewController]()
    //当前选中(展示)的视图控制器
    open var selectedViewController : NXViewController? = nil
}
