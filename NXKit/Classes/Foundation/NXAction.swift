//
//  NXAction.swift
//  NXKit
//
//  Created by niegaotao on 2021/4/12.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXAction: NXItem {
    
    public let appearance = NX.Appearance{(_, __sender) in
        __sender.isHighlighted = true
        __sender.backgroundColor = UIColor.clear
    }
    
    public let asset = NX.Attribute(completion:{(_, __sender) in
        __sender.color = NXUI.darkGrayColor
        __sender.backgroundColor = UIColor.clear
    })
    
    public let title = NX.Attribute(completion: {(_, __sender) in
        __sender.font = NXUI.font(16)
        __sender.textAlignment = NSTextAlignment.left
        __sender.backgroundColor = UIColor.clear
    })
    
    public let subtitle = NX.Attribute(completion: {(_, __sender) in
        __sender.font = NXUI.font(13)
        __sender.color = NXUI.darkGrayColor
        __sender.textAlignment = NSTextAlignment.left
        __sender.backgroundColor = UIColor.clear
    })
    
    public let value = NX.Attribute(completion: {(_, __sender) in
        __sender.font = NXUI.font(13)
        __sender.color = NXUI.darkGrayColor
        __sender.textAlignment = NSTextAlignment.right
        __sender.backgroundColor = UIColor.clear
    })
    
    public let arrow = NX.Attribute { (_, __sender) in
        __sender.frame = CGRect(x: 0, y: 0, width: 6, height: 12)
        __sender.backgroundColor = .clear
    }
    
    public required init() {
        super.init()
    }
    
    public override init(value: [String : Any]?, completion: NX.Completion<String, NXAction>?) {
        super.init(value: value, completion: nil)
        completion?("init", self)
    }
    
    public convenience init(title:String, value: [String: Any]?, completion:NX.Completion<String, NXAction>?) {
        self.init(value:value, completion:nil)
        self.ctxs.update(NXActionViewCell.self, "NXActionViewCell")
        self.ctxs.size = CGSize(width: NXUI.width, height: NX.Association.size.height)
        
        self.title.value = title
        self.title.frame = CGRect(x: 16, y: 0, width: NXUI.width-32, height: self.ctxs.height)
        self.title.textAlignment = .center
        completion?("init", self)
    }
}
