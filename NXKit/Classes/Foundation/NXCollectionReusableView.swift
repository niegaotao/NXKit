//
//  NXCollectionReusableView.swift
//  NXKit
//
//  Created by niegaotao on 2020/3/9.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionReusableView: UICollectionReusableView {
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()
    open var value: Any? = nil

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupSubviews()
    }

    open func setup() {
        arrowView.frame = CGRect(x: width - 16.0 - 6, y: (height - 12) / 2, width: 6, height: 12)
        arrowView.image = NXKit.image(named: "icon-arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        addSubview(arrowView)

        separator.backgroundColor = NXKit.separatorColor.cgColor
        separator.isHidden = true
        layer.addSublayer(separator)
    }

    open func setupSubviews() {}

    open func updateSubviews(_: Any?) {}
}
