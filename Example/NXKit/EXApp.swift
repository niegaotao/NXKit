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
import ImageViewer




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
        let __index = min(max(index, 0), self.assets.count-1)
        let __viewController = GalleryViewController(startIndex: 0, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: nil, configuration: [.seeAllCloseButtonMode(.none), .deleteButtonMode(.none), .headerViewLayout(HeaderLayout.center(13))])
        
        if true {
            let headerView = NXLCRView<UIView,UILabel, UIButton>(frame: CGRect(x: 16, y: NX.topOffset-44, width: NX.width-32, height: 44))
            headerView.centerView.frame = CGRect(x: headerView.width/3.0, y: 0, width: headerView.width/3.0, height: headerView.height)
            headerView.centerView.textAlignment = .center
            headerView.centerView.textColor = UIColor.white
            headerView.centerView.font = NX.font(17)
            headerView.centerView.text = "\(__index+1) / \(self.assets.count)"
            __viewController.headerView = headerView
        }
        
        __viewController.landedPageAtIndexCompletion = {[weak __viewController] index in
            if let __view = __viewController?.headerView as? NXLCRView<UIView,UILabel, UIButton> {
                __view.centerView.text = "\(index+1) / \(EXApp.center.assets.count)"
            }
        }

        __viewController.modalPresentationStyle = .overFullScreen
        EXApp.naviController.visibleViewController?.present(__viewController, animated: true, completion: nil)
    }
}


extension EXApp: GalleryItemsDataSource {
    public func itemCount() -> Int {
        return self.assets.count
    }
            
    public func provideGalleryItem(_ index: Int) -> GalleryItem {
        let asset = self.assets[index]
        if asset.mediaType == .image {
            return GalleryItem.image { completion in
                completion(asset.image)
            }
        }
        else if asset.mediaType == .video {
            return GalleryItem.video(fetchPreviewImageBlock: { completion in
                completion(asset.image)
            }, videoURL: URL(string: "https://baidu.com")!)
        }
        return GalleryItem.image { completion in
            completion(asset.image)
        }
    }
}
                                                   
      
extension EXApp: GalleryItemsDelegate {
    public func removeGalleryItem(at index: Int){
        
    }
}
