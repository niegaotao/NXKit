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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = EXToolViewController.Attributes()
        attributes.selectedAppearance.color = UIColor.red

        if true {
            let vc = NXViewController()
            vc.title = "首页"
            attributes.viewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title = "首页"
            item.selected.image = UIImage(named: "index_selected.png")!
            item.unselected.image = UIImage(named: "index_selected.png")!
            attributes.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "工具"
            attributes.viewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title = "工具"
            item.selected.image = UIImage(named: "index_selected.png")!
            item.unselected.image = UIImage(named: "index_selected.png")!
            item.badge.value = 5
            item.badge.type = .dot
            attributes.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "发现"
            attributes.viewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title = "发现"
            item.selected.image = UIImage(named: "index_selected.png")!
            item.unselected.image = UIImage(named: "index_selected.png")!
            item.badge.value = 5
            item.badge.type = .numeric
            attributes.elements.append(item)
        }
        
        if true {
            let vc = NXViewController()
            vc.title = "我的"
            attributes.viewControllers.append(vc)
            
            let item = NXToolView.Element()
            item.title = "我的"
            item.selected.image = UIImage(named: "index_selected.png")!
            item.unselected.image = UIImage(named: "index_selected.png")!
            item.badge.value = 100
            item.badge.type = .numeric
            item.badge.isResetable = true
            attributes.elements.append(item)
        }
        
        //
        self.toolView.separator.isHidden = true
        
        self.toolView.shadow.isHidden = false
        
        self.toolView.highlighted.isHidden = false
        self.toolView.highlighted.frame = CGRect(x: (NXKit.width -  80)/2.0, y: -25, width: 80, height: 50)
        self.toolView.highlighted.cornerRadius = 25
        self.toolView.highlighted.backgroundColor = UIColor.red

        self.toolView.highlighted.image.value = UIImage(named: "index_+.png")
        self.toolView.highlighted.image.frame = CGRect(x: 22, y: 7, width: 36, height: 36)
        self.toolView.highlighted.image.renderingMode = .alwaysTemplate
        self.toolView.highlighted.image.color = .white
        self.toolView.highlighted.targetView.setupEvent(.touchUpInside) { event, value in
            print("点击了中间按钮")
        }
        attributes.index = 0
        
        self.updateSubviews(attributes)
    }
}
