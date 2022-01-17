//
//  NXDevice.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/18.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import Foundation

open class NXDevice {
    //屏幕信息
    static public let width = UIScreen.main.bounds.size.width
    static public let height = UIScreen.main.bounds.size.height
    static public let size = CGSize(width: NXDevice.width, height: NXDevice.height)
    static public let scale : CGFloat = UIScreen.main.scale
    
    static public let pixel : CGFloat = 1.0 / UIScreen.main.scale //一个像素的宽度
    
    
    //操作系统信息
    static public let os : (name:String, version:String) = (UIDevice.current.systemName, UIDevice.current.systemVersion)
    
    //页面缩进
    static public var insets : UIEdgeInsets = {
        var __insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *), let __safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets, __safeAreaInsets.top > 0 {
            __insets.top = __safeAreaInsets.top
            __insets.bottom = __safeAreaInsets.bottom
        }
        else if UIApplication.shared.statusBarFrame.size.height > 0 {
            __insets.top = UIApplication.shared.statusBarFrame.size.height
        }
        if __insets.top > 20 && __insets.bottom == 0 {
            __insets.bottom = 34.0
        }
        return __insets
    }()
    
    //判断是不是X屏幕
    static public var isXDisplay: Bool {
        return NXDevice.insets.bottom > 0.0
    }
    
    //根据isXDisplay处理UI常量信息
    static public var topOffset : CGFloat {
        return NXDevice.insets.top + 44.0
    }
    
    static public var bottomOffset : CGFloat {
        return NXDevice.insets.bottom
    }
    
    static public var toolViewOffset : CGFloat = 49.0
    
    //设备model与产品的映射表
    static public var devices : [String:String] = {
        if let value = NXSerialization.file(toDictionary: NX.Association.path + "/device.json") as? [String:String] {
            return value
        }
        return [:]
    }()
    
    public struct UI {
        public var width = CGFloat.zero
        public var height = CGFloat.zero
        public var scale = CGFloat.zero
        public var inches = [CGFloat]()
    }
    
    public static var is320x480x1 = NXDevice.UI(width: 320, height: 480, scale: 1, inches: [3.5]) ///[iPhone,iPhone3GS]
    public static var is320x480x2 = NXDevice.UI(width: 320, height: 480, scale: 2, inches: [3.5]) ///[iPhone4,iPhone4S]
    public static var is320x568x2 = NXDevice.UI(width: 320, height: 568, scale: 2, inches: [4.0]) ///[iPhone5,iPhone5c,iPhone5S,iPhoneSE1]
        
    public static var is375x667x2 = NXDevice.UI(width: 375, height: 667, scale: 2, inches: [4.7]) ///[iPhone6,iPhone6s,iPhone7,iPhone8,iPhoneSE2]
    public static var is375x812x3 = NXDevice.UI(width: 375, height: 812, scale: 3, inches: [5.4,5.8]) ///[iPhone12mini,iPhone13mini],[iPhoneX,iPhoneXs,iPhone11Pro]
    
    public static var is390x844x3 = NXDevice.UI(width: 390, height: 844, scale: 3, inches: [6.1]) ///[iPhone12,iPhone12Pro,iPhone13,iPhone13Pro]
    
    public static var is414x736x3 = NXDevice.UI(width: 414, height: 736, scale: 3, inches: [5.5]) ///[iPhone6Plus,iPhone6sPlus,iPhone7Plus,iPhone8Plus]
    public static var is414x896x2 = NXDevice.UI(width: 414, height: 896, scale: 2, inches: [6.1]) ///[iPhoneXr,iPhone11]
    public static var is414x896x3 = NXDevice.UI(width: 414, height: 896, scale: 3, inches: [6.5]) ///[iPhoneXs max,iPhone11ProMax]
    
    public static var is428x926x3 = NXDevice.UI(width: 428, height: 926, scale: 3, inches: [6.7]) ///[iPhone12ProMax,iPhone13ProMax]
}







