//
//  NXTableViewCell.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/15.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXTableViewCell: UITableViewCell, NXViewProtocol {
    open var value: Any? = nil
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        backgroundView?.layer.addSublayer(separator)
    }

    open func setupSubviews() {}

    open func updateSubviews(_: Any?) {}

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        separator.backgroundColor = NXKit.separatorColor.cgColor
    }
}
