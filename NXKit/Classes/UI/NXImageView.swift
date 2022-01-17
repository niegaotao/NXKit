//
//  NXImageView.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/5/17.
//  Copyright © 2018年 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/5/17.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
//

import UIKit


open class NXImageView: UIImageView {
    open var value: [String: Any]?  //给UIImageView赋值
    
    public init(){
        super.init(frame: CGRect.zero)
        self.setupSubviews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    open func setupSubviews(){
        
    }
    
    
    open func updateSubviews(_ action: String, _ value:Any?){
    
    }
}
