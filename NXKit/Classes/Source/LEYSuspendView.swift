//
//  LEYSuspendView.swift
//  NXFoundation
//
//  Created by firelonely on 2021/1/5.
//

import UIKit

open class LEYSuspendView<T:UIView>: LEYView {
    public let contentView = T()
    open var isAnimated : Bool = false

    open override func setupSubviews() {
        super.setupSubviews()
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
        
    open override func updateSubviews(_ action: String, _ value: Any?) {
        guard let isDisplay = value as? Bool else {
            return
        }
        let animation = action == "animation"
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
                    self.y = -self.h
                }
            }
        }
    }
}
