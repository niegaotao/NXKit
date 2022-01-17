//
//  UIButton+NXFoundation.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/5/15.
=======
//  Created by niegaotao on 2020/5/15.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
//

import UIKit

extension  UIButton {
    //设置背景色
    open func setBackgroundColor(_ backgroundColor:UIColor, for state:UIControl.State) {
        self.setBackgroundImage(UIImage.image(color: backgroundColor, size: CGSize(width: 1.0, height: 1.0)), for: state)
    }
}
