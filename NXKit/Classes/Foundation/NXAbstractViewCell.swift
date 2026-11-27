//
//  NXAbstractViewCell.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/17.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit

open class NXAbstractTableViewCell<T: UIView>: NXTableViewCell {
    public let abstractView = T(frame: CGRect.zero)

    override open func setupSubviews() {
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectedBackgroundView?.backgroundColor = NXKit.cellSelectedBackgroundColor

        if let __abstractView = abstractView as? NXAbstractView {
            __abstractView.assetView.backgroundColor = UIColor.white
            __abstractView.assetView.layer.cornerRadius = 12
            __abstractView.assetView.layer.masksToBounds = true
            __abstractView.assetView.contentMode = .scaleAspectFill
            __abstractView.titleView.textAlignment = .center
            __abstractView.titleView.textColor = NXKit.blackColor
            __abstractView.titleView.font = NXKit.font(16)
            __abstractView.titleView.numberOfLines = 0
            __abstractView.subtitleView.textAlignment = .center
            __abstractView.subtitleView.textColor = NXKit.lightGrayColor
            __abstractView.subtitleView.font = NXKit.font(13)
            __abstractView.subtitleView.numberOfLines = 0
            __abstractView.subtitleView.isHidden = true
        }
        contentView.addSubview(abstractView)

        contentView.bringSubviewToFront(arrowView)

        separator.backgroundColor = NXKit.separatorColor.cgColor
        separator.isHidden = true
    }

    override open func updateSubviews(_ value: Any?) {
        abstractView.frame = contentView.bounds
        if let __abstractView = abstractView as? NXAbstractView {
            __abstractView.updateSubviews(value)

            if let __wrapped = value as? NXAbstract, __wrapped.raw.isHighlighted {
                selectedBackgroundView?.backgroundColor = __wrapped.raw.selectedBackgroundColor
            } else {
                selectedBackgroundView?.backgroundColor = UIColor.clear
            }
            arrowView.isHidden = true
            separator.isHidden = true
        } else if let __abstractView = abstractView as? NXView {
            __abstractView.updateSubviews(value)
            selectedBackgroundView?.backgroundColor = UIColor.clear
        }
    }
}

open class NXAbstractCollectionViewCell<T: UIView>: NXCollectionViewCell {
    public let abstractView = T(frame: CGRect.zero)

    override open func setupSubviews() {
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectedBackgroundView?.backgroundColor = NXKit.cellSelectedBackgroundColor

        if let __abstractView = abstractView as? NXAbstractView {
            __abstractView.assetView.backgroundColor = UIColor.white
            __abstractView.assetView.layer.cornerRadius = 12
            __abstractView.assetView.layer.masksToBounds = true
            __abstractView.assetView.contentMode = .scaleAspectFill
            __abstractView.titleView.textAlignment = .center
            __abstractView.titleView.textColor = NXKit.blackColor
            __abstractView.titleView.font = NXKit.font(16)
            __abstractView.titleView.numberOfLines = 0
            __abstractView.subtitleView.textAlignment = .center
            __abstractView.subtitleView.textColor = NXKit.lightGrayColor
            __abstractView.subtitleView.font = NXKit.font(13)
            __abstractView.subtitleView.numberOfLines = 0
            __abstractView.subtitleView.isHidden = true
        }
        contentView.addSubview(abstractView)

        contentView.bringSubviewToFront(arrowView)

        separator.backgroundColor = NXKit.separatorColor.cgColor
        separator.isHidden = true
    }

    override open func updateSubviews(_ value: Any?) {
        abstractView.frame = contentView.bounds
        if let __abstractView = abstractView as? NXAbstractView {
            __abstractView.updateSubviews(value)

            if let __wrapped = value as? NXAbstract, __wrapped.raw.isHighlighted {
                selectedBackgroundView?.backgroundColor = __wrapped.raw.selectedBackgroundColor
            } else {
                selectedBackgroundView?.backgroundColor = UIColor.clear
            }
            arrowView.isHidden = true
            separator.isHidden = true
        } else if let __abstractView = abstractView as? NXView {
            __abstractView.updateSubviews(value)
            selectedBackgroundView?.backgroundColor = UIColor.clear
        }
    }
}

open class NXAbstractViewCell: NXAbstractTableViewCell<NXAbstractView> {}

open class NXActionViewCell: NXAbstractCollectionViewCell<NXAbstractView> {}
