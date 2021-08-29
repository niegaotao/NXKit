//
//  NXArrayView.swift
//  NXKit
//
//  Created by niegaotao on 2021/8/29.
//

import UIKit

open class NXArrayView<C:UIView>: NXView {
    open var contentViews = [C]()
    
    //子类手动调用
    open func setupSubviews(_ numberOfSubviews:Int) {
        var __numberOfSubviews = numberOfSubviews - self.contentViews.count;
        while __numberOfSubviews >= 1 {
            let contentView = C(frame: CGRect.zero)
            self.contentViews.append(contentView)
            __numberOfSubviews = __numberOfSubviews - 1
        }
    }
}
