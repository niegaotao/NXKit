//
//  NXKeyboardAccessoryView.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/19.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit

open class NXKeyboardAccessoryView: NXView {
    public let bytesView = UILabel(frame: CGRect.zero)
    public let actionView = NXButton(frame: CGRect.zero)
    public var isEnabled : Bool = true
    open override func setupSubviews() {
        
        self.backgroundColor = NX.viewBackgroundColor
        self.setupSeparator(color: NX.separatorColor, ats: .minY, insets: UIEdgeInsets.zero)
        
        actionView.frame = CGRect(x: self.width - 55, y: 0, width: 50, height: self.height)
        actionView.setTitle("确定", for: .normal)
        actionView.setTitleColor(NX.mainColor, for: .normal)
        actionView.titleLabel?.font = NX.font(16, .bold)
        self.addSubview(actionView)
        
        bytesView.frame = CGRect(x: self.width - 140, y: 0, width: 80, height: self.height)
        bytesView.textColor = NX.lightGrayColor
        bytesView.font = NX.font(12)
        bytesView.textAlignment = .right
        self.addSubview(bytesView)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.association?.separator?.backgroundColor = NX.separatorColor.cgColor
    }
}
