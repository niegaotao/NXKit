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
    open var isAnimated: Bool = false

    override open func setupSubviews() {
        super.setupSubviews()
        contentView.frame = bounds
        addSubview(contentView)
    }

    override open func updateSubviews(_ value: Any?) {
        let dicValue = value as? [String: Any] ?? [:]
        guard let isDisplay = dicValue["isDisplay"] as? Bool else {
            return
        }
        let animation = (dicValue["action"] as? String ?? "") == "animation"
        if isDisplay {
            isAnimated = false

            UIView.animate(withDuration: animation ? 0.4 : 0.0, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.y = 0
            }) { _ in
            }
        } else {
            if isAnimated == false {
                isAnimated = true

                UIView.animate(withDuration: animation ? 0.4 : 0.0) {
                    self.y = -self.height
                }
            }
        }
    }
}
