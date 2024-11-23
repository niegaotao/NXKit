//
//  NXLCRView.swift
//  NXKit
//
//  Created by niegaotao on 2021/3/8.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXLCRView<L: UIView, C: UIView, R: UIView>: NXView {
    public var lhsView = L(frame: CGRect.zero) // 左侧
    public var centerView = C(frame: CGRect.zero) // 中间
    public var rhsView = R(frame: CGRect.zero) // 右侧

    override open func setupSubviews() {
        super.setupSubviews()

        addSubview(lhsView)

        addSubview(centerView)

        addSubview(rhsView)
    }
}

open class NXHeaderView: NXLCRView<NXButton, UILabel, NXButton> {
    override open func setupSubviews() {
        super.setupSubviews()

        lhsView.frame = CGRect(x: 16, y: (height - 44) / 2, width: 84, height: 44)
        lhsView.contentHorizontalAlignment = .left
        lhsView.titleLabel?.font = NXKit.font(16)
        addSubview(lhsView)

        centerView.frame = CGRect(x: 100, y: (height - 44) / 2, width: width - 100 * 2, height: 44)
        centerView.textAlignment = .center
        centerView.font = NXKit.font(17, .bold)
        centerView.textColor = NXKit.blackColor
        addSubview(centerView)

        rhsView.frame = CGRect(x: width - 16 - 84, y: (height - 44) / 2, width: 84, height: 44)
        rhsView.contentHorizontalAlignment = .right
        rhsView.titleLabel?.font = NXKit.font(16)
        addSubview(rhsView)
    }
}

open class NXFooterView: NXLCRView<NXButton, NXButton, NXButton> {
    override open func setupSubviews() {
        super.setupSubviews()

        backgroundColor = NXKit.backgroundColor

        let itemWidth: CGFloat = (width - 16.0 * 3.0) / 2.0

        lhsView.frame = CGRect(x: 16.0, y: 10, width: itemWidth, height: 40)
        lhsView.titleLabel?.font = NXKit.font(14)
        lhsView.layer.masksToBounds = true
        addSubview(lhsView)

        rhsView.frame = CGRect(x: 16.0 * 2.0 + itemWidth, y: 10, width: itemWidth, height: 40)
        rhsView.titleLabel?.font = NXKit.font(14)
        rhsView.layer.masksToBounds = true
        addSubview(rhsView)

        // 初始化一个button
        centerView.frame = CGRect(x: 16.0, y: 10, width: width - 16.0 - 16.0, height: 40)
        centerView.titleLabel?.font = NXKit.font(15)
        centerView.layer.masksToBounds = true
        addSubview(centerView)

        // 设置顶部分割线
        setupSeparator(color: NXKit.separatorColor, ats: .minY)
    }
}
