//
//  NXTableViewCell.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/6/15.
//  Copyright © 2018年 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/6/15.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
//

import UIKit

open class NXTableViewCell: UITableViewCell {
    open var value : Any? = nil
    open var arrowView = UIImageView(frame: CGRect.zero)
    open var separator = CALayer()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setupSubviews()
    }
    
    open func setup(){
        arrowView.frame = CGRect(x: contentView.w-NX.insets.right-6, y: (contentView.h-12)/2, width: 6, height: 12)
        arrowView.image = NX.image(named:"icon-arrow.png")
        arrowView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        arrowView.contentMode = .scaleAspectFill
        arrowView.isHidden = true
        self.contentView.addSubview(arrowView)
        
        if self.backgroundView == nil {
            self.backgroundView = UIView(frame: CGRect.zero)
            self.backgroundView?.backgroundColor = NX.backgroundColor
            self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        separator.backgroundColor = NX.separatorColor.cgColor
        separator.isHidden = true
        self.backgroundView?.layer.addSublayer(separator)
    }
    
    /// 子类直接重写该方法进行UI视图的初始化和布局
    open func setupSubviews(){
        
    }
    
    
    /// 子类重写该方法进行数据绑定操作
    open func updateSubviews(_ action:String, _ value: Any?){
        
    }
}
