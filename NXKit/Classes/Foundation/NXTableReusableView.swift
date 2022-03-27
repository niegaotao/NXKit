//
//  NXTableReusableView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/15.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXTableReusableView: UITableViewHeaderFooterView {
    open var value : Any? = nil
    required public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    open func setupSubviews(){
        let __backgroundView = UIView(frame: self.bounds)
        __backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        __backgroundView.backgroundColor = UIColor.clear
        self.backgroundView = __backgroundView
        
        self.contentView.backgroundColor = UIColor.clear
    }
    
    open func updateSubviews(_ action:String, _ value: Any?) {
        if let element = value as? NXItem {
            self.value = element
            self.contentView.backgroundColor = element.ctxs.backgroundColor ?? UIColor.clear
        }
    }
    
    open func willDisplay(_ data: Any?){
    
    }
    
    open func didEndDisplay(_ data: Any?){
    
    }
}
