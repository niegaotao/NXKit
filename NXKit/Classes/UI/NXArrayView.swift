//
//  NXArrayView.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/29.
//

import UIKit


open class NXArrayView<S:UIView>: NXView {
    
    public enum Axis {
        case row
        case column
    }
    
    public enum MainAxisAlignment {
        case start
        case center
        case end
        case spaceBetween
        case spaceAround
        case spaceEvenly
    }
    
    public enum CrossAxisAlignment {
        case start
        case center
        case end
    }
    
    open var componentViews = [S]()
    open var insets = UIEdgeInsets.zero
    open var axis = Axis.row
    open var mainAxisAlignment = MainAxisAlignment.start
    open var crossAxisAlignment = CrossAxisAlignment.center
    
    open func componentView(at index:Int) -> S {
        if index >= 0 && index < self.componentViews.count {
            return self.componentViews[index]
        }
        let componentView = S(frame: CGRect.zero)
        self.componentViews.append(componentView)
        self.addSubview(componentView)
        return componentView
    }
    
    
    //子类手动调用
    open func setupSubviews(_ capacity:Int) {
        var __numberOfSubviews = capacity - self.componentViews.count;
        while __numberOfSubviews >= 1 {
            let contentView = S(frame: CGRect.zero)
            self.componentViews.append(contentView)
            self.addSubview(contentView)
            __numberOfSubviews = __numberOfSubviews - 1
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.axis == .row {
            
            if self.mainAxisAlignment == .spaceAround {
                
            }
        }
    }
}
