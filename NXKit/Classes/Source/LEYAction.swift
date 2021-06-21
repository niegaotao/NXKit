//
//  LEYAction.swift
//  NXFoundation
//
//  Created by firelonely on 2020/4/12.
//

import UIKit

open class LEYAction: LEYItem {
    open var action : String = ""

    public let appearance = LEYApp.Appearance{(_, _) in
        
    }
    
    public let asset = LEYApp.Attribute(completion:{(_, __attribute) in
        __attribute.color = LEYApp.darkGrayColor
    })
    
    public let title = LEYApp.Attribute(completion: {(_, __attribute) in
        __attribute.font = LEYApp.font(16)
        __attribute.textAlignment = .left
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let subtitle = LEYApp.Attribute(completion: {(_, __attribute) in
        __attribute.font = LEYApp.font(13)
        __attribute.color = LEYApp.darkGrayColor
        __attribute.textAlignment = .left
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let access = LEYApp.Attribute(completion: {(_, __attribute) in
        __attribute.font = LEYApp.font(13)
        __attribute.color = LEYApp.darkGrayColor
        __attribute.textAlignment = .right
        __attribute.backgroundColor = UIColor.clear
    })
    
    public let arrow = LEYApp.Attribute { (_, __attribute) in
        __attribute.frame = CGRect(x: 0, y: 0, width: 6, height: 12)
    }
    
    public let separator = LEYApp.Separator{(_,_) in
        
    }
    
    public convenience init(completion:LEYApp.Completion<String, LEYAction>?) {
        self.init()
        completion?("", self)
    }
    
    public convenience init(title:String, value: [String: Any]?, completion:LEYApp.Completion<String, LEYAction>?) {
        self.init()
        self.ctxs.value = value
        self.ctxs.update(LEYActionViewCell.self, "LEYActionViewCell")
        self.ctxs.size = CGSize(width: LEYDevice.width, height: LEYApp.Overlay.size.height)
        
        self.title.value = title
        self.title.frame = CGRect(x: 16, y: 0, width: LEYDevice.width-32, height: self.ctxs.h)
        self.title.textAlignment = .center
        
        self.setup()
        completion?("", self)
    }
}
