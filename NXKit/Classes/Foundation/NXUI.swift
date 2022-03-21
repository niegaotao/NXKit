//
//  NXUI.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/18.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import Foundation

open class NXUI {
    //屏幕信息
    static public let width = UIScreen.main.bounds.size.width
    static public let height = UIScreen.main.bounds.size.height
    static public let size = CGSize(width: NXUI.width, height: NXUI.height)
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
        return NXUI.insets.bottom > 0.0
    }
    
    //根据isXDisplay处理UI常量信息
    static public var topOffset : CGFloat {
        return NXUI.insets.top + 44.0
    }
    
    static public var bottomOffset : CGFloat {
        return NXUI.insets.bottom
    }
    
    static public var toolViewOffset : CGFloat = 49.0
    
    //设备model与产品的映射表
    static public var devices : [String:String] = {
        if let value = NXSerialization.file(toDictionary: NX.Association.root + "/NXKit.bundle/NX.bundle/device.json") as? [String:String] {
            return value
        }
        return [:]
    }()
    
    public struct Frame {
        public var width = CGFloat.zero
        public var height = CGFloat.zero
        public var scale = CGFloat.zero
        public var inches = [CGFloat]()
    }
    
    public static var is320x480x1 = NXUI.Frame(width: 320, height: 480, scale: 1, inches: [3.5]) ///[iPhone,iPhone3GS]
    public static var is320x480x2 = NXUI.Frame(width: 320, height: 480, scale: 2, inches: [3.5]) ///[iPhone4,iPhone4S]
    public static var is320x568x2 = NXUI.Frame(width: 320, height: 568, scale: 2, inches: [4.0]) ///[iPhone5,iPhone5c,iPhone5S,iPhoneSE1]
        
    public static var is375x667x2 = NXUI.Frame(width: 375, height: 667, scale: 2, inches: [4.7]) ///[iPhone6,iPhone6s,iPhone7,iPhone8,iPhoneSE2]
    public static var is375x812x3 = NXUI.Frame(width: 375, height: 812, scale: 3, inches: [5.4,5.8]) ///[iPhone12mini,iPhone13mini],[iPhoneX,iPhoneXs,iPhone11Pro]
    
    public static var is390x844x3 = NXUI.Frame(width: 390, height: 844, scale: 3, inches: [6.1]) ///[iPhone12,iPhone12Pro,iPhone13,iPhone13Pro]
    
    public static var is414x736x3 = NXUI.Frame(width: 414, height: 736, scale: 3, inches: [5.5]) ///[iPhone6Plus,iPhone6sPlus,iPhone7Plus,iPhone8Plus]
    public static var is414x896x2 = NXUI.Frame(width: 414, height: 896, scale: 2, inches: [6.1]) ///[iPhoneXr,iPhone11]
    public static var is414x896x3 = NXUI.Frame(width: 414, height: 896, scale: 3, inches: [6.5]) ///[iPhoneXs max,iPhone11ProMax]
    
    public static var is428x926x3 = NXUI.Frame(width: 428, height: 926, scale: 3, inches: [6.7]) ///[iPhone12ProMax,iPhone13ProMax]
}


// 颜色和字体
extension NXUI {
    //view背景色
    static public var viewBackgroundColor = NXUI.color(247, 247, 247)
    //contentView背景色
    static public var contentViewBackgroundColor = NXUI.color(247, 247, 247)
    //tableView背景色
    static public var naviViewBackgroundColor = NXUI.color(255, 255, 255)
    //tableView背景色
    static public var naviViewForegroundColor = NXUI.color(51, 51, 51)
    //tableView背景色
    static public var tableViewBackgroundColor = NXUI.color(247, 247, 247)
    //collectionView背景色
    static public var collectionViewBackgroundColor = NXUI.color(247, 247, 247)
    //overlay背景色
    static public var overlayBackgroundColor = NXUI.color(255, 225, 225)
    //背景色
    static public var backgroundColor = NXUI.color(255, 255, 255)
    //选中背景色
    static public var selectedBackgroundColor = NXUI.color(218.0, 218.0, 218.0, 0.3)
    //分割线颜色
    static public var separatorColor = NXUI.color(235, 235, 240)
    //阴影颜色
    static public var shadowColor = NXUI.color(56, 79, 134)
    // 主色
    static public var mainColor = NXUI.color(51, 120, 246)
    // 深黑
    static public var darkBlackColor = NXUI.color(51, 51, 51)
    // 浅黑
    static public var lightBlackColor = NXUI.color(102, 102, 102)
    // 深灰
    static public var darkGrayColor = NXUI.color(153, 153, 153)
    // 浅灰
    static public var lightGrayColor = NXUI.color(192, 192, 192)
    // 转场前容器视图的Alpha值
    static public var minAlphaOfColor = UIColor.black.withAlphaComponent(0.01)
    // 转场后容器视图的Alpha值
    static public var maxAlphaOfColor = UIColor.black.withAlphaComponent(0.30)
    
