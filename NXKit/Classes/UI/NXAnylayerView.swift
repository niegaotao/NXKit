//
//  NXAnylayerView.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/10/1.
//  Copyright © 2018年 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/10/1.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
//

import UIKit

open class NXAnylayerView<T:CALayer>: NXView {
    
    override open class var layerClass: Swift.AnyClass {
        return T.self
    }
    
    override open func setupSubviews() {
        if let __layer = self.layer as? CAGradientLayer {
            __layer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
            __layer.locations = [NSNumber(value: 0),NSNumber(value: 1)]
            __layer.startPoint = CGPoint(x: 0.5, y: 0)
            __layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?) {
        if let __layer = self.layer as? CAGradientLayer {
            if action == "colors" {
                guard let __colors = value as? [CGColor] else {
                    return
                }
                __layer.colors = __colors
            }
            else if action == "locations" {
                guard let __locations = value as? [NSNumber] else {
                    return
                }
                __layer.locations = __locations
            }
            else if action == "startPoint" {
                guard let __startPoint = value as? CGPoint else {
                    return
                }
                __layer.startPoint = __startPoint
            }
            else if action == "endPoint" {
                guard let __endPoint = value as? CGPoint else {
                    return
                }
                __layer.endPoint = __endPoint
            }
        }
    }
}
