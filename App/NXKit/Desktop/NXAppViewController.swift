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
        
//        NX.log { return "size=\(UIScreen.main.bounds.size), scale=\(UIScreen.main.scale)______insets=\(NXDevice.insets)"}
//        DispatchQueue.main.after(10) {
//            NX.log { return "______insets=\(NXDevice.insets)"}
//        }
//        NX.Overlay.showToast = {(message:String, ats:NX.Ats,superview:UIView?) in
//            NX.log { return "__________\(message)"}
//        }
        
        self.naviView.title = "NXApp"
        self.setupSubviews()
        self.updateSubviews("", nil)
        
        //NXARC.test()
        NXARC.testPtr()
        //NXARC.center().testLock();
        //NXARC.center().testStringCopy();
        //NXARC.center().testDictionaryCopy();
        //NXARC.center().testArrayCopy();
        //NXARC.center().signal();
        //NXARC.center().testClass();
        //NXARC.center().testKVO();
        //NXMRC.center().testZombie();
        //NXARC.center().dispatchQueue();
        //NXARC.center().testBuffer()
    }
    
    override func setupSubviews() {
        self.naviView.forwardBar = NXNaviView.Bar.forward(image: nil, title: "设置", completion: { (bar) in
            self.dispose("NXActionView", nil)
        })
        self.collectionView?.register(NXActionViewCell.self, forCellWithReuseIdentifier: "NXActionViewCell")
    }
    
    override func updateSubviews(_ action: String, _ entities: [String : Any]?) {
        self.collectionWrapper.removeAll()
        
        let section = NXSection()
        self.collectionWrapper.append(section)
        
        NX.Overlay.size.height = 52
        
        self.values.removeAll()
        self.values.append(["accessKey":"NXToolViewController","title":"NXToolViewController"])
        self.values.append(["accessKey":"NXMasterViewController","title":"NXMasterViewController"])
        self.values.append(["accessKey":"NXWebViewController","title":"NXWebViewController"])
        self.values.append(["accessKey":"NXActionView","title":"NXActionView"])
        self.values.append(["accessKey":"NXPopupView","title":"NXPopupView"])
        self.values.append(["accessKey":"NXPopupView2","title":"NXPopupView2"])
        self.values.append(["accessKey":"NXPopupView3","title":"NXPopupView3"])
        self.values.append(["accessKey":"NXAsset_UIImage1","title":"NXAsset_UIImage1"])
        self.values.append(["accessKey":"NXAsset_UIImage1-9","title":"NXAsset_UIImage1-9"])
        self.values.append(["accessKey":"NXAsset_UIVideo1-1","title":"NXAsset_UIVideo1-1"])
        self.values.append(["accessKey":"NXAsset_UIVideo1-1+UIImage1-20","title":"NXAsset_UIVideo1-1+UIImage1-20"])
        self.values.append(["accessKey":"NXAsset_UIVideo1-9||UIImage1-9","title":"NXAsset_UIVideo1-9||UIImage1-9"])
        self.values.append(["accessKey":"NXViewController","title":"NXViewController"])

        for (_, subvalue) in values.enumerated() {
            let action = NXAction(title: subvalue["title"] as? String ?? "",value: subvalue, completion: nil)
            action.title.isHidden = false
            action.title.textAlignment = .left
            action.separator.ats = .maxY
            action.separator.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            action.arrow.image = NX.image(named: "uiapp_arrow.png")
            action.arrow.frame = CGRect(x: action.ctxs.width-16-6, y: (action.ctxs.height-12)/2.0, width: 6, height: 12)
            action.arrow.isHidden = false
            section.append(action)
        }
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let action = self.collectionWrapper[indexPath] else {
            return
        }
        guard let accessKey = action.ctxs.value?["accessKey"] as? String else {
            return
        }
        
        self.dispose(accessKey, nil)
    }
    
    override func dispose(_ action: String, _ value: Any?, _ completion: NX.Completion<String, Any?>? = nil) {
        if action == "NXToolViewController" {
            let vc = NXSubdesktopViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if action == "NXMasterViewController" {
            let vc = NXMasterViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if action == "NXWebViewController" {
            let vc = NXWebViewController()
            //vc.url = "http://ghost.yyshouyou.net/fxdx41"
            vc.url = "https://www.baidu.com"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if action == "NXActionView" {
            let actions = [["action":"","name":"滤镜·特效"],
                           ["action":"","name":"插入"],
                           ["action":"","name":"更换"],
                           ["action":"","name":"反转"]]
            let options = actions.map { (a) -> NXAction in
                return NXAction(title:a["name"] ?? "--", value: a, completion: { (_, __action:NXAction) in
                    __action.asset.isHidden = true
                    __action.subtitle.isHidden = true
                })
            }
            NXActionView.action(style: NXActionView.Key.Footer.action.rawValue,
                                options: options,
                                header: (.components(true, true, true, false),"你好呀"),
                                footer: (.components(false, true, false), "取消"),
                                completion: { (a, index) in
                                    
                                    let vc = NXWebViewController()
                                    vc.url = "http://www.bao66.cn/web/"
                                    self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        else if action == "NXPopupView" {
            NXActionView.alert(title: "温馨提示", subtitle: "我们生活真的很幸福，珍惜现在报效祖国是我们肩负的使命", options: ["我知道了"], completion: nil)
        }
        else if action == "NXPopupView2" {
            NXActionView.alert(title: "温馨提示", subtitle: "我们生活真的很幸福，珍惜现在报效祖国是我们肩负的使命", options: ["我知道了","好的"], completion: nil)
        }
        else if action == "NXPopupView3" {
            NXActionView.alert(title: "温馨提示", subtitle: "我们生活真的很幸福，珍惜现在报效祖国是我们肩负的使命", options: ["我知道了","好的","是的"], completion: nil)
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
        else if action == "NXViewController" {
            let vc = NXViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class NXSubdesktopViewController : NXToolViewController {
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


class NXMasterViewController: NXSwipeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.swipeView.wrapped.isEqually = true
//        self.swipeView.wrapped.color.selected = UIColor.red
//        self.swipeView.wrapped.font.selected = NX.font(18, true)
//        self.swipeView.wrapped.maximumOfComponents = 4.0
        self.setupSubviews([NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController()], elements: ["精华精华","动态","收藏","精华精华","动态","收藏","精华精华"])
    }
}

class NXMasterSubviewController : NXViewController {
    
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


