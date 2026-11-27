//
//  NXButton.swift
//  NXKit
//
//  Created by niegaotao on 2020/4/28.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXButton: UIButton {
    public enum Axis {
        case horizontal
        case vertical
        case horizontalReverse
        case verticalReverse
    }
    
    //给button赋值，这样在点击button可以直接使用
    open var value: [String: Any]?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    //
    open func setupSubviews(){
        
    }
    
    //
    open func updateSubviews(_ action: String, _ value: Any?){
    
    }
    
    //根据状态设置背景，icon/title/titleColor
    open func set(backgroundImage: UIImage?, image: UIImage?, title: String?, titleColor: UIColor?, for state: UIControl.State){
        self.setBackgroundImage(backgroundImage, for: state)
        self.setImage(image, for: state)
        self.setTitle(title, for: state)
        self.setTitleColor(titleColor, for: state)
    }
    
    //设置边框
    open func setBorder(_ color: UIColor, width: CGFloat, masksToBounds: Bool) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.masksToBounds = masksToBounds
    }
    
    //设置icon/title的方位
    open func updateAlignment(_ axis: NXButton.Axis, _ space: CGFloat = 0.0){
        let __size : (raw: CGSize, image: CGSize, title: CGSize) = (self.bounds.size, (self.imageView?.bounds.size ?? CGSize.zero), (self.titleLabel?.bounds.size ?? CGSize.zero))
        let __centerX : (raw: CGFloat, image: CGFloat, title: CGFloat) = (self.bounds.width/2.0, (self.bounds.width-__size.title.width)/2.0,(self.bounds.width+__size.image.width)/2.0)
        
        if axis == .vertical {
            self.titleEdgeInsets = UIEdgeInsets(top: __size.image.height/2.0+space/2.0, left: -(__centerX.title-__centerX.raw), bottom: -(__size.image.height/2.0+space/2.0), right: __centerX.title-__centerX.raw)
            self.imageEdgeInsets = UIEdgeInsets(top: -(__size.title.height/2.0+space/2.0), left: __centerX.raw-__centerX.image, bottom: __size.title.height/2.0+space/2.0, right: -(__centerX.raw-__centerX.image))
        }
        else if axis == .horizontal {
            self.titleEdgeInsets = UIEdgeInsets(top:0, left:space/2.0, bottom:0, right:-space/2.0)
            self.imageEdgeInsets = UIEdgeInsets(top:0, left:-space/2.0, bottom:0, right:space/2.0)
        }
        else if axis == .horizontalReverse {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(__size.image.width+space/2.0), bottom: 0, right: __size.image.width+space/2.0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: __size.title.width+space/2.0, bottom: 0, right: -(__size.title.width+space/2.0))
        }
        else if axis == .verticalReverse {
            self.titleEdgeInsets = UIEdgeInsets(top:-(__size.image.height/2+space/2), left:-(__centerX.title-__centerX.raw), bottom:__size.image.height/2.0+space/2.0, right:__centerX.title-__centerX.raw)
            self.imageEdgeInsets = UIEdgeInsets(top:__size.title.height/2+space/2, left:__centerX.raw-__centerX.image, bottom:-(__size.title.height/2.0+space/2.0), right:-(__centerX.raw-__centerX.image))
        }
    }
}


