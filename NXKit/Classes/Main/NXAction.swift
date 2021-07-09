//
//  NXAction.swift
//  NXKit
//
//  Created by firelonely on 2020/4/12.
//

import UIKit

open class NXAction: NXItem {
    open var action : String = ""

    public let appearance = NXApp.Appearance{(_, _) in
        
    }
    
    public let asset = NXApp.Attribute(completion:{(_, __attribute) in
        __attribute.color = NXApp.darkGrayColor
    })
    
    public let title = NXApp.Attribute(completion: {(_, __attribute) in
        __attribute.font = NXApp.font(16)
        __attribute.textAlignment = .left
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let subtitle = NXApp.Attribute(completion: {(_, __attribute) in
        __attribute.font = NXApp.font(13)
        __attribute.color = NXApp.darkGrayColor
        __attribute.textAlignment = .left
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let access = NXApp.Attribute(completion: {(_, __attribute) in
        __attribute.font = NXApp.font(13)
        __attribute.color = NXApp.darkGrayColor
        __attribute.textAlignment = .right
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let arrow = NXApp.Attribute { (_, __attribute) in
        __attribute.frame = CGRect(x: 0, y: 0, width: 6, height: 12)
    }
    
    public let separator = NXApp.Separator{(_,_) in
        
    }
    
    public convenience init(completion:NXApp.Completion<String, NXAction>?) {
        self.init()
        completion?("", self)
    }
    
    public convenience init(title:String, value: [String: Any]?, completion:NXApp.Completion<String, NXAction>?) {
        self.init()
        self.ctxs.value = value
        self.ctxs.update(NXActionViewCell.self, "NXActionViewCell")
        self.ctxs.size = CGSize(width: NXDevice.width, height: NXApp.Overlay.size.height)
        
        self.title.value = title
        self.title.frame = CGRect(x: 16, y: 0, width: NXDevice.width-32, height: self.ctxs.h)
        self.title.textAlignment = .center
        
        self.setup()
        completion?("", self)
    }
}
