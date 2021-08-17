//
//  NXButton.swift
//  NXKit
//
//  Created by niegaotao on 2018/4/28.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXButton: UIButton {
    public enum Alignment {
        case horizonontal
        case vertical
        case horizonontalReverse
        case verticalReverse
    }
    
    //给button赋值，这样在点击button可以直接使用
    open var value: [String: Any]?
    
    //是否需要扩大热键范围
    open var allowsClickRange: Bool = true
    
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
    open func updateSubviews(_ action: String, _ value:Any?){
    
    }
    
    ///构造函数
    public convenience init(_ frame: CGRect, image: UIImage?, backgroundImage: UIImage?, title: String?, data: [String: Any]?) {
        self.init(frame: frame)
        self.setImage(image, for: .normal)
        
        self.setTitle(title, for: .normal)
        
        self.setBackgroundImage(backgroundImage, for: .normal)
        
        self.value = data
    }
    
    public convenience init(_ frame: CGRect, image: UIImage?, backgroundImage: UIImage?, title: String?, titleColor: UIColor, titleFont: UIFont, data: [String: Any]?) {
        self.init(frame, image: image, backgroundImage: backgroundImage, title: title, data: data)
        
        self.setTitleColor(titleColor, for: .normal)
        
        self.titleLabel?.font = titleFont
    }
    
    //根据状态设置背景，icon/title/titleColor
    open func set(backgroundImage:UIImage?, image:UIImage?, title:String?, titleColor:UIColor?, for state: UIControl.State){
        self.setBackgroundImage(backgroundImage, for: state)
        self.setImage(image, for: state)
        self.setTitle(title, for: state)
        self.setTitleColor(titleColor, for: state)
    }
    
    //设置边框
    open func setBorder(_ color:UIColor, width:CGFloat, masksToBounds:Bool) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.masksToBounds = masksToBounds
    }
    
    //设置icon/title的方位
    open func updateAlignment(_ __aligment: NXButton.Alignment, _ space:CGFloat = 0.0){
        let __size : (raw:CGSize, image:CGSize, title:CGSize) = (self.bounds.size, (self.imageView?.bounds.size ?? CGSize.zero), (self.titleLabel?.bounds.size ?? CGSize.zero))
        let __centerX : (raw:CGFloat, image:CGFloat, title:CGFloat) = (self.bounds.width/2.0, (self.bounds.width-__size.title.width)/2.0,(self.bounds.width+__size.image.width)/2.0)
        
        if __aligment == .vertical {
            self.titleEdgeInsets = UIEdgeInsets(top: __size.image.height/2.0+space/2.0, left: -(__centerX.title-__centerX.raw), bottom: -(__size.image.height/2.0+space/2.0), right: __centerX.title-__centerX.raw)
            self.imageEdgeInsets = UIEdgeInsets(top: -(__size.title.height/2.0+space/2.0), left: __centerX.raw-__centerX.image, bottom: __size.title.height/2.0+space/2.0, right: -(__centerX.raw-__centerX.image))
        }
        else if __aligment == .horizonontal {
            self.titleEdgeInsets = UIEdgeInsets(top:0, left:space/2.0, bottom:0, right:-space/2.0)
            self.imageEdgeInsets = UIEdgeInsets(top:0, left:-space/2.0, bottom:0, right:space/2.0)
        }
        else if __aligment == .horizonontalReverse {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(__size.image.width+space/2.0), bottom: 0, right: __size.image.width+space/2.0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: __size.title.width+space/2.0, bottom: 0, right: -(__size.title.width+space/2.0))
        }
        else if __aligment == .verticalReverse {
            self.titleEdgeInsets = UIEdgeInsets(top:-(__size.image.height/2+space/2), left:-(__centerX.title-__centerX.raw), bottom:__size.image.height/2.0+space/2.0, right:__centerX.title-__centerX.raw)
            self.imageEdgeInsets = UIEdgeInsets(top:__size.title.height/2+space/2, left:__centerX.raw-__centerX.image, bottom:-(__size.title.height/2.0+space/2.0), right:-(__centerX.raw-__centerX.image))
        }
    }
}



/*
 扩大button的点击热键范围
 
 若原热区小于36x36，则放大热区，否则保持原大小不变
 */
extension NXButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var widthDelta: CGFloat = 0
        var heightDelta: CGFloat = 0
        
        if allowsClickRange == true {
            widthDelta = max(36.0-self.bounds.size.width, 0) / 2
            heightDelta = max(36.0-self.bounds.size.height, 0) / 2
        }
        
        let area = self.bounds.insetBy(dx: -widthDelta, dy: -heightDelta)
        return area.contains(point)
    }
}








