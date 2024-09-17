//
//  NXAnylayerView.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/1.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
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
    
    open override func updateSubviews(_ value: Any?) {
        let dicValue = value as? [String: Any] ?? [:]
        let key = dicValue["key"] as? String ?? ""
        let value = dicValue["value"]
        if let __layer = self.layer as? CAGradientLayer {
            if key == "colors" {
                guard let __colors = value as? [CGColor] else {
                    return
                }
                __layer.colors = __colors
            }
            else if key == "locations" {
                guard let __locations = value as? [NSNumber] else {
                    return
                }
                __layer.locations = __locations
            }
            else if key == "startPoint" {
                guard let __startPoint = value as? CGPoint else {
                    return
                }
                __layer.startPoint = __startPoint
            }
            else if key == "endPoint" {
                guard let __endPoint = value as? CGPoint else {
                    return
                }
                __layer.endPoint = __endPoint
            }
        }
    }
}
