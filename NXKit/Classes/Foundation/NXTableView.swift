//
//  NXTableView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/20.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public struct NXTableDescriptor {
    public var placeholder = true
    public var calc = true

    public init() {}

    public init(placeholder: Bool, calc: Bool) {
        self.placeholder = placeholder
        self.calc = calc
    }
}

open class NXTableView: UITableView, NXViewProtocol {
    open var backdropView: UIImageView? = nil
    open weak var data: NXCollection<NXTableView>?

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    open func setupSubviews() {
        estimatedRowHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0
        backgroundColor = NXKit.viewBackgroundColor
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        separatorColor = NXKit.separatorColor
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if style == .plain {
            sectionHeaderHeight = 0
            sectionFooterHeight = 0
        } else {
            sectionHeaderHeight = 10
            sectionFooterHeight = 0
        }
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 0.01))
        tableHeaderView?.backgroundColor = UIColor.clear

        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 0.01))
        tableFooterView?.backgroundColor = UIColor.clear
    }

    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    // 设置下拉刷新时候跟导航栏保持一致颜色
    open func updateBackdropView(colors: [UIColor], start: CGPoint, end: CGPoint) {
        if backdropView == nil {
            backdropView = UIImageView(frame: bounds)
            backdropView?.frame = bounds.offsetBy(dx: 0, dy: -bounds.size.height)
            backdropView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        if let __backdropView = backdropView {
            addSubview(__backdropView)
            sendSubviewToBack(__backdropView)
            __backdropView.image = UIImage.image(colors: colors, size: __backdropView.frame.size, start: start, end: end)
        }
    }

    // 是否显示默认图
    open func updateSubviews(_ value: Any?) {
        if let __value = value as? NXTableDescriptor {
            data?.placeholderView.ctxs.isHidden = !__value.placeholder
            data?.calcAt = __value.calc
        } else {
            data?.placeholderView.ctxs.isHidden = false
            data?.calcAt = true
        }

        reloadData()
    }

    // 加载的时候看是否需要显示默认图
    override open func reloadData() {
        if let __tableWrapper = data {
            if __tableWrapper.elements.isEmpty {
                if __tableWrapper.placeholderView.ctxs.isHidden == false {
                    var size = CGSize(width: NXKit.width, height: 0)
                    if __tableWrapper.placeholderView.ctxs.frame.width > 0 && __tableWrapper.placeholderView.ctxs.frame.height > 0 {
                        size.height = __tableWrapper.placeholderView.ctxs.frame.height
                    } else {
                        var ___remainder = height - (tableHeaderView?.height ?? 0) - (tableFooterView?.height ?? 0)
                        ___remainder = ___remainder - contentInset.top - contentInset.bottom
                        size.height = max(___remainder, 250)
                    }
                    __tableWrapper.addPlaceholderView(CGRect(origin: CGPoint.zero, size: size))
                }
            }

            if __tableWrapper.calcAt {
                for __section in __tableWrapper.elements {
                    for __element in __section.elements {
                        var __element = __element
                        __element.at.first = false
                        __element.at.last = false
                    }
                    var first = __section.elements.first
                    var last = __section.elements.last
                    first?.at.first = true
                    last?.at.last = true
                }
            }
        }

        super.reloadData()
    }
}
