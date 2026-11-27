//
//  NXKeyboardAccessoryView.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/19.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit

open class NXKeyboardAccessoryView: NXView {
    public let bytesView = UILabel(frame: CGRect.zero)
    public let actionView = NXButton(frame: CGRect.zero)
    public var isEnabled: Bool = true
    override open func setupSubviews() {
        backgroundColor = NXKit.viewBackgroundColor
        setupSeparator(color: NXKit.separatorColor, ats: .minY, insets: UIEdgeInsets.zero)

        actionView.frame = CGRect(x: width - 55, y: 0, width: 50, height: height)
        actionView.setTitle("确定", for: .normal)
        actionView.setTitleColor(NXKit.primaryColor, for: .normal)
        actionView.titleLabel?.font = NXKit.font(16, .bold)
        addSubview(actionView)

        bytesView.frame = CGRect(x: width - 140, y: 0, width: 80, height: height)
        bytesView.textColor = NXKit.lightGrayColor
        bytesView.font = NXKit.font(12)
        bytesView.textAlignment = .right
        addSubview(bytesView)
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        association?.separator?.backgroundColor = NXKit.separatorColor.cgColor
    }
}
