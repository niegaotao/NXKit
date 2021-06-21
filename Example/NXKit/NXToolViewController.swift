//
//  NXToolViewController.swift
//  LEYFoundation_Example
//
//  Created by niegaotao on 2020/5/16.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NXKit


class NXToolViewController : LEYToolViewController {
    override func setup() {
        super.setup()
        
        var tabs = [[String:Any]]()
        tabs.append(["name":"相册","selected":"rrxc_app_album_selected.png","unselected":"rrxc_app_album_unselected.png","vc":LEYViewController()])
        tabs.append(["name":"工具","selected":"rrxc_app_toolbox_selected.png","unselected":"rrxc_app_toolbox_unselected.png","vc":LEYViewController()])
        tabs.append(["name":"消息","selected":"rrxc_app_team_selected.png","unselected":"rrxc_app_team_unselected.png","vc":LEYViewController()])
        tabs.append(["name":"我的","selected":"rrxc_app_owner_selected.png","unselected":"rrxc_app_owner_unselected.png","vc":LEYViewController()])
        
        self.elements.removeAll()
        self.subviewControllers.removeAll()
        for (index, tab) in tabs.enumerated() {
            let element = LEYToolView.Element()
            element.title.selected = tab["name"] as? String ?? ""
            element.title.unselected = tab["name"] as? String ?? ""
            element.color.selected = LEYApp.color(0x5C5B60)
            element.color.unselected = LEYApp.color(0x5C5B60)
            element.image.selected = UIImage(named: tab["selected"] as? String ?? "")
            element.image.unselected = UIImage(named: tab["unselected"] as? String ?? "")
            if index == 0 {
                element.attachment.isValue = false
                element.attachment.value = 1
            }
            else if index == 1 {
                element.attachment.value = 5
            }
            else if index == 2 {
                element.attachment.value = 59
                element.isSelectable = false
            }
            else if index == 3 {
                element.attachment.value = 102
            }
            self.elements.append(element)
            
            if let vc = tab["vc"] as? LEYViewController {
                vc.title = String(index)
                self.subviewControllers.append(vc)
            }
        }
        self.index = 0
        
        self.toolView.wrapped.separator.isHidden = true
        self.toolView.wrapped.shadow.isHidden = false
        
        
        self.toolView.wrapped.center.isHidden = false
        self.toolView.wrapped.center.frame = CGRect(x: (LEYDevice.width-52)/2.0, y: 8, width: 52, height: 36)
        self.toolView.wrapped.center.image = UIImage(named: "rrxc_+.png")
        self.toolView.centerView.setupEvents([.touchUpInside]) { (e, v) in
            
        }
    }
    
    override func didSelectViewController(at idx: Int, animated: Bool) {
        super.didSelectViewController(at: idx, animated: animated)
        
        let e = self.elements[idx]
        if e.isSelectable == false {
            LEYApp.log { return "这个按钮不能点击啊"}
        }
    }
    
    //连续双击
    override open func didReselectElement(at index:Int){
        LEYApp.log { return "__index=\(index)"}
        if let tvc = self.selectedViewController as? LEYTableViewController {
            guard let tv = tvc.tableView, tv.scrollsToTop else {
                return
            }
            //tv.scrollToTop()
        }
        else if let cvc = self.selectedViewController as? LEYCollectionViewController {
            guard let cv = cvc.collectionView, cv.scrollsToTop else {
                return
            }
            //cv.scrollToTop()
        }
        else if let swipe = self.selectedViewController as? LEYContainerController {
            if let tvc = swipe.selectedViewController as? LEYTableViewController {
                guard let tv = tvc.tableView, tv.scrollsToTop else {
                    return
                }
                //tv.scrollToTop()
            }
            else if let cvc = swipe.selectedViewController as? LEYCollectionViewController {
                guard let cv = cvc.collectionView, cv.scrollsToTop else {
                    return
                }
                //cv.scrollToTop()
            }
        }
    }
}

