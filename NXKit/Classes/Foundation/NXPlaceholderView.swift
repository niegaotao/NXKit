//
//  NXPlaceholderView.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/7.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

// 占位图
open class NXPlaceholderView: NXCView<NXLCRView<UIImageView, UILabel, UIButton>> {
    public let ctxs = NXPlaceholderViewDescriptor()

    open var assetView: UIImageView { return contentView.lhsView }
    open var descriptionView: UILabel { return contentView.centerView }
    open var footerView: UIButton { return contentView.rhsView }
    open var customizableView: UIView? = nil // 自定义的默认图

    override open func setupSubviews() {
        super.setupSubviews()

        layer.masksToBounds = true
        contentView.setupEvent(UIControl.Event.tap) { [weak self] _, _ in
            self?.ctxs.event?("", nil)
        }
    }

    override open func updateSubviews(_: Any?) {
        if ctxs.isHidden == false {
            if let __customizableView = customizableView {
                __customizableView.isHidden = false
                __customizableView.frame = CGRect(x: (bounds.width - __customizableView.width) / 2, y: (bounds.height - __customizableView.height) / 2, width: __customizableView.width, height: __customizableView.height)
                addSubview(__customizableView)

                contentView.isHidden = true
            } else {
                contentView.isHidden = false
                contentView.frame = ctxs.frame
                contentView.frame = CGRect(x: (bounds.width - ctxs.frame.size.width) / 2, y: (bounds.height - ctxs.frame.size.height) / 2, width: ctxs.frame.size.width, height: ctxs.frame.size.height)
                addSubview(contentView)

                contentView.lhsView.frame = ctxs.m.frame
                if ctxs.m.image != nil {
                    contentView.lhsView.image = ctxs.m.image
                } else if ctxs.m.value.count > 0 {
                    if ctxs.t.value.hasPrefix("http") {
                        NXKit.image(contentView.lhsView, ctxs.m.value)
                    } else {
                        contentView.lhsView.image = UIImage(named: ctxs.m.value)
                    }
                } else {
                    contentView.lhsView.image = nil
                }
                contentView.lhsView.contentMode = .scaleAspectFit

                contentView.centerView.frame = ctxs.t.frame
                contentView.centerView.text = ctxs.t.value
                contentView.centerView.textAlignment = ctxs.t.textAlignment
                contentView.centerView.numberOfLines = ctxs.t.numberOfLines
                contentView.centerView.font = ctxs.t.font
                contentView.centerView.textColor = ctxs.t.color

                contentView.rhsView.isHidden = true

                customizableView?.isHidden = true
            }
        } else {
            customizableView?.isHidden = true
            contentView.isHidden = true
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        contentView.center = center
    }
}

open class NXPlaceholderViewDescriptor {
    open var isHidden = true

    open var event: NXKit.Event<String, Any?>?

    open var frame = CGRect(x: 0, y: 0, width: 320, height: 256)

    public let m = NXKit.Attribute { __sender in
        __sender.frame = CGRect(x: 0, y: 0, width: 320, height: 170)
    }

    public let t = NXKit.Attribute { __sender in
        __sender.frame = CGRect(x: 0, y: 175, width: 320, height: 55)
        __sender.value = "暂无数据～"
        __sender.textAlignment = .center
        __sender.numberOfLines = 0
        __sender.font = NXKit.font(16)
        __sender.color = NXKit.lightGrayColor
    }
}

open class NXPlaceholderDescriptor: NXItem, NXCollectionViewAttributesProtocol {
    open var placeholderView: NXPlaceholderView?
    open var attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))
}

open class NXTablePlaceholderViewCell: NXTableViewCell {
    override open func setupSubviews() {
        super.setupSubviews()
        selectionStyle = .none
        accessoryType = .none
        arrowView.isHidden = true
    }

    override open func updateSubviews(_ value: Any?) {
        guard let item = value as? NXPlaceholderDescriptor, let placeholderView = item.placeholderView else {
            return
        }
        placeholderView.frame = CGRect(x: 0, y: 0, width: item.size.width, height: item.size.height)
        placeholderView.updateSubviews(value)
        backgroundView?.backgroundColor = placeholderView.backgroundColor
        contentView.addSubview(placeholderView)
    }
}

open class NXCollectionPlaceholderViewCell: NXCollectionViewCell {
    override open func setupSubviews() {
        super.setupSubviews()
    }

    override open func updateSubviews(_ value: Any?) {
        guard let item = value as? NXPlaceholderDescriptor, let placeholderView = item.placeholderView else {
            return
        }

        placeholderView.frame = CGRect(x: 0, y: 0, width: item.size.width, height: item.size.height)
        placeholderView.updateSubviews(value)
        backgroundView?.backgroundColor = placeholderView.backgroundColor
        contentView.addSubview(placeholderView)
    }
}
