//
//  NXCView.swift
//  NXKit
//
//  Created by niegaotao on 2021/6/4.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXCView<C: UIView>: NXView {
    open var contentView = C(frame: CGRect.zero)

    override open func setupSubviews() {
        super.setupSubviews()

        contentView.frame = bounds
        addSubview(contentView)
    }
}