    //用户设定的暗黑模式类型
    static private(set) var __userInterfaceStyle = NXUI.Color.light
    static public var userInterfaceStyle : NXUI.Color {
        set{
            __userInterfaceStyle = newValue
        }
        get{
            if __userInterfaceStyle == NXUI.Color.light {
                return NXUI.Color.light
            }
            else if __userInterfaceStyle == NXUI.Color.dark {
                if #available(iOS 13.0, *) {
                    return NXUI.Color.dark
                }
                return NXUI.Color.light
            }
            else {
                if #available(iOS 13.0, *) {
                    if UITraitCollection.current.userInterfaceStyle == .dark {
                        return NXUI.Color.dark
                    }
                }
                return NXUI.Color.light
            }
        }
    }
    
    //初始化的状态栏样式
    static private(set) var __statusBarStyle = NXUI.Bar.dark
    static public var statusBarStyle : NXUI.Bar {
        set{
            if NX.isViewControllerBasedStatusBarAppearance {
                if newValue !=  .none {
                    __statusBarStyle = newValue
                }
            }
            else {
                if newValue == NXUI.Bar.hidden {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = true
                }
                else if newValue == NXUI.Bar.unspecified {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
                }
                else if newValue == NXUI.Bar.light {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
                }
                else if newValue == NXUI.Bar.dark {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    if #available(iOS 13.0, *) {
                        if userInterfaceStyle == NXUI.Color.dark {
                            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
                        }
                        else {
                            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.darkContent, animated: true)
                        }
                    }
                    else{
                        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
                    }
                }
            }
        }
        get{
            return __statusBarStyle
        }
        
    }
    
    //暗黑模式的类型
    public enum Color : String {
        case unspecified = "unspecified"
        case light = "light"
        case dark = "dark"
    }
    
    //状态栏的样式
    public enum Bar : String {
        case none = "none"
        case hidden = "hidden"
        case unspecified = "unspecified"
        case light = "light"
        case dark = "dark"
    }
    
}


// 
extension NXUI {
    static public var AnimationClass : NXAnimationWrappedView.Type = NXAnimationWrappedView.self //空页面加载动画类型
    static public var HUDAnimationClass : NXAnimationWrappedView.Type = NXAnimationWrappedView.self//loading

    static public var isSeparatorHidden = false
}


// 颜色和字体
extension NXUI {
    
    //颜色:rgb+alpha, rgb:[0,255],a:[0,1]
    public class func color(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat = 1.0) -> UIColor {
        return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
    }
    
    //颜色：hex+alpha
    public class func color(_ hex:Int, _ a: CGFloat = 1.0) -> UIColor {
        return NXUI.color(((CGFloat)((hex & 0xFF0000) >> 16)), ((CGFloat)((hex & 0xFF00) >> 8)), ((CGFloat)(hex & 0xFF)), a)
    }
    
