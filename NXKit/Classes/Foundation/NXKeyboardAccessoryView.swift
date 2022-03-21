//
//  NXKeyboardAccessoryView.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/19.
//  Copyright © 2019 TIMESCAPE. All rights reserved.
//

import UIKit

open class NXKeyboardAccessoryView: NXView {
    public let bytesView = UILabel(frame: CGRect.zero)
    public let actionView = NXButton(frame: CGRect.zero)
    public var isEnabled : Bool = true
    open override func setupSubviews() {
        
        self.backgroundColor = NXUI.viewBackgroundColor
        self.setupSeparator(color: NXUI.separatorColor, ats: .minY, insets: UIEdgeInsets.zero)
        
        actionView.frame = CGRect(x: self.w - 55, y: 0, width: 50, height: self.h)
        actionView.setTitle("确定", for: .normal)
        actionView.setTitleColor(NXUI.mainColor, for: .normal)
        actionView.titleLabel?.font = NXUI.font(16, true)
        self.addSubview(actionView)
        
        bytesView.frame = CGRect(x: self.w - 140, y: 0, width: 80, height: self.h)
        bytesView.textColor = NXUI.color(0x92929B, 1)
        bytesView.font = NXUI.font(12)
        bytesView.textAlignment = .right
        self.addSubview(bytesView)
    }
}
