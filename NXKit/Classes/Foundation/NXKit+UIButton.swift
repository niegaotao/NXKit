//
//  UIButton+NXFoundation.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/15.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit

extension  UIButton {
    //设置背景色
    public func setBackgroundColor(_ backgroundColor:UIColor, for state:UIControl.State) {
        self.setBackgroundImage(UIImage.image(color: backgroundColor, size: CGSize(width: 1.0, height: 1.0)), for: state)
    }
}
