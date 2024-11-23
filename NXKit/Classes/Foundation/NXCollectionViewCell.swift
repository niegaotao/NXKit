//
//  NXCollectionViewCell.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/20.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionViewCell: UICollectionViewCell, NXViewProtocol {
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()
    open var value: Any? = nil

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
    }

    open func setup() {
        arrowView.frame = CGRect(x: contentView.width - 16.0 - 6, y: (contentView.height - 12) / 2, width: 6, height: 12)
        arrowView.image = NXKit.image(named: "icon-arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        contentView.addSubview(arrowView)

        if backgroundView == nil {
            backgroundView = UIView(frame: CGRect.zero)
            backgroundView?.backgroundColor = NXKit.cellBackgroundColor
            backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        separator.backgroundColor = NXKit.separatorColor.cgColor
        separator.isHidden = true
        contentView.layer.addSublayer(separator)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupSubviews()
    }

    // MARK: 子类重写该方法初始化视图

    open func setupSubviews() {}

    open func updateSubviews(_: Any?) {}

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        separator.backgroundColor = NXKit.separatorColor.cgColor
    }
}
