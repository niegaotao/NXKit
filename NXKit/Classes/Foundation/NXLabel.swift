//
//  NXLabel.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/28.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXLabel: UILabel, NXViewProtocol {
    open var value: [String: Any]?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    open func setupSubviews() {}

    open func updateSubviews(_: Any?) {}
}
