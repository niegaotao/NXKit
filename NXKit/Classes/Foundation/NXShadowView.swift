//
//  NXShadowView.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/12.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXShadowView: NXCView<UIView> {
    override open func setupSubviews() {
        super.setupSubviews()

        backgroundColor = NXKit.backgroundColor
        layer.cornerRadius = 6.0
        layer.shadowRadius = 6.0
        layer.shadowColor = NXKit.shadowColor.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = NXKit.backgroundColor
        contentView.layer.cornerRadius = 6.0
        contentView.layer.masksToBounds = true
        addSubview(contentView)
    }

    override open func addSubview(_ view: UIView) {
        if view == contentView {
            super.addSubview(view)
        } else {
            contentView.addSubview(view)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowRadius = layer.cornerRadius
        contentView.layer.cornerRadius = layer.cornerRadius
    }
}
