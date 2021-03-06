//
//  NXApi.swift
//  NXKit
//
//  Created by firelonely on 2018/10/1.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXApi {
    public class func swizzle(_ cls: AnyClass?, _ originSelector: Selector, _ swizzleSelector: Selector)  {
        let originMethod = class_getInstanceMethod(cls, originSelector)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
        guard let swMethod = swizzleMethod, let oMethod = originMethod else { return }
        let didAddSuccess: Bool = class_addMethod(cls, originSelector, method_getImplementation(swMethod), method_getTypeEncoding(swMethod))
        if didAddSuccess {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(oMethod), method_getTypeEncoding(oMethod))
        }
        else {
            method_exchangeImplementations(oMethod, swMethod)
        }
    }
}
