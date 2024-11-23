//
//  NXBackgroundView.swift
//  NXKit
//
//  Created by niegaotao on 2021/3/8.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXBackgroundView<B: UIView, C: UIView>: NXView {
    open var backgroundView = B(frame: CGRect.zero)
    open var contentView = C(frame: CGRect.zero)

    override open func setupSubviews() {
        super.setupSubviews()

        backgroundView.frame = bounds
        addSubview(backgroundView)

        contentView.frame = bounds
        addSubview(contentView)
    }
}
