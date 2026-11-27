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

    override func initialize() {
        super.initialize()
        
        self.ctxs.statusBarStyle = .none
        
        if true {
            let vc = NXViewController()
            vc.title = "首页"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.name.selected = "首页"
            item.name.unselected = "首页"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.color.selected = UIColor.red
            self.toolView.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "工具"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.name.selected = "工具"
            item.name.unselected = "工具"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.badge.value = 5
            item.badge.isNumeric = false
            self.toolView.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "发现"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.name.selected = "发现"
            item.name.unselected = "发现"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.badge.value = 5
            item.badge.isNumeric = true
            self.toolView.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "我的"
            self.subviewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.name.selected = "我的"
            item.name.unselected = "我的"
            item.image.selected = UIImage(named: "index_selected.png")!
            item.image.unselected = UIImage(named: "index_selected.png")!
            item.color.selected = UIColor.red
            item.badge.value = 100
            item.badge.isNumeric = true
            item.badge.isResetable = true
            self.toolView.elements.append(item)
        }
        
        //
        self.toolView.separator.isHidden = true
        
        self.toolView.shadow.isHidden = false
        
        self.toolView.highlighted.isHidden = false
        self.toolView.highlighted.frame = CGRect(x: (NX.width -  80)/2.0, y: -25, width: 80, height: 50)
        self.toolView.highlighted.cornerRadius = 25
        self.toolView.highlighted.backgroundColor = UIColor.red

        self.toolView.highlighted.image.value = UIImage(named: "index_+.png")
        self.toolView.highlighted.image.frame = CGRect(x: 22, y: 7, width: 36, height: 36)
        self.toolView.highlighted.image.renderingMode = .alwaysTemplate
        self.toolView.highlighted.image.color = .white
        self.toolView.highlighted.targetView.setupEvent(.touchUpInside) { event, value in
            print("点击了中间按钮")
        }
        self.index = 0
    }
    
    override func didSelect(fromValue:Int, toValue:Int) {
        print("index:\(index)")
    }
}
