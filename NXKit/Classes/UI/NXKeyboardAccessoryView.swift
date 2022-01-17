//
//  NXKeyboardAccessoryView.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/9/19.
//  Copyright © 2021 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/9/19.
//  Copyright © 2019 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
//

import UIKit

open class NXKeyboardAccessoryView: NXView {
    public let bytesView = UILabel(frame: CGRect.zero)
    public let actionView = NXButton(frame: CGRect.zero)
    public var isEnabled : Bool = true
    open override func setupSubviews() {
        
        self.backgroundColor = NX.viewBackgroundColor
        self.setupSeparator(color: NX.separatorColor, ats: .minY, insets: UIEdgeInsets.zero)
        
        actionView.frame = CGRect(x: self.w - 55, y: 0, width: 50, height: self.h)
        actionView.setTitle("确定", for: .normal)
        actionView.setTitleColor(NX.mainColor, for: .normal)
        actionView.titleLabel?.font = NX.font(16, true)
        self.addSubview(actionView)
        
        bytesView.frame = CGRect(x: self.w - 140, y: 0, width: 80, height: self.h)
        bytesView.textColor = NX.color(0x92929B, 1)
        bytesView.font = NX.font(12)
        bytesView.textAlignment = .right
        self.addSubview(bytesView)
    }
}
