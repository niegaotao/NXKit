//
//  LEYObject.swift
//  NXFoundation
//
//  Created by firelonely on 2018/11/1.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class LEYObject : NSObject {
    open var value : [String: Any]?
    //+便利构造函数
    public convenience init(value: [String: Any]) {
        self.init()
        self.value = value
        self.setup()
    }
    
    //子类按需重在该方法
    open func setup(){
        
    }
}
