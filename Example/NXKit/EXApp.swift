//
//  EXApp.swift
//  NXKit_Example
//
//  Created by 聂高涛 on 2022/3/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import NXKit
import Photos

class EXApp {
    static let center = EXApp()
    static let naviController = NXNavigationController()
    
    
    //获取授权/请求授权入口
    open class func authorization(_ category: NX.Authorize, _ queue:DispatchQueue, _ completion:((NX.AuthorizeState) -> ())?, _ alert: Bool = true){
        self.albumAuthorization(queue, true, completion)
    }
    
    private class func albumAuthorization(_ queue:DispatchQueue, _ alert:Bool, _ completion:((NX.AuthorizeState) -> ())?){
        if #available(iOS 14.0, *) {
            let access = PHAccessLevel.readWrite
            let status = PHPhotoLibrary.authorizationStatus(for: access)
            if status == .authorized || status == .limited {
                queue.async {
                    completion?(.authorized)
                }
            }
            else if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: access) { (substatus) in
                    if substatus == .authorized {
                        queue.async {
                            completion?(.authorized)
                        }
                    }
                    else {
                        queue.async {
                            completion?(.denied)
                        }

                        if alert {
                            EXApp.description(.album)
                        }
                    }
                }
            }
            
            else {
                queue.async {
                    completion?(.denied)
                }

                if alert {
                    EXApp.description(.album)
                }
            }
        }
        else {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                queue.async {
                    completion?(.authorized)
                }
            }
            else if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization { (substatus) in
                    if substatus == .authorized {
                        queue.async {
                            completion?(.authorized)
                        }
                    }
                    else{
                        queue.async {
                            completion?(.denied)
                        }

                        if alert {
                            EXApp.description(.album)
                        }
                    }
                }
            }
            else{
                queue.async  {
                    completion?(.denied)
                }
                if alert {
                    EXApp.description(.album)
                }
            }
        }
    }
    

    open class func description(_ type: NX.Authorize, _ completion:((_ index:Int) -> ())? = nil){
        NXActionView.alert(title: "温馨提示", subtitle: "\(NX.name)访问您的相册用户快速选择和保存照片，请打开设置->\(NX.name)，开启相册访问权限。", actions: ["好的",], completion: nil)
    }
    
    
    
    
    open var assets = [NXAsset]()
    
    func preview(_ assets: [NXAsset], _ index:Int){
        self.assets = assets
    }
}
