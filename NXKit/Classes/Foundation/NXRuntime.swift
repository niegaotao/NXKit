//
//  NXRuntime.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/1.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXRuntime {
    public class func swizzle(_ cls: AnyClass?, _ originSelector: Selector, _ swizzleSelector: Selector) {
        let originMethod = class_getInstanceMethod(cls, originSelector)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
        guard let swMethod = swizzleMethod, let oMethod = originMethod else { return }
        let didAddSuccess: Bool = class_addMethod(cls, originSelector, method_getImplementation(swMethod), method_getTypeEncoding(swMethod))
        if didAddSuccess {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(oMethod), method_getTypeEncoding(oMethod))
        } else {
            method_exchangeImplementations(oMethod, swMethod)
        }
    }
}