    //创建浅色/暗黑模式的颜色
    public class func color(_ lightColor:UIColor, _ darkColor:UIColor? = nil) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (__collection) -> UIColor in
                if let __darkColor = darkColor, NXUI.userInterfaceStyle == NXUI.Color.dark {
                    return __darkColor
                }
                return lightColor
            }
        }
        return lightColor
    }
    
    //字体:
    public class func font(_ size: CGFloat, _ blod:Bool = false) -> UIFont {
        if blod {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    //自定义字体:
    public class func font(_ name:String, _ size: CGFloat, _ blod:Bool = false) -> UIFont {
        if let font =  UIFont(name: name, size: size) {
            return font
        }
        return NXUI.font(size, blod)
    }
}

extension NXUI {
    //加载获取bundle中图片
    public class func image(named name:String) -> UIImage? {
        guard name.count > 0 else {return nil}
        if NX.Association.root.count > 0 {
            return UIImage(named: "\(NX.Association.root)/NXKit.bundle/NX.bundle/\(name)")
        }
        return UIImage(named: name)
    }
    
    //处理图片浏览
    class public func previewAssets(type:String, assets:[Any], index:Int){
        NX.Imp.previewAssets?(type, assets, index)
    }
    
    //设置图像
    class public func image(_ targetView:UIView?, _ url:String, _ state:UIControl.State = UIControl.State.normal){
        NX.Imp.image?(targetView, url, state)
    }
}

extension NXUI {
    
    //toast
    @discardableResult
    class public func showToast(message:String, _ ats:NX.Ats = .center, _ superview:UIView? = UIApplication.shared.keyWindow) -> NXHUD.WrappedView? {
        if let handler = NX.Imp.showToast {
            return handler(message, ats, superview)
        }
        else {
            return (superview ?? UIApplication.shared.keyWindow)?.makeToast(message: message, ats: ats)
        }
    }
    
    //处理loading
    @discardableResult
    class public func showLoading(_ message:String, _ ats:NX.Ats = .center, _ superview:UIView? = UIApplication.shared.keyWindow) -> NXHUD.WrappedView?{
        if let handler = NX.Imp.showLoading {
            return handler(message, ats, superview)
        }
        else {
            return (superview ?? UIApplication.shared.keyWindow)?.makeLoading(message: message, ats: ats)
        }
    }
    
    //处理loading
    class public func hideLoading(_ animationView:NXHUD.WrappedView? = nil, superview:UIView? = UIApplication.shared.keyWindow){
        if let handler = NX.Imp.hideLoading {
            handler(animationView, superview)
        }
        else {
            (superview ?? UIApplication.shared.keyWindow)?.hideLoading()
        }
    }
}


extension NXUI {
    open class func resize(size:CGSize, to:CGSize, mode:UIView.ContentMode) -> CGRect {
        var __frame = CGRect.zero
        if size.width <= 0 || size.height <= 0 || to.width <= 0 || to.height <= 0 {
            return __frame
        }
        let p = CGPoint(x: size.width/to.width, y: size.height/to.height)
        if mode == .scaleAspectFit {
            //等比缩放，长边撑满，短边留白
            if p.x >= p.y {
                __frame.origin.x = 0
                __frame.size.width = to.width
                __frame.size.height = __frame.size.width * (size.height / size.width)
                __frame.origin.y = (to.height - __frame.size.height)/2.0
            }
            else {
                __frame.origin.y = 0
                __frame.size.height = to.height
                __frame.size.width = __frame.size.height * (size.width / size.height)
                __frame.origin.x = (to.width - __frame.size.width)/2.0
            }
        }
        else if mode == .scaleAspectFill {
            //等比缩放，短边撑满，长边溢出
            if p.x >= p.y {
                __frame.origin.y = 0
                __frame.size.height = to.height
                __frame.size.width = __frame.size.height * (size.width / size.height)
                __frame.origin.x = (to.width - __frame.size.width)/2.0
            }
            else {
                __frame.origin.x = 0
                __frame.size.width = to.width
                __frame.size.height = __frame.size.width * (size.height / size.width)
                __frame.origin.y = (to.height - __frame.size.height)/2.0
            }
        }
        else {
            __frame.origin.x = 0
            __frame.origin.y = 0
            __frame.size.width = to.width
            __frame.size.height = to.height
        }
        
        return __frame
    }
}






