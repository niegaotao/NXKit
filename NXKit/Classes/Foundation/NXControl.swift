//
//  NXControl.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/12.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXControl: UIControl, NXViewProtocol {
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
