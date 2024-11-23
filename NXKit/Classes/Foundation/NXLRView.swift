//
//  NXLRView.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/16.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXLRView<L: UIView, R: UIView>: NXView {
    public var lhsView = L(frame: CGRect.zero) // 左侧
    public var rhsView = R(frame: CGRect.zero) // 右侧

    override open func setupSubviews() {
        super.setupSubviews()
        addSubview(lhsView)
        addSubview(rhsView)
    }
}

open class NXMTView: NXLRView<UIImageView, UILabel> {
    open var mView: UIImageView {
        return lhsView
    }

    open var tView: UILabel {
        return rhsView
    }

    override open func setupSubviews() {
        super.setupSubviews()
        mView.frame = CGRect(x: 0, y: 0, width: height, height: height)
        mView.contentMode = .scaleAspectFill

        tView.frame = CGRect(x: height, y: 0, width: width - height, height: height)
        tView.textAlignment = .left
        tView.font = NXKit.font(13)
        tView.textColor = NXKit.lightGrayColor
    }

    open var index: Int = 0
    open var value: [String: Any]? = nil
}

// 纵向的2个label
open class NXTTView: NXLRView<UILabel, UILabel> {
    open var topView: UILabel {
        return lhsView
    }

    open var bottomView: UILabel {
        return rhsView
    }

    override open func setupSubviews() {
        super.setupSubviews()

        topView.frame = CGRect(x: height, y: 0, width: width - height, height: height)
        topView.textAlignment = .center
        topView.font = NXKit.font(13)
        topView.textColor = NXKit.lightGrayColor

        bottomView.frame = CGRect(x: height, y: 0, width: width - height, height: height)
        bottomView.textAlignment = .center
        bottomView.font = NXKit.font(13)
        bottomView.textColor = NXKit.lightGrayColor
    }
}
