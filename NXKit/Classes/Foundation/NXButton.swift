//
//  NXButton.swift
//  NXKit
//
//  Created by niegaotao on 2020/4/28.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXButton: UIButton {
    public enum Axis {
        case horizontal
        case vertical
        case horizontalReverse
        case verticalReverse
    }

    // 给button赋值，这样在点击button可以直接使用
    open var value: [String: Any]?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    //
    open func setupSubviews() {}

    //
    open func updateSubviews(_: Any?) {}

    // 根据状态设置背景，icon/title/titleColor
    open func set(backgroundImage: UIImage?, image: UIImage?, title: String?, titleColor: UIColor?, for state: UIControl.State) {
        setBackgroundImage(backgroundImage, for: state)
        setImage(image, for: state)
        setTitle(title, for: state)
        setTitleColor(titleColor, for: state)
    }

    // 设置边框
    open func setBorder(_ color: UIColor, width: CGFloat, masksToBounds: Bool) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.masksToBounds = masksToBounds
    }

    // 设置icon/title的方位
    open func updateAlignment(_ axis: NXButton.Axis, _ space: CGFloat = 0.0) {
        let __size: (raw: CGSize, image: CGSize, title: CGSize) = (bounds.size, imageView?.bounds.size ?? CGSize.zero, (titleLabel?.bounds.size ?? CGSize.zero))
        let __centerX: (raw: CGFloat, image: CGFloat, title: CGFloat) = (bounds.width / 2.0, (bounds.width - __size.title.width) / 2.0, (bounds.width + __size.image.width) / 2.0)

        if axis == .vertical {
            titleEdgeInsets = UIEdgeInsets(top: __size.image.height / 2.0 + space / 2.0, left: -(__centerX.title - __centerX.raw), bottom: -(__size.image.height / 2.0 + space / 2.0), right: __centerX.title - __centerX.raw)
            imageEdgeInsets = UIEdgeInsets(top: -(__size.title.height / 2.0 + space / 2.0), left: __centerX.raw - __centerX.image, bottom: __size.title.height / 2.0 + space / 2.0, right: -(__centerX.raw - __centerX.image))
        } else if axis == .horizontal {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
        } else if axis == .horizontalReverse {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(__size.image.width + space / 2.0), bottom: 0, right: __size.image.width + space / 2.0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: __size.title.width + space / 2.0, bottom: 0, right: -(__size.title.width + space / 2.0))
        } else if axis == .verticalReverse {
            titleEdgeInsets = UIEdgeInsets(top: -(__size.image.height / 2 + space / 2), left: -(__centerX.title - __centerX.raw), bottom: __size.image.height / 2.0 + space / 2.0, right: __centerX.title - __centerX.raw)
            imageEdgeInsets = UIEdgeInsets(top: __size.title.height / 2 + space / 2, left: __centerX.raw - __centerX.image, bottom: -(__size.title.height / 2.0 + space / 2.0), right: -(__centerX.raw - __centerX.image))
        }
    }
}
