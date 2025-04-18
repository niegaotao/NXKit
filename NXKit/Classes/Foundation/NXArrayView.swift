//
//  NXArrayView.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/29.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit

open class NXArrayView<S: UIView>: NXView {
    public enum Axis {
        case row
        case column
    }

    open var componentViews = [S]()
    open var insets = UIEdgeInsets.zero
    open var radius = CGFloat(36.0)
    open var axis = Axis.row

    open func componentView(at index: Int) -> S {
        if index >= 0 && index < componentViews.count {
            return componentViews[index]
        }
        let componentView = S(frame: CGRect.zero)
        componentViews.append(componentView)
        addSubview(componentView)
        return componentView
    }

    // 子类手动调用
    open func prepareSubviews(_ capacity: Int) {
        var __numberOfSubviews = capacity - componentViews.count
        while __numberOfSubviews >= 1 {
            let contentView = S(frame: CGRect.zero)
            componentViews.append(contentView)
            addSubview(contentView)
            __numberOfSubviews = __numberOfSubviews - 1
        }
    }
}
