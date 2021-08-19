//
//  NXDockerViewController.swift
//  NXFoundation_Example
//
//  Created by niegaotao on 2019/3/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import NXKit

class NXAppViewController: NXCollectionViewController {
    
    var values = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.title = "NXApp"
        self.setupSubviews()
        self.updateSubviews("", nil)
        
        NXTester.center().debug()
    }
    
    override func setupSubviews() {
        self.naviView.forwardBar = NXNaviView.Bar.forward(image: nil, title: "设置", completion: { (bar) in
            self.dispose("NXActionView", nil)
        })
        self.collectionView?.register(NXActionViewCell.self, forCellWithReuseIdentifier: "NXActionViewCell")
    }
    
    override func updateSubviews(_ action: String, _ entities: [String : Any]?) {
        
        NX.print("------\(self.ctxs.index)");
        
        self.collectionWrapper.removeAll()
        
        let section = NXSection()
        self.collectionWrapper.append(section)
        
        NX.Overlay.size.height = 52
        
        self.values.removeAll()
        
        self.values.append(["access":"access","title":"视图控制器",
                            "body":[
                                ["access":"NXViewController","title":"NXViewController"],
                                ["access":"NXWebViewController","title":"NXWebViewController"],
                                ["access":"NXSubtoolViewController","title":"NXSubtoolViewController"],
                                ["access":"NXSubswipeViewController","title":"NXSubswipeViewController"]
                            ]])
        
        self.values.append(["access":"access","title":"弹框",
                            "body":[["access":"NXActionView","title":"NXActionView"],
                                    ["access":"NXPopupView","title":"NXPopupView"],
                                    ["access":"NXPopupView2","title":"NXPopupView2"],
                                    ["access":"NXPopupView3","title":"NXPopupView3"]
                            ]])
        
        self.values.append(["access":"access","title":"选图",
                            "body":[["access":"NXAsset_UIImage1","title":"NXAsset_UIImage1"],
                                    ["access":"NXAsset_UIImage1-9","title":"NXAsset_UIImage1-9"],
                                    ["access":"NXAsset_UIVideo1-1","title":"NXAsset_UIVideo1-1"],
                                    ["access":"NXAsset_UIVideo1-1+UIImage1-20","title":"NXAsset_UIVideo1-1+UIImage1-20"],
                                    ["access":"NXAsset_UIVideo1-9||UIImage1-9","title":"NXAsset_UIVideo1-9||UIImage1-9"],
                            ]])
        
        for (_, value) in values.enumerated() {
            
            if let access = value["access"] as? String, access == "access" {
                let action = NXAction(title: value["title"] as? String ?? "",value: value, completion: nil)
                action.ctxs.size = CGSize(width: NXDevice.width, height: 40)
                action.title.frame = CGRect(x: 16, y: 0, width: NXDevice.width-32, height: action.ctxs.height)
                action.title.isHidden = false
                action.title.textAlignment = .left
                action.title.color = NX.lightBlackColor
                action.title.font = NX.font(14)
                
                action.separator.ats = []
                action.arrow.isHidden = true
                action.arrow.isHidden = true
                
                action.appearance.isHighlighted = false
                action.appearance.backgroundColor = NX.viewBackgroundColor
                section.append(action)
            }
            
            if let body = value["body"] as? [[String:Any]], body.count > 0 {
                for (index, subvalue) in body.enumerated() {
                    let action = NXAction(title: subvalue["title"] as? String ?? "",value: subvalue, completion: nil)
                    action.title.isHidden = false
                    action.title.textAlignment = .left
                    action.separator.ats = .maxY
                    if index == body.count - 1 {
                        action.separator.ats = []
                    }
                    action.separator.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                    action.arrow.image = NX.image(named: "uiapp_arrow.png")
                    action.arrow.frame = CGRect(x: action.ctxs.width-16-6, y: (action.ctxs.height-12)/2.0, width: 6, height: 12)
                    action.arrow.isHidden = false
                    
                    section.append(action)
                }
            }
        }
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let action = self.collectionWrapper[indexPath] else {
            return
        }
        guard let access = action.ctxs.value?["access"] as? String else {
            return
        }
        
        self.dispose(access, nil)
    }
    
    override func dispose(_ action: String, _ value: Any?, _ completion: NX.Completion<String, Any?>? = nil) {
        if action == "NXViewController" {
            let vc = NXViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if action == "NXWebViewController" {
            let vc = NXWebViewController()
            vc.url = "https://www.baidu.com"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if action == "NXSubtoolViewController" {
            let vc = NXSubtoolViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if action == "NXSubswipeViewController" {
            let vc = NXSubswipeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if ["NXActionView", "NXPopupView", "NXPopupView2", "NXPopupView3"].contains(action) {
            var strings = ["设置", "删除", "我再想想"];
            if action == "NXPopupView" {
                strings = ["确定"];
            }
            else if action == "NXPopupView2" {
                strings = ["删除", "我再想想"];
            }
            
            let actions = strings.map { (a) -> NXAction in
                return NXAction(title:a, value: nil, completion: { (_, __action:NXAction) in
                    __action.asset.isHidden = true
                    __action.subtitle.isHidden = true
                    if(__action.title.value == "删除"){
                        __action.title.color = UIColor.red
                    }
                })
            }
            if action == "NXActionView" {
                NXActionView.action(actions: actions,
                                    header: (.components(true, true, true, false),"你好呀"),
                                    footer: (.components(false, true, false), "取消"),
                                    completion: { (a, index) in
                                        
                                        let vc = NXWebViewController()
                                        vc.url = "http://www.bao66.cn/web/"
                                        self.navigationController?.pushViewController(vc, animated: true)
                })
            }
            else {
                NXActionView.alert(title: "温馨提示", subtitle: "我们生活真的很幸福，珍惜现在报效祖国是我们肩负的使命", actions: actions, completion: nil)
            }
        }
        else if action == "NXAsset_UIImage1" {
            guard let nav = self.navigationController as? NXNavigationController else {
                return
            }
            
            NXAsset.openAlbum(minOfAssets: 1,
                                         maxOfAssets: 1,
                                         image: (minOfAssets:1, maxOfAssets:1, isIndex:true),
                                         video: (minOfAssets:0, maxOfAssets:0, isIndex:false),
                                         isMixable: false,
                                         isAutoclosed:true,
                                         mediaType: .image,
                                         selectedIdentifiers:[],
                                         usedIdentifiers: [],
                                         outputResize: CGSize(width: 1920, height: 1920),
                                         outputResizeBy: NXAsset.Resize.area.rawValue,
                                         outputUIImage: true,
                                         imageClips: [NXAsset.Clip(isResizable: true, width: 1.0, height: 2.0, isHidden: false), NXAsset.Clip(isResizable: true, width: 1.0, height: 1.0, isHidden: false)],
                                         videoClipsAllowed: false,
                                         videoClipsDuration: 15.0,
                                         videoFileExtensions: [".mp4", ".mov"],
                                         footer: (false, false, false),
                                         operation: .push,
                                         naviController: nav,
                                         isOpenable: true,
                                         isCloseable: true,
                                         isAnimated:true) { (_,output) in
                
            }
        }
        else if action == "NXAsset_UIImage1-9" {
            guard let nav = self.navigationController as? NXNavigationController else {
                return
            }
            
            NXAsset.openAlbum(minOfAssets: 1,
                                         maxOfAssets: 9,
                                         image: (minOfAssets:1, maxOfAssets:9, isIndex:true),
                                         video: (minOfAssets:0, maxOfAssets:0, isIndex:false),
                                         isMixable: false,
                                         isAutoclosed:true,
                                         mediaType: .unknown,
                                         selectedIdentifiers:[],
                                         usedIdentifiers: [],
                                         outputResize: CGSize(width: 1920, height: 1920),
                                         outputResizeBy: NXAsset.Resize.area.rawValue,
                                         outputUIImage: true,
                                         imageClips: [],
                                         videoClipsAllowed: false,
                                         videoClipsDuration: 15.0,
                                         videoFileExtensions: [".mp4", ".mov"],
                                         footer: (false, false, false),
                                         operation: .push,
                                         naviController: nav,
                                         isOpenable: true,
                                         isCloseable: true,
                                         isAnimated:true) { (_,output) in
                
            }
        }
        else if action == "NXAsset_UIVideo1-1" {
            guard let nav = self.navigationController as? NXNavigationController else {
                return
            }
            
            NXAsset.openAlbum(minOfAssets: 1,
                                         maxOfAssets: 1,
                                         image: (minOfAssets:0, maxOfAssets:0, isIndex:true),
                                         video: (minOfAssets:1, maxOfAssets:1, isIndex:false),
                                         isMixable: false,
                                         isAutoclosed:true,
                                         mediaType: .unknown,
                                         selectedIdentifiers: [],
                                         usedIdentifiers: [],
                                         outputResize: CGSize(width: 1920, height: 1920),
                                         outputResizeBy: NXAsset.Resize.area.rawValue,
                                         outputUIImage: true,
                                         imageClips: [],
                                         videoClipsAllowed: false,
                                         videoClipsDuration: 15.0,
                                         videoFileExtensions: [".mp4", ".mov"],
                                         footer: (false, false, false),
                                         operation: .push,
                                         naviController: nav,
                                         isOpenable: true,
                                         isCloseable: true,
                                         isAnimated:true) { (_,output) in
                
            }
        }
        else if action == "NXAsset_UIVideo1-1+UIImage1-20" {
            guard let nav = self.navigationController as? NXNavigationController else {
                return
            }
            
            NXAsset.openAlbum(minOfAssets: 1,
                                         maxOfAssets: 21,
                                         image: (minOfAssets:1, maxOfAssets:20, isIndex:true),
                                         video: (minOfAssets:1, maxOfAssets:1, isIndex:false),
                                         isMixable: false,
                                         isAutoclosed:false,
                                         mediaType: .unknown,
                                         selectedIdentifiers:["1806C4B8-02A3-4F9F-87E8-D49BA0481951/L0/001", "83FD4EA1-285D-4812-9361-D50F78DD0010/L0/001", "5BAA18CB-2F60-4B27-8DEE-D4229E527424/L0/001", "5EBF50DF-7D2C-4E7F-9BA3-749B0B95FF58/L0/001"],
                                         usedIdentifiers: [],
                                         outputResize: CGSize(width: 1920, height: 1920),
                                         outputResizeBy: NXAsset.Resize.area.rawValue,
                                         outputUIImage: true,
                                         imageClips: [],
                                         videoClipsAllowed: false,
                                         videoClipsDuration: 15.0,
                                         videoFileExtensions: [".mp4", ".mov"],
                                         footer: (false, false, false),
                                         operation: .push,
                                         naviController: nav,
                                         isOpenable: true,
                                         isCloseable: true,
                                         isAnimated:true) { (_,output) in
                
            }
        }
        else if action == "NXAsset_UIVideo1-9||UIImage1-9" {
            guard let nav = self.navigationController as? NXNavigationController else {
                return
            }
            
            NXAsset.openAlbum(minOfAssets: 1,
                                         maxOfAssets: 9,
                                         image: (minOfAssets:1, maxOfAssets:9, isIndex:true),
                                         video: (minOfAssets:1, maxOfAssets:9, isIndex:false),
                                         isMixable: true,
                                         isAutoclosed:true,
                                         mediaType: .unknown,
                                         selectedIdentifiers:["1806C4B8-02A3-4F9F-87E8-D49BA0481951/L0/001", "83FD4EA1-285D-4812-9361-D50F78DD0010/L0/001", "5BAA18CB-2F60-4B27-8DEE-D4229E527424/L0/001", "5EBF50DF-7D2C-4E7F-9BA3-749B0B95FF58/L0/001"],
                                         usedIdentifiers: [],
                                         outputResize: CGSize(width: 1920, height: 1920),
                                         outputResizeBy: NXAsset.Resize.area.rawValue,
                                         outputUIImage: true,
                                         imageClips: [],
                                         videoClipsAllowed: false,
                                         videoClipsDuration: 15.0,
                                         videoFileExtensions: [".mp4", ".mov"],
                                         footer: (false, false, false),
                                         operation: .push,
                                         naviController: nav,
                                         isOpenable: true,
                                         isCloseable: true,
                                         isAnimated:true) { (_,output) in
                
            }
        }
    }
}

class NXSubtoolViewController : NXToolViewController {
    override func setup() {
        super.setup()
        
        var tabs = [[String:Any]]()
        tabs.append(["name":"相册","selected":"rrxc_app_album_selected.png","unselected":"rrxc_app_album_unselected.png","vc":NXViewController()])
        tabs.append(["name":"工具","selected":"rrxc_app_toolbox_selected.png","unselected":"rrxc_app_toolbox_unselected.png","vc":NXViewController()])
        tabs.append(["name":"消息","selected":"rrxc_app_team_selected.png","unselected":"rrxc_app_team_unselected.png","vc":NXViewController()])
        tabs.append(["name":"我的","selected":"rrxc_app_owner_selected.png","unselected":"rrxc_app_owner_unselected.png","vc":NXViewController()])
        
        self.elements.removeAll()
        self.subviewControllers.removeAll()
        for (index, tab) in tabs.enumerated() {
            let element = NXToolView.Element()
            element.title.selected = tab["name"] as? String ?? ""
            element.title.unselected = tab["name"] as? String ?? ""
            element.color.selected = NX.color(0x5C5B60)
            element.color.unselected = NX.color(0x5C5B60)
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
            
            if let vc = tab["vc"] as? NXViewController {
                vc.title = String(index)
                self.subviewControllers.append(vc)
            }
        }
        self.index = 0
        
        self.toolView.wrapped.separator.isHidden = true
        self.toolView.wrapped.layer.isHidden = false
        
        
        self.toolView.wrapped.center.isHidden = false
        self.toolView.wrapped.center.frame = CGRect(x: (NXDevice.width-52)/2.0, y: 8, width: 52, height: 36)
        self.toolView.wrapped.center.image = UIImage(named: "rrxc_+.png")
        self.toolView.centerView.setupEvents([.touchUpInside]) { (e, v) in
            
        }
    }
    
    override func didSelectViewController(at idx: Int, animated: Bool) {
        super.didSelectViewController(at: idx, animated: animated)
        
        let e = self.elements[idx]
        if e.isSelectable == false {
            NX.log { return "这个按钮不能点击啊"}
        }
    }
    
    //连续双击
    override open func didReselectElement(at index:Int){
        NX.log { return "__index=\(index)"}
        if let tvc = self.selectedViewController as? NXTableViewController {
            guard let tv = tvc.tableView, tv.scrollsToTop else {
                return
            }
            //tv.scrollToTop()
        }
        else if let cvc = self.selectedViewController as? NXCollectionViewController {
            guard let cv = cvc.collectionView, cv.scrollsToTop else {
                return
            }
            //cv.scrollToTop()
        }
        else if let swipe = self.selectedViewController as? NXContainerController {
            if let tvc = swipe.selectedViewController as? NXTableViewController {
                guard let tv = tvc.tableView, tv.scrollsToTop else {
                    return
                }
                //tv.scrollToTop()
            }
            else if let cvc = swipe.selectedViewController as? NXCollectionViewController {
                guard let cv = cvc.collectionView, cv.scrollsToTop else {
                    return
                }
                //cv.scrollToTop()
            }
        }
    }
}


class NXSubswipeViewController: NXSwipeViewController {
    
    
    class Child : NXViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if self.ctxs.isWrapped {
                self.naviView.isHidden = true
                self.contentView.frame = self.view.bounds
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            NX.log { return "viewWillAppear:\(self)"}
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NX.log { return "viewWillDisappear:\(self)"}
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.naviView.title = "NXSubswipeViewController"
        
        self.setupSubviews([Child(),Child(),Child(),Child(),Child(),Child(),Child()], elements: ["精华精华","动态","收藏","精华精华","动态","收藏","精华精华"])
    }
    
}





