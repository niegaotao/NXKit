//
//  NXTableReusableView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/15.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXTableReusableView: UITableViewHeaderFooterView {
    open var value: Any? = nil
    override public required init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    open func setupSubviews() {
        let __backgroundView = UIView(frame: bounds)
        __backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        __backgroundView.backgroundColor = UIColor.clear
        backgroundView = __backgroundView

        contentView.backgroundColor = UIColor.clear
    }

    open func updateSubviews(_ value: Any?) {
        if let element = value as? NXItem {
            self.value = element
            contentView.backgroundColor = element.backgroundColor ?? UIColor.clear
        }
    }
}
