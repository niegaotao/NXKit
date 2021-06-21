//
//  LEYContainerController.swift
//  NXFoundation
//
//  Created by firelonely on 2018/5/8.
//

import UIKit

open class LEYContainerController: LEYViewController {
    //子控制器数组
    open var subviewControllers = [LEYViewController]()
    //当前选中(展示)的视图控制器
    open var selectedViewController : LEYViewController? = nil
}
