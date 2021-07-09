//
//  NXDevice.swift
//  NXKit
//
//  Created by firelonely on 2018/5/18.
//  Copyright © 2018年 无码科技. All rights reserved.
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
    static public let iPhone : Bool = UIDevice.current.userInterfaceIdiom == .phone //UI样式
    static public let iPad : Bool = UIDevice.current.userInterfaceIdiom == .pad //UI样式
    
    //页面缩进
    static public var insets : UIEdgeInsets = {
        var __insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *), let window = UIApplication.shared.windows.first {
            __insets = window.safeAreaInsets
            if abs(__insets.bottom - 34.0) <= 1.0 {
                __insets.top = 44.0
            }
            else if abs(__insets.bottom - 20.0) <= 1.0{
                __insets.top = 24.0
            }
            else {
                __insets.top = 20.0
            }
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
    static public let devices = ["Watch1,1" : "Apple Watch 38mm",
            "Watch1,2" : "Apple Watch 42mm",
            "Watch2,3" : "Apple Watch Series 2 38mm",
            "Watch2,4" : "Apple Watch Series 2 42mm",
            "Watch2,6" : "Apple Watch Series 1 38mm",
            "Watch1,7" : "Apple Watch Series 1 42mm",
            
            "iPod1,1" : "iPod touch (1st generation)",
            "iPod2,1" : "iPod touch (2nd generation)",
            "iPod3,1" : "iPod touch (3th generation)",
            "iPod4,1" : "iPod touch (4th generation)",
            "iPod5,1" : "iPod touch (5th generation)",
            "iPod7,1" : "iPod touch (6th generation)",
            "iPod9,1" : "iPod touch (7th generation)",

            
            "iPhone1,1" : "iPhone 1G",
            "iPhone1,2" : "iPhone 3G",
            "iPhone2,1" : "iPhone 3GS",
            "iPhone3,1" : "iPhone 4 (GSM)",
            "iPhone3,2" : "iPhone 4",
            "iPhone3,3" : "iPhone 4 (CDMA)",
            "iPhone4,1" : "iPhone 4S",
            "iPhone5,1" : "iPhone 5",
            "iPhone5,2" : "iPhone 5",
            "iPhone5,3" : "iPhone 5c",
            "iPhone5,4" : "iPhone 5c",
            "iPhone6,1" : "iPhone 5s",
            "iPhone6,2" : "iPhone 5s",
            "iPhone7,1" : "iPhone 6 Plus",
            "iPhone7,2" : "iPhone 6",
            "iPhone8,1" : "iPhone 6s",
            "iPhone8,2" : "iPhone 6s Plus",
            "iPhone8,4" : "iPhone SE (1st generation)",
            "iPhone9,1" : "iPhone 7",
            "iPhone9,2" : "iPhone 7 Plus",
            "iPhone9,3" : "iPhone 7",
            "iPhone9,4" : "iPhone 7 Plus",
            "iPhone10,1" : "iPhone 8",
            "iPhone10,2" : "iPhone 8 Plus",
            "iPhone10,3" : "iPhone X",
            "iPhone10,4" : "iPhone 8",
            "iPhone10,5" : "iPhone 8Plus",
            "iPhone10,6" : "iPhone X",
            "iPhone11,2" : "iPhone XS",
            "iPhone11,4" : "iPhone XS Max",
            "iPhone11,6" : "iPhone XS Max",
            "iPhone11,8" : "iPhone XR",
            "iPhone12,1" : "iPhone 11",
            "iPhone12,3" : "iPhone 11 Pro",
            "iPhone12,5" : "iPhone 11 Pro Max",
            "iPhone12,8" : "iPhone SE (2nd generation)",
            "iPhone13,1" : "iPhone 12 mini",
            "iPhone13,2" : "iPhone 12",
            "iPhone13,3" : "iPhone 12 Pro",
            "iPhone13,4" : "iPhone 12 Pro Max",
            
            "iPad1,1" : "iPad 1",
            "iPad2,1" : "iPad 2",
            "iPad2,2" : "iPad 2",
            "iPad2,3" : "iPad 2",
            "iPad2,4" : "iPad 2",
            "iPad3,1" : "iPad (3th generation)",
            "iPad3,2" : "iPad (3th generation)",
            "iPad3,3" : "iPad (3th generation)",
            "iPad3,4" : "iPad (4th generation)",
            "iPad3,5" : "iPad (4th generation)",
            "iPad3,6" : "iPad (4th generation)",
            "iPad6,11" : "iPad (5th generation)",
            "iPad6,12" : "iPad (5th generation)",
            "iPad7,5" : "iPad (6th generation)",
            "iPad7,6" : "iPad (6th generation)",
            "iPad11,1" : "iPad mini (7th generation)",
            "iPad11,2" : "iPad mini (7th generation)",
            
            
            "iPad4,1" : "iPad Air",
            "iPad4,2" : "iPad Air",
            "iPad4,3" : "iPad Air",
            "iPad5,3" : "iPad Air 2",
            "iPad5,4" : "iPad Air 2",
            "iPad11,3" : "iPad Air (3th generation)",
            "iPad11,4" : "iPad Air (3th generation)",
            
            
            "iPad6,7" : "iPad Pro (12.9 inch)",
            "iPad6,8" : "iPad Pro (12.9 inch)",
            "iPad6,3" : "iPad Pro (9.7 inch)",
            "iPad6,4" : "iPad Pro (9.7 inch)",
            "iPad7,1" : "iPad Pro (12.9-inch)(2nd generation)",
            "iPad7,2" : "iPad Pro (12.9-inch)(2nd generation)",
            "iPad7,3" : "iPad Pro (10.5-inch)",
            "iPad7,4" : "iPad Pro (10.5-inch)",
            
            "iPad8,1" : "iPad Pro (11-inch)",
            "iPad8,2" : "iPad Pro (11-inch)",
            "iPad8,3" : "iPad Pro (11-inch)",
            "iPad8,4" : "iPad Pro (11-inch)",
            "iPad8,5" : "iPad Pro (12.9-inch)(3th generation)",
            "iPad8,6" : "iPad Pro (12.9-inch)(3th generation)",
            "iPad8,7" : "iPad Pro (12.9-inch)(3th generation)",
            "iPad8,8" : "iPad Pro (12.9-inch)(3th generation)",
            "iPad8,9" : "iPad Pro (11-inch)(2nd generation)",
            "iPad8,10" : "iPad Pro (11-inch)(2nd generation)",
            "iPad8,11" : "iPad Pro (12.9-inch)(4th generation)",
            "iPad8,12" : "iPad Pro (12.9-inch)(4th generation)",
            
    
            "iPad2,5" : "iPad mini",
            "iPad2,6" : "iPad mini",
            "iPad2,7" : "iPad mini",
            "iPad4,4" : "iPad mini 2",
            "iPad4,5" : "iPad mini 2",
            "iPad4,6" : "iPad mini 2",
            "iPad4,7" : "iPad mini 3",
            "iPad4,8" : "iPad mini 3",
            "iPad4,9" : "iPad mini 3",
            "iPad5,1" : "iPad mini 4",
            "iPad5,2" : "iPad mini 4",
            "iPad11,1" : "iPad mini (5th generation)",
            "iPad11,2" : "iPad mini (5th generation)",
            
            
            "AppleTV2,1" : "Apple TV 2",
            "AppleTV3,1" : "Apple TV 3",
            "AppleTV3,2" : "Apple TV 3",
            "AppleTV5,3" : "Apple TV 4",
            
            "i386" : "Simulator x86",
            "x86_64" : "Simulator x64"]
    
    public struct Typed {
        public var width = CGFloat.zero
        public var height = CGFloat.zero
        public var scale = CGFloat.zero
        public var inches = [CGFloat]()
    }
    
    public static var is320x480x1 = NXDevice.Typed(width: 320, height: 480, scale: 1, inches: [3.5]) ///[iPhone,iPhone3GS]
    public static var is320x480x2 = NXDevice.Typed(width: 320, height: 480, scale: 2, inches: [3.5]) ///[iPhone4,iPhone4S]
    public static var is320x568x2 = NXDevice.Typed(width: 320, height: 568, scale: 2, inches: [4.0]) ///[iPhone5,iPhone5c,iPhone5S,iPhoneSE1]
        
    public static var is375x667x2 = NXDevice.Typed(width: 375, height: 667, scale: 2, inches: [4.7]) ///[iPhone6,iPhone6s,iPhone7,iPhone8,iPhoneSE2]
    public static var is375x812x3 = NXDevice.Typed(width: 375, height: 812, scale: 3, inches: [5.4,5.8]) ///[iPhone12mini],[iPhoneX,iPhoneXs,iPhone11Pro]
    
    public static var is390x844x3 = NXDevice.Typed(width: 390, height: 844, scale: 3, inches: [6.1]) ///[iPhone12,iPhone12Pro]
    
    public static var is414x736x3 = NXDevice.Typed(width: 414, height: 736, scale: 3, inches: [5.5]) ///[iPhone6Plus,iPhone6sPlus,iPhone7Plus,iPhone8Plus]
    public static var is414x896x2 = NXDevice.Typed(width: 414, height: 896, scale: 2, inches: [6.1]) ///[iPhoneXr,iPhone11]
    public static var is414x896x3 = NXDevice.Typed(width: 414, height: 896, scale: 3, inches: [6.5]) ///[iPhoneXs max,iPhone11ProMax]
    
    public static var is428x926x3 = NXDevice.Typed(width: 428, height: 926, scale: 3, inches: [6.7]) ///[iPhone12ProMax]
}







