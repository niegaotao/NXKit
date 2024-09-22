//
//  NXAbstract.swift
//  NXKit
//
//  Created by niegaotao on 2021/4/12.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXAbstract: NXItem {
    
    public let raw = NXKit.Appearance{(__sender) in
        __sender.isHighlighted = true
        __sender.backgroundColor = UIColor.clear
    }
    
    public let asset = NXKit.Attribute(completion:{(__sender) in
        __sender.color = NXKit.lightGrayColor
        __sender.backgroundColor = UIColor.clear
    })
    
    public let title = NXKit.Attribute(completion: {(__sender) in
        __sender.font = NXKit.font(16)
        __sender.textAlignment = NSTextAlignment.left
        __sender.backgroundColor = UIColor.clear
    })
    
    public let subtitle = NXKit.Attribute(completion: {(__sender) in
        __sender.font = NXKit.font(13)
        __sender.color = NXKit.lightGrayColor
        __sender.textAlignment = NSTextAlignment.left
        __sender.backgroundColor = UIColor.clear
    })
    
    public let value = NXKit.Attribute(completion: {(__sender) in
        __sender.font = NXKit.font(13)
        __sender.color = NXKit.lightGrayColor
        __sender.textAlignment = NSTextAlignment.right
        __sender.backgroundColor = UIColor.clear
    })
    
    public let arrow = NXKit.Attribute { (__sender) in
        __sender.frame = CGRect(x: 0, y: 0, width: 6, height: 12)
        __sender.backgroundColor = .clear
    }
    
    public required init() {
        super.init()
    }
    
    public override init(value: [String : Any]?, completion: NXKit.Completion<NXAbstract>?) {
        super.init(value: value, completion: nil)
        completion?(self)
    }
    
    public convenience init(title: String, value: [String: Any]?, completion: NXKit.Completion<NXAbstract>?) {
        self.init(value:value, completion:nil)
        self.ctxs.update(NXActionViewCell.self, "NXActionViewCell")
        self.ctxs.size = CGSize(width: NXKit.width, height: NXKit.Association.size.height)
        
        self.title.value = title
        self.title.frame = CGRect(x: 16, y: 0, width: NXKit.width-32, height: self.ctxs.height)
        self.title.textAlignment = .center
        completion?(self)
    }
}
