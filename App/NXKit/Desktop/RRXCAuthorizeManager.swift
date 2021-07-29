//
//  RRXCAuthorizeManager.swift
//  rrxc
//
//  Created by niegaotao on 2018/5/11.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import NXKit

extension RRXCAuthorizeManager {
    open class Popup {
        static public var album :(title:String,subtitle:String, content:String) = ("权限不足","无法访问照片，请按以下提示设置","请在iPhone-设置(下滑找到)-人人相册-照片，设置为“读取和写入”后，即可使用、选择、保存照片啦～")
        static public var camera :(title:String,subtitle:String, content:String) = ("权限不足","无法访问相机，请按以下提示设置","请在iPhone-设置(下滑找到)-人人相册-相机，设置为打开后，即可使用相机拍摄照片和视频啦～")
        static public var apns :(title:String,subtitle:String, content:String) = ("","","")
        static public var network :(title:String,subtitle:String, content:String) = ("无法连接","网络错误,或未授权网络连接","如果网络不好请检查网络或稍后再试。如未授权网络连接请在人人相册-无线数据，设置为“WLAN与蜂窝移动网”后，再试试看哦")
        static public var microphone :(title:String,subtitle:String, content:String) = ("权限不足","无法使用麦克风，请按以下提示设置","请在iPhone-设置(下滑找到)-人人相册-麦克风，设置为打开后，即可使用麦克风录音啦～")
    }
}

open class RRXCAuthorizeManager {
    //获取授权/请求授权入口
    open class func authorization(_ type: NX.AuthorizeType, _ queue:DispatchQueue, _ completion:((NX.AuthorizeState) -> ())?, _ alert: Bool = true){
        if type == NX.AuthorizeType.album {
            self.albumAuthorization(queue, alert, completion)
        }
        else if type == NX.AuthorizeType.camera {
            self.cameraAuthorization(queue, alert, completion)
        }
        else if type == NX.AuthorizeType.microphone {
            self.microphoneAuthorization(queue, alert, completion)
        }
        else if type == NX.AuthorizeType.apns {
            self.apnsAuthorization(queue, alert, completion)
        }
        else if type == NX.AuthorizeType.network {
            self.networkAuthorization(queue, alert,  completion)
        }
    }
    
    
    private class func albumAuthorization(_ queue:DispatchQueue, _ alert:Bool, _ completion:((NX.AuthorizeState) -> ())?){
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
                        RRXCAuthorizeManager.authorizationViewDisplay(.album)
                    }
                }
            }
        }
        else{
            queue.async  {
                completion?(.denied)
            }
            if alert {
                RRXCAuthorizeManager.authorizationViewDisplay(.album)
            }
        }
    }
    
    private class func cameraAuthorization(_ queue:DispatchQueue, _ alert: Bool, _ completion:((NX.AuthorizeState) -> ())?){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status ==  .authorized{
            queue.async {
                completion?(.authorized)
            }
        }
        else if status == .notDetermined{
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    queue.async {
                        completion?(.authorized)
                    }
                }
                else{
                    queue.async {
                        completion?(.denied)
                    }
                    RRXCAuthorizeManager.authorizationViewDisplay(.camera)
                }
            }
        }
        else{
            queue.async {
                completion?(.denied)
            }
            RRXCAuthorizeManager.authorizationViewDisplay(.camera)
        }
    }
    
    private class func microphoneAuthorization(_ queue:DispatchQueue, _ alert: Bool, _ completion:((NX.AuthorizeState) -> ())?) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        if status ==  .authorized{
            queue.async {
                completion?(.authorized)
            }
        }
        else if status == .notDetermined{
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                if granted {
                    queue.async {
                        completion?(.authorized)
                    }
                }
                else{
                    queue.async {
                        completion?(.denied)
                    }
                    RRXCAuthorizeManager.authorizationViewDisplay(.microphone)
                }
            }
        }
        else{
            queue.async {
                completion?(.denied)
            }
            RRXCAuthorizeManager.authorizationViewDisplay(.microphone)
        }
    }

    
    private class func apnsAuthorization(_ queue:DispatchQueue, _ alert: Bool, _ completion:((NX.AuthorizeState) -> ())?){
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings{(setting) in
                if setting.authorizationStatus == .authorized {
                    queue.async {
                        completion?(.authorized)
                    }
                }
                else if setting.authorizationStatus == .notDetermined {
                    queue.async {
                        completion?(.notDetermined)
                    }
                }
                else{
                    queue.async {
                        completion?(.denied)
                    }
                }
            }
        }
        else{
            if let setting = UIApplication.shared.currentUserNotificationSettings {
                if setting.types != [] {
                    queue.async {
                        completion?(.authorized)
                    }
                }
                else {
                    queue.async {
                        completion?(.denied)
                    }
                }
            }
            else{
                queue.async {
                    completion?(.denied)
                }
            }
        }
    }
    
    private class func networkAuthorization(_ queue:DispatchQueue, _ alert: Bool, _ completion:((NX.AuthorizeState) -> ())?) {
        queue.async {
            completion?(.authorized)
        }
    }
    
    open class func description(_ type: NX.AuthorizeType) -> (title:String,subtitle:String,content:String){
        if type == NX.AuthorizeType.album {
            return RRXCAuthorizeManager.Popup.album
        }
        else if type == NX.AuthorizeType.camera{
            return RRXCAuthorizeManager.Popup.camera
        }
        else if type == NX.AuthorizeType.apns {
            return RRXCAuthorizeManager.Popup.apns
        }
        else if type == NX.AuthorizeType.network {
            return RRXCAuthorizeManager.Popup.network
        }
        else if type == NX.AuthorizeType.microphone {
            return RRXCAuthorizeManager.Popup.microphone
        }
        return ("", "", "")
    }
    
    open class func authorizationViewDisplay(_ type: NX.AuthorizeType, _ completion:((_ index:Int) -> ())? = nil){
        
        
    }
}
