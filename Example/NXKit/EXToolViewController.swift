//
//  EXToolViewController.swift
//  NXKit_Example
//
//  Created by 聂高涛 on 2022/9/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import NXKit

class EXToolViewController: NXToolViewController {

    override func setup() {
        super.setup()
        
        self.ctxs.statusBarStyle = .none
        
        if true {
            let vc = NXViewController()
            vc.title = "首页"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title.selected = "首页"
            item.title.unselected = "首页"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.color.selected = NX.darkBlackColor
            self.toolView.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "工具"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title.selected = "工具"
            item.title.unselected = "工具"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.color.selected = NX.darkBlackColor
            self.toolView.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "发现"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title.selected = "发现"
            item.title.unselected = "发现"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.color.selected = NX.darkBlackColor
            self.toolView.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "我的"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title.selected = "我的"
            item.title.unselected = "我的"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.color.selected = NX.darkBlackColor
            self.toolView.elements.append(item)
        }
        
        //
        self.toolView.separator.isHidden = true
        self.toolView.shadow.isHidden = false
        self.toolView.centerView.isHidden = false
        self.toolView.centerView.image = UIImage(named: "index_+.png")
        self.toolView.centerView.frame = CGRect(x: (NX.width -  80)/2.0, y: -10, width: 80, height: 50)
        self.toolView.centerView.backgroundColor = NX.mainColor
        self.toolView.centerView.cornerRadius = 25
        self.index = 0
    }
    
    override func didSelect(fromValue:Int, toValue:Int) {
        print("index:\(index)")
    }
}
