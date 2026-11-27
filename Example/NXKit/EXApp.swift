//
//  EXApp.swift
//  NXKit_Example
//
//  Created by 聂高涛 on 2022/3/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import NXKit
import Photos
import UIKit

class EXApp {
    static let center = EXApp()
    static let naviController = NXNavigationController()

    // 获取授权/请求授权入口
    open class func authorization(_: NXKit.Authorize, _ queue: DispatchQueue, _ completion: ((NXKit.AuthorizeState) -> Void)?, _: Bool = true) {
        albumAuthorization(queue, true, completion)
    }

    private class func albumAuthorization(_ queue: DispatchQueue, _ alert: Bool, _ completion: ((NXKit.AuthorizeState) -> Void)?) {
        if #available(iOS 14.0, *) {
            let access = PHAccessLevel.readWrite
            let status = PHPhotoLibrary.authorizationStatus(for: access)
            if status == .authorized || status == .limited {
                queue.async {
                    completion?(.authorized)
                }
            } else if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: access) { substatus in
                    if substatus == .authorized {
                        queue.async {
                            completion?(.authorized)
                        }
                    } else {
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
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                queue.async {
                    completion?(.authorized)
                }
            } else if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization { substatus in
                    if substatus == .authorized {
                        queue.async {
                            completion?(.authorized)
                        }
                    } else {
                        queue.async {
                            completion?(.denied)
                        }

                        if alert {
                            EXApp.description(.album)
                        }
                    }
                }
            } else {
                queue.async {
                    completion?(.denied)
                }
                if alert {
                    EXApp.description(.album)
                }
            }
        }
    }

    open class func description(_: NXKit.Authorize, _: ((_ index: Int) -> Void)? = nil) {
        NXActionView.alert(title: "温馨提示", subtitle: "\(NXKit.name)访问您的相册用户快速选择和保存照片，请打开设置->\(NXKit.name)，开启相册访问权限。", actions: ["好的"], completion: nil)
    }

    open var assets = [NXAsset]()

    func preview(_ assets: [NXAsset], _: Int) {
        self.assets = assets
    }
}
