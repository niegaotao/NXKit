//
//  NXAutoresizeView.swift
//  NXKit
//
//  Created by niegaotao on 2021/3/11.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXAutoresizeView<C: UIView>: NXView {
    open var contentView = C(frame: CGRect.zero)

    open var completion: NXKit.Event<String, Any?>? = nil
    open var insets = UIEdgeInsets.zero
    override open func setupSubviews() {
        super.setupSubviews()

        autoresizesSubviews = true

        contentView.frame = bounds
        addSubview(contentView)
    }

    override open func updateSubviews(_ value: Any?) {
        super.updateSubviews(value)

        completion?("updateSubviews", self)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if autoresizesSubviews {
            contentView.frame = CGRect(x: insets.left,
                                       y: insets.top,
                                       width: frame.size.width - insets.left - insets.right,
                                       height: frame.size.height - insets.top - insets.bottom)
        }

        completion?("layoutSubviews", self)
    }

    override open func draw(_: CGRect) {
        completion?("draw", self)
    }
}
