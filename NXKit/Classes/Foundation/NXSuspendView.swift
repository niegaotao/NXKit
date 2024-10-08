//
//  NXSuspendView.swift
//  NXKit
//
//  Created by niegaotao on 2020/1/5.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit

open class NXSuspendView<T: UIView>: NXView {
    public let contentView = T()
    open var isAnimated : Bool = false

    open override func setupSubviews() {
        super.setupSubviews()
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
        
    open override func updateSubviews(_ value: Any?) {
        let dicValue = value as? [String: Any] ?? [:]
        guard let isDisplay = dicValue["isDisplay"] as? Bool else {
            return
        }
        let animation = (dicValue["action"] as? String ?? "") == "animation"
        if isDisplay {
            self.isAnimated = false
            
            UIView.animate(withDuration: (animation ? 0.4 : 0.0), delay: 0.2, options: [.curveEaseInOut], animations: {
                self.y = 0
            }) { (completed) in
                
            }
        }
        else{
            if self.isAnimated == false {
                self.isAnimated = true
                
                UIView.animate(withDuration: (animation ? 0.4 : 0.0)) {
                    self.y = -self.height
                }
            }
        }
    }
}
