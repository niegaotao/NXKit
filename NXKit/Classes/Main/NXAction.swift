//
//  NXAction.swift
//  NXKit
//
//  Created by firelonely on 2020/4/12.
//

import UIKit

open class NXAction: NXItem {
    open var action : String = ""

    public let appearance = NX.Appearance{(_, _) in
        
    }
    
    public let asset = NX.Attribute(completion:{(_, __attribute) in
        __attribute.color = NX.darkGrayColor
    })
    
    public let title = NX.Attribute(completion: {(_, __attribute) in
        __attribute.font = NX.font(16)
        __attribute.textAlignment = .left
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let subtitle = NX.Attribute(completion: {(_, __attribute) in
        __attribute.font = NX.font(13)
        __attribute.color = NX.darkGrayColor
        __attribute.textAlignment = .left
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let access = NX.Attribute(completion: {(_, __attribute) in
        __attribute.font = NX.font(13)
        __attribute.color = NX.darkGrayColor
        __attribute.textAlignment = .right
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let arrow = NX.Attribute { (_, __attribute) in
        __attribute.frame = CGRect(x: 0, y: 0, width: 6, height: 12)
    }
    
    public let separator = NX.Separator{(_,_) in
        
    }
    
    public convenience init(completion:NX.Completion<String, NXAction>?) {
        self.init()
        completion?("", self)
    }
    
    public convenience init(title:String, value: [String: Any]?, completion:NX.Completion<String, NXAction>?) {
        self.init()
        self.ctxs.value = value
        self.ctxs.update(NXActionViewCell.self, "NXActionViewCell")
        self.ctxs.size = CGSize(width: NXDevice.width, height: NX.Overlay.size.height)
        
        self.title.value = title
        self.title.frame = CGRect(x: 16, y: 0, width: NXDevice.width-32, height: self.ctxs.h)
        self.title.textAlignment = .center
        
        self.setup()
        completion?("", self)
    }
}
