//
//  UIButton+LEYFoundation.swift
//  NXFoundation
//
//  Created by firelonely on 2019/5/15.
//

import UIKit

extension  UIButton {
    //设置背景色
    open func setBackgroundColor(_ backgroundColor:UIColor, for state:UIControl.State) {
        self.setBackgroundImage(UIImage.image(color: backgroundColor, size: CGSize(width: 1.0, height: 1.0)), for: state)
    }
}
