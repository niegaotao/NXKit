//
//  NXGradientView.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/1.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXShadow: NXView {
    
    override open class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override open func setupSubviews() {
        guard let __layer = self.layer as? CAGradientLayer else {
            return
        }
        __layer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        __layer.locations = [NSNumber(value: 0),NSNumber(value: 1)]
        __layer.startPoint = CGPoint(x: 0.5, y: 0)
        __layer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?) {
        guard let __layer = self.layer as? CAGradientLayer else {
            return
        }
        
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
