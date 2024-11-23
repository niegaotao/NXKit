//
//  NXAbstractView.swift
//  NXKit
//
//  Created by niegaotao on 2021/4/7.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXAbstractView: NXView {
    public let assetView = UIImageView(frame: CGRect.zero)
    public let titleView = UILabel(frame: CGRect.zero)
    public let subtitleView = UILabel(frame: CGRect.zero)
    public let valueView = UILabel(frame: CGRect.zero)
    public let arrowView = UIImageView(frame: CGRect.zero)
    public let separator = CALayer()

    override open func setupSubviews() {
        assetView.contentMode = .scaleAspectFill
        assetView.layer.masksToBounds = true
        addSubview(assetView)

        titleView.font = NXKit.font(16)
        titleView.textAlignment = .left
        titleView.textColor = NXKit.blackColor
        titleView.layer.masksToBounds = true
        addSubview(titleView)

        subtitleView.font = NXKit.font(14)
        subtitleView.textAlignment = .left
        subtitleView.textColor = NXKit.lightGrayColor
        subtitleView.layer.masksToBounds = true
        addSubview(subtitleView)

        valueView.font = NXKit.font(14)
        valueView.textAlignment = .right
        valueView.textColor = NXKit.lightGrayColor
        valueView.layer.masksToBounds = true
        addSubview(valueView)

        arrowView.contentMode = .scaleAspectFill
        arrowView.layer.masksToBounds = true
        addSubview(arrowView)

        separator.backgroundColor = NXKit.separatorColor.cgColor
        separator.isHidden = true
        layer.addSublayer(separator)
    }

    override open func updateSubviews(_ value: Any?) {
        guard let __abstract = value as? NXAbstract else {
            return
        }

        NXKit.View.update(__abstract.raw, self)
        NXKit.View.update(__abstract.asset, assetView)
        NXKit.View.update(__abstract.title, titleView)
        NXKit.View.update(__abstract.subtitle, subtitleView)
        NXKit.View.update(__abstract.value, valueView)
        NXKit.View.update(__abstract.arrow, arrowView)

        let __separator = __abstract.raw.separator
        var __isHidden = false
        if __separator.ats.contains(.maxY) || __separator.ats.contains(.maxX) {
            __isHidden = __abstract.at.last
        } else if __separator.ats.contains(.minY) || __separator.ats.contains(.minX) {
            __isHidden = __abstract.at.first
        } else {
            __isHidden = true
        }

        if __isHidden {
            separator.isHidden = true
        } else {
            separator.isHidden = false
            var __frame = CGRect.zero
            if __separator.ats.contains(.minY) || __separator.ats.contains(.maxY) {
                __frame = CGRect(x: __separator.insets.left, y: 0, width: __abstract.size.width - __separator.insets.left - __separator.insets.right, height: NXKit.pixel)
                if __abstract.raw.separator.ats.contains(.maxY) {
                    __frame.origin.y = __abstract.size.height - NXKit.pixel
                }
            } else if __separator.ats.contains(.minX) || __separator.ats.contains(.maxX) {
                __frame = CGRect(x: 0, y: __separator.insets.top, width: NXKit.pixel, height: __abstract.size.height - __separator.insets.top - __separator.insets.bottom)
                if __separator.ats.contains(.maxX) {
                    __frame.origin.x = __abstract.size.width - NXKit.pixel
                }
            }

            separator.frame = __frame
            separator.backgroundColor = __separator.backgroundColor.cgColor
        }
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        separator.backgroundColor = NXKit.separatorColor.cgColor
    }
}
