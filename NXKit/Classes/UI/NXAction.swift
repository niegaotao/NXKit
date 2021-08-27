//
//  NXAction.swift
//  NXKit
//
//  Created by niegaotao on 2020/4/12.
//

import UIKit

open class NXAction: NXItem {
    
    public let appearance = NX.Appearance{(_, __sender) in
        __sender.isHighlighted = true
    }
    
    public let asset = NX.Attribute(completion:{(_, __sender) in
        __sender.color = NX.darkGrayColor
    })
    
    public let title = NX.Attribute(completion: {(_, __sender) in
        __sender.font = NX.font(16)
        __sender.textAlignment = .left
        __sender.backgroundColor = UIColor.clear
    })
    
    public let subtitle = NX.Attribute(completion: {(_, __sender) in
        __sender.font = NX.font(13)
        __sender.color = NX.darkGrayColor
        __sender.textAlignment = .left
        __sender.backgroundColor = UIColor.clear
    })
    
    public let access = NX.Attribute(completion: {(_, __sender) in
        __sender.font = NX.font(13)
        __sender.color = NX.darkGrayColor
        __sender.textAlignment = .right
        __sender.backgroundColor = UIColor.clear
    })
    
    public let arrow = NX.Attribute { (_, __sender) in
        __sender.frame = CGRect(x: 0, y: 0, width: 6, height: 12)
    }
    
    public convenience init(completion:NX.Completion<String, NXAction>?) {
        self.init()
        completion?("", self)
    }
    
    public convenience init(title:String, value: [String: Any]?, completion:NX.Completion<String, NXAction>?) {
        self.init()
        self.ctxs.value = value
        self.ctxs.update(NXActionViewCell.self, "NXActionViewCell")
        self.ctxs.size = CGSize(width: NXDevice.width, height: NX.Association.size.height)
        
        self.title.value = title
        self.title.frame = CGRect(x: 16, y: 0, width: NXDevice.width-32, height: self.ctxs.height)
        self.title.textAlignment = .center
        
        self.setup()
        completion?("", self)
    }
}
