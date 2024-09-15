//
//  NX.swift
//  NXKit
//
//  Created by niegaotao on 2020/1/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation


//应用程序信息
open class NX {
    static public let infoDictionary = Bundle.main.infoDictionary ?? [:]
    static public let namespace = NX.infoDictionary["CFBundleExecutable"] as? String ?? ""
    static public let name = NX.infoDictionary["CFBundleDisplayName"] as? String ?? ""
    static public let version = NX.infoDictionary["CFBundleShortVersionString"] as? String ?? ""
    static public let build = NX.infoDictionary["CFBundleVersion"] as? String ?? ""    
}

extension NX {
    public typealias Completion<Value> = (_ value:Value)  -> ()
    public typealias Event<Event, Value> = (_ event:Event, _ value:Value)  -> ()
}

//屏幕
extension NX {
    static public let width = UIScreen.main.bounds.size.width
    static public let height = UIScreen.main.bounds.size.height
    static public let size = CGSize(width: NX.width, height: NX.height)
    static public let scale = max(UIScreen.main.scale, 1.0)
    static public let pixel = 1.0 / NX.scale //一个像素的宽度
    
    //页面缩进
    static public var safeAreaInsets : UIEdgeInsets = {
        var __insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *), let __safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets, __safeAreaInsets.top > 0 {
            __insets.top = __safeAreaInsets.top
            __insets.bottom = __safeAreaInsets.bottom
            if __insets.top >= 59 {
                __insets.top = 54
            }
            //20, 44, 47, 54
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
        return NX.safeAreaInsets.bottom > 0.0
    }
    
    //根据isXDisplay处理UI常量信息
    static public var topOffset : CGFloat {
        return NX.safeAreaInsets.top + 44.0
    }
    
    static public var bottomOffset : CGFloat {
        return NX.safeAreaInsets.bottom
    }
    
    static public var toolViewOffset : CGFloat = 49.0
}


// 颜色
extension NX {
    //背景色
    static public var backgroundColor = NX.color(255, 255, 255, 1)
    //view背景色
    static public var viewBackgroundColor = NX.color(247, 247, 247, 1)
    //未选中背景色
    static public var cellBackgroundColor = NX.color(255, 255, 255, 1.0)
    //选中背景色
    static public var cellSelectedBackgroundColor = NX.color(234, 234, 234, 0.3)
    //navigationView背景色
    static public var barBackgroundColor = NX.color(255, 255, 255, 1)
    //navigationView背景色
    static public var barForegroundColor = NX.color(51, 51, 51, 1)
    
    //overlay背景色
    static public var overlayBackgroundColor = NX.color(255, 225, 225, 1)
    
    //分割线颜色
    static public var separatorColor = NX.color(235, 235, 240, 1)
    //阴影颜色
    static public var shadowColor = NX.color(56, 79, 134, 1)
    // 主色
    static public var mainColor = NX.color(51, 120, 246, 1)
    // 深黑
    static public var blackColor = NX.color(51, 51, 51, 1)
    // 深灰
    static public var darkGrayColor = NX.color(102, 102, 102, 1)
    // 浅灰
    static public var lightGrayColor = NX.color(153, 153, 153, 1)
    // 转场前容器视图的Alpha值
    static public var transitionInoutBackgroundColor = NX.color(0, 0, 0, 0)
    // 转场后容器视图的Alpha值
    static public var transitionBackgroundColor = NX.color(0, 0, 0, 0.3)
    
    //颜色:rgb+alpha, rgb:[0,255],a:[0,1]
    public class func color(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    //颜色：hex+alpha
    public class func color(_ hex:Int, _ a: CGFloat = 1.0) -> UIColor {
        return NX.color(((CGFloat)((hex & 0xFF0000) >> 16)), ((CGFloat)((hex & 0xFF00) >> 8)), ((CGFloat)(hex & 0xFF)), a)
    }
    
    //创建浅色/暗黑模式的颜色
    public class func color(_ lightColor:UIColor, _ darkColor:UIColor? = nil) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (__collection) -> UIColor in
                if let __darkColor = darkColor, NX.darkMode == NX.DarkMode.dark {
                    return __darkColor
                }
                return lightColor
            }
        }
        return lightColor
    }
}


//字体
extension NX {
    //字体
    public class func font(_ size: CGFloat, _ weight:UIFont.Weight = UIFont.Weight.regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    //自定义字体
    public class func font(_ name:String, _ size: CGFloat) -> UIFont {
        if let font =  UIFont(name: name, size: size) {
            return font
        }
        return NX.font(size, .regular)
    }
}

// 设备-其他
extension NX {
    //设备model与产品的映射表
    static public var devices : [String:Any] = {
        return NXSerialization.file(toDictionary: NX.Association.root + "/NXKit.bundle/NX.bundle/device.json")
    }()
    
    public static let is320x480 = CGSize(width: 320, height: 480)
    // 1x [iPhone,iPhone3GS]
    // 2x [iPhone4,iPhone4S]
    
    public static var is320x568 = CGSize(width: 320, height: 568)
    //2x [iPhone5,iPhone5c,iPhone5S,iPhoneSE1]
        
    public static var is375x667 = CGSize(width: 375, height: 667)
    //2x [iPhone6,iPhone6s,iPhone7,iPhone8,iPhoneSE2,iPhoneSE3]
    
    public static var is375x812 = CGSize(width: 375, height: 812)
    //3x: [iPhone12mini,iPhone13mini],[iPhoneX,iPhoneXs,iPhone11Pro]
    
    public static var is390x844 = CGSize(width: 390, height: 844)
    //3x:[iPhone12,iPhone12Pro,iPhone13,iPhone13Pro,iPhone14]
    
    public static var is393x852 = CGSize(width: 393, height: 852)
    //3x:[iPhone14Pro]
    
    public static var is414x736 = CGSize(width: 414, height: 736)
    //3x:[iPhone6Plus,iPhone6sPlus,iPhone7Plus,iPhone8Plus]
    
    public static var is414x896 = CGSize(width: 414, height: 896)
    //2x:[iPhoneXr,iPhone11]
    //3x:[iPhoneXs max,iPhone11ProMax]
    
    public static var is428x926 = CGSize(width: 428, height: 926)
    //3x:[iPhone12ProMax,iPhone13ProMax,iPhone14Plus]
    
    public static var is430x932 = CGSize(width: 430, height: 932)
    //3x:[iPhone14ProMax]
}


//用户设定的暗黑模式类型
extension NX {
    static private(set) var __darkMode = NX.DarkMode.light
    static public var darkMode : NX.DarkMode {
        set{
            __darkMode = newValue
        }
        get{
            if __darkMode == NX.DarkMode.light {
                return NX.DarkMode.light
            }
            else if __darkMode == NX.DarkMode.dark {
                if #available(iOS 13.0, *) {
                    return NX.DarkMode.dark
                }
                return NX.DarkMode.light
            }
            else {
                if #available(iOS 13.0, *) {
                    if UITraitCollection.current.userInterfaceStyle == .dark {
                        return NX.DarkMode.dark
                    }
                }
                return NX.DarkMode.light
            }
        }
    }
    
    //初始化的状态栏样式
    static private(set) var __statusBarStyle = NX.StatusBarStyle.dark
    static public var statusBarStyle : NX.StatusBarStyle {
        set{
            if newValue !=  .none {
                __statusBarStyle = newValue
            }
        }
        get{
            return __statusBarStyle
        }
    }
    
    //暗黑模式的类型
    public enum DarkMode : String {
        case unspecified = "unspecified"
        case light = "light"
        case dark = "dark"
    }
    
    //状态栏的样式
    public enum StatusBarStyle : String {
        case none = "none"
        case hidden = "hidden"
        case unspecified = "unspecified"
        case light = "light"
        case dark = "dark"
    }
    
}


//全局UI
extension NX {
    static public var tableViewStyle = UITableView.Style.grouped
    static public var separatorStyle = UITableViewCell.SeparatorStyle.none
    
    static public var AnimationClass : NXAnimationWrappedView.Type = NXAnimationWrappedView.self //空页面加载动画类型
    static public var HUDAnimationClass : NXAnimationWrappedView.Type = NXAnimationWrappedView.self//loading
}



//获取框架中的资源文件
extension NX {
    //加载获取bundle中图片
    public class func image(named name:String, mode:UIImage.RenderingMode = .automatic) -> UIImage? {
        guard name.count > 0 else {return nil}
        if NX.Association.root.count > 0 {
            return UIImage(named: "\(NX.Association.root)/NXKit.bundle/NX.bundle/\(name)")?.withRenderingMode(mode)
        }
        return UIImage(named: name)?.withRenderingMode(mode)
    }
    
    //处理图片浏览
    class public func previewAssets(assets:[Any], index:Int){
        NX.Imp.previewAssets?(assets, index)
    }
    
    //设置图像
    class public func image(_ targetView:UIView?, _ url:String, _ state:UIControl.State = UIControl.State.normal){
        NX.Imp.image?(targetView, url, state)
    }
}

//提示与加载动画
extension NX {
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


//重定尺寸
extension NX {
    public class func resize(size:CGSize, to:CGSize, mode:UIView.ContentMode) -> CGRect {
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

//内容横向纵向边缘缩进
extension NX {
    open class Point : NXAny {
        open var x = CGFloat.zero
        open var y = CGFloat.zero
        
        open var origin : CGPoint {
            set {
                self.x = newValue.x
                self.y = newValue.y
            }
            get {
                return CGPoint(x: self.x, y: self.y)
            }
        }
        
        public required init(){
            super.init()
        }
        
        public init(completion: NX.Completion<NX.Point>?){
            super.init()
            completion?(self)
        }
    }
    
    open class Size : NXAny {
        open var width = CGFloat.zero
        open var height = CGFloat.zero
        
        open var size : CGSize {
            set {
                self.width = newValue.width
                self.height = newValue.height
            }
            get {
                return CGSize(width: self.width, height: self.height)
            }
        }
        
        public required init(){
            super.init()
        }
        
        public init(completion: NX.Completion<NX.Size>?){
            super.init()
            completion?(self)
        }
    }
    
    open class Rect : NXAny {
        open var x = CGFloat.zero
        open var y = CGFloat.zero
        open var width = CGFloat.zero
        open var height = CGFloat.zero
        
        open var origin : CGPoint {
            set {
                self.x = newValue.x
                self.y = newValue.y
            }
            get {
                return CGPoint(x: self.x, y: self.y)
            }
        }
        
        open var size : CGSize {
            set {
                self.width = newValue.width
                self.height = newValue.height
            }
            get {
                return CGSize(width: self.width, height: self.height)
            }
        }
        
        open var frame : CGRect {
            set {
                self.x = newValue.origin.x
                self.y = newValue.origin.y
                self.width = newValue.size.width
                self.height = newValue.size.height
            }
            get {
                return CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
            }
        }
        
        public required init(){
            super.init()
        }
        
        public init(completion: NX.Completion<NX.Rect>?){
            super.init()
            completion?(self)
        }
    }
}

//内容横向纵向边缘缩进
extension NX {
    static public var insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    
    public struct Ats : OptionSet {
        public private(set) var rawValue : Int = 0
        public init(rawValue:Int) {
            self.rawValue = rawValue
        }
        
        public static var unspefified = NX.Ats(rawValue: 0)
        
        public static var minX = NX.Ats(rawValue: 1)        //2^0=0b0001
        public static var centerX = NX.Ats(rawValue: 2)     //2^1=0b0010
        public static var maxX = NX.Ats(rawValue: 4)        //2^2=0b0100
        public static var Xs = NX.Ats(rawValue: 7)          //2^0+2^1+2^2=0b0111

        public static var minY =  NX.Ats(rawValue: 16)      //2^4=0b0001 0000
        public static var centerY =  NX.Ats(rawValue: 32)   //2^5=0b0010 0000
        public static var maxY = NX.Ats(rawValue: 64)       //2^6=0b0100 0000
        public static var Ys = NX.Ats(rawValue: 112)        //2^4+2^5+2^6=0b0111 0000

        public static var center = NX.Ats(rawValue: 34)     //2^1+2^5=0b0010 0010
    }
}


extension NX {
    public enum Navigation : Int {
        case push       //打开页面通过push方式打开的
        case present    //打开页面通过present方式打开的
        case overlay    //打开页面通过overlay方式打开的
    }
    
    public enum Orientation : Int {
        case top        //从顶部进入
        case left       //从左侧进入
        case bottom     //从底部进入
        case right      //从右侧进入
    }
    
    public enum Reload : Int {
        case initialized //初始状态
        case pulldown      //下拉刷新
        case pullup        //上拉加载更多
    }
    
    public struct Lifecycle : OptionSet {
        
        public private(set) var rawValue : Int = -1
        public init(rawValue:Int) {
            self.rawValue = rawValue
        }
        
        public static var initialized = NX.Lifecycle(rawValue: 0)
        
        public static var viewWillAppear = NX.Lifecycle(rawValue: 1)
        public static var viewDidAppear = NX.Lifecycle(rawValue: 2)
        public static var viewWillDisappear = NX.Lifecycle(rawValue: 4)
        public static var viewDidDisappear = NX.Lifecycle(rawValue: 8)
    }
}

extension NX {
    public static var isLoggable : Bool = true
    private static let formatter = DateFormatter()
    public class func print(_ items:Any?, _ file:String = #file, _ method: String = #function, _ line: Int = #line) {
        guard NX.isLoggable, let value = items else {
            return
        }
        let time = NX.descriptionOf(date: Date(), format: "YYYY-MM-dd HH:mm:ss.SSSSSSZ")
        Swift.print("\(time) \((file as NSString).lastPathComponent)[\(line)],\(method):\n\(value)\n")
    }
    
    public class func log(_ get: @autoclosure () -> Any?, _ file:String = #file, _ method: String = #function, _ line: Int = #line){
        guard NX.isLoggable , let value = get() else {
            return
        }
        let time = NX.descriptionOf(date: Date(), format: "YYYY-MM-dd HH:mm:ss.SSSSSSZ")
        Swift.print("\(time) \((file as NSString).lastPathComponent)[\(line)],\(method):\n\(value)\n")
    }
    
    //yyyy-MM-dd HH:mm
    class public func descriptionOf(date:Date, format:String) -> String {
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}


extension NX {
    //授权类型
    public enum Authorize {
        case album          //系统相册
        case camera         //照相机
        case contacts       //通讯录
        case loaction       //定位
        case calendars      //日历
        case microphone     //麦克风
        case apns           //通知
        case network        //网络权限
        case pasteboard     //剪贴板
        case bluetooth      //蓝牙
        case health         //健康
        case motion         //运动
        case music          //音乐
        case siri           //siri
        case reminders      //提醒
    }
    
    //授权状态
    public enum AuthorizeState {
        case authorized     //用户已授权
        case notDetermined  //暂未请求权限（除推送通知外都会请求用户授权）
        case denied        //用户已拒绝
        case error          //其他错误
    }
    
    public class Association {
        //Framework所在的路径
        static public var root = Bundle(for: NX.self).bundlePath
        
        //进行urlcomponent编码的字符
        static public var characters = "!*'();:@&=+$,/?%#[]{}\"\\"
        
        //根据scheme处理
        //使用NXSerialization生成actionURL时带的前缀
        static public var scheme = ""
        
        //网页中注册的js方法，例如rrxc,则js通过window.webkit.messageHandlers.rrxc.postMessage(map/string)
        static public var names = [String]()
        
        //允许跳转出去的urls,例如wexin://可以直接打开微信, itms-app://可以打开AppStore
        static public var openURLs = [String]()
        
        //黑名单:在http,https下处理
        static public var blackURLs = [String]()
        
        //白名单:在http,https下处理
        static public var whiteURLs = [String]()
        
        //拦截的资源的url
        static public var schemes = [String]()
        
        //js注入脚本
        static public var scripts = [WKUserScript]()
        
        //alert/action的单元格最大宽度、高度
        static public var size = CGSize(width: NX.width*0.8, height: 48.0)
    }
    
    public class Imp {
        //处理图片浏览
        static public var previewAssets:((_ assets:[Any], _ index:Int) -> ())?
        
        //设置url
        static public var image : ((_ targetView: UIView?, _ url:String, _ state:UIControl.State) -> ())?
        
        //encodeURIComponent
        static public var encodeURIComponent:((_ uri:String) -> (String))?
        
        //decodeURIComponent
        static public var decodeURIComponent:((_ uri:String) -> (String))?
        
        //授权的回调
        static public var authorization:((_ type: NX.Authorize, _ queue:DispatchQueue, _ isAlertable: Bool, _ completion:((NX.AuthorizeState) -> ())?) ->())?
        
        //这里处理网页中回调的js桥接
        static public var webView : ((_ action:String, _ contentView: WKWebView, _ value:[String:Any],  _ viewController:NXWebViewController?) -> Bool)?
        
        //这里处理单元格高度的通过autoLayout计算的一种回调
        static public var tableView : ((_ tableView: UITableView?, _ value:NXItem, _ indexPath:IndexPath) -> CGFloat)?
        
        //处理toast
        static public var showToast:((_ message:String, _ ats:NX.Ats , _ superview:UIView?) -> NXHUD.WrappedView?)?
        
        //处理animation
        static public var showLoading:((_ message:String, _ ats:NX.Ats, _ superview:UIView?) -> NXHUD.WrappedView?)?
        
        //处理animation
        static public var hideLoading:((_ animationView:NXHUD.WrappedView?, _ superview:UIView?) -> ())?
        
        //处理网络请求
        static public var request:((_ request:NXRequest, _ completion:NX.Event<String, NXResponse>?) -> ())?
    }
}

//request
extension NX {
    //request
    class public func request(_ request:NXRequest, _ completion:NX.Event<String, NXResponse>?) {
        NX.Imp.request?(request, completion)
    }
}


// 图片
extension NX {
    //encodeURIComponent
    class public func encodeURIComponent(_ uri:String) -> String {
        if NX.Imp.encodeURIComponent != nil {
            return NX.Imp.encodeURIComponent?(uri) ?? ""
        }
        /*!*'();:@&=+$,/?%#[]{}   增加了对"和\ --> !*'();:@&=+$,/?%#[]{}\"\\ */
        return String.encodeURIComponent(uri) ?? ""
    }
    
    //decodeURIComponent
    class public func decodeURIComponent(_ uri:String) -> String {
        if NX.Imp.decodeURIComponent != nil {
            return NX.Imp.decodeURIComponent?(uri) ?? uri
        }
        return String.decodeURIComponent(uri)
    }

    //openURL
    class public func open(_ url: URL, _ options: [UIApplication.OpenExternalURLOptionsKey : Any], completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options:options, completionHandler: completion)
        }
        else{
            let isDisposed = UIApplication.shared.openURL(url)
            completion?(isDisposed)
        }
    }
    
    //获取授权/请求授权入口
    class public func authorization(_ type: NX.Authorize, _ queue:DispatchQueue, _ isAlertable: Bool, _ completion:((NX.AuthorizeState) -> ())?){
        NX.Imp.authorization?(type, queue, isAlertable, completion)
    }

    
    //这里处理网页中回调的js桥接
    @discardableResult
    class public func dispose(_ action:String, _ webView:WKWebView, _ value:[String:Any], _ viewController:NXWebViewController?) -> Bool? {
        return NX.Imp.webView?(action, webView, value, viewController)
    }
    
    //这里处理单元格高度的通过autoLayout计算的一种回调
    class public func heightForRow(_ tableView:UITableView?, _ value:NXItem, _ indexPath:IndexPath) -> CGFloat? {
        return NX.Imp.tableView?(tableView, value, indexPath)
    }
}


extension NX {
    class public func get(dictionary:[String:Any]?, _ nonnullValue:[String:Any] = [:]) -> [String:Any] {
        if let __value = dictionary, __value.count > 0 {
            return __value
        }
        return nonnullValue
    }
    
    class public func get(array:[Any]?, _ nonnullValue:[Any] = []) -> [Any] {
        if let __value = array, __value.count > 0 {
            return __value
        }
        return nonnullValue
    }
    
    class public func get(string:String?, _ nonnullValue:String = "") -> String {
        if let __value = string, __value.count > 0 {
            return __value
        }
        return nonnullValue
    }
    
    class public func get(int:Int?, _ nonnullValue:Int = 0) -> Int {
        if let __value = int {
            return __value
        }
        return nonnullValue
    }
    
    class public func get(float:CGFloat?, _ nonnullValue:CGFloat = 0.0) -> CGFloat {
        if let __value = float {
            return __value
        }
        return nonnullValue
    }
    
    class public func get(bool:Bool?, _ nonnullValue:Bool = false) -> Bool {
        if let __value = bool {
            return __value
        }
        return nonnullValue
    }
    
    class public func get<T:Equatable>(value:T?, _ nonnullValue:T) -> T {
        if let __value = value {
            return __value
        }
        return nonnullValue
    }
}


extension NX {
    open class View : NX.Rect {
        open var isHidden = false
        open var backgroundColor = NX.backgroundColor
        open var cornerRadius = CGFloat(0.0)
        open var masksToBounds : Bool = false

        public required init() {
            super.init()
        }
    }
    
    open class Appearance : NX.View {
        open var selectedBackgroundColor = NX.cellSelectedBackgroundColor
        open var isHighlighted = false
        open var isEnabled = true
        open var isCloseable = true
        
        open var value : Any? = nil
        
        public let separator = NX.Separator{(_) in}
        open var layer : NX.Layer? = nil
        
        public required init(){
            super.init()
        }
        
        public init(completion:NX.Completion<NX.Appearance>?){
            super.init()
            completion?(self)
        }
    }
    
    open class Image : NX.View {
        open var color = NX.blackColor
        open var value : UIImage? = nil
        open var renderingMode = UIImage.RenderingMode.alwaysOriginal
        open var layer : NX.Layer? = nil
        public required init(){
            super.init()
        }
        
        public init(completion:NX.Completion<NX.Image>?){
            super.init()
            completion?(self)
        }
    }
    
    open class Attribute : NX.View {
        open var color = NX.blackColor
        
        open var textAlignment = NSTextAlignment.center
        open var numberOfLines: Int = 1
        open var lineSpacing : CGFloat = 2.5
        
        open var attributedString : NSAttributedString? = nil
        open var value = ""
        open var font = NX.font(15)
        
        open var image : UIImage? = nil
        open var renderingMode = UIImage.RenderingMode.alwaysOriginal
        open var layer : NX.Layer? = nil
        public required init(){
            super.init()
        }
        
        public init(completion:NX.Completion<NX.Attribute>?){
            super.init()
            completion?(self)
        }
        
        open class func contentHorizontalAlignment(_ textAlignment: NSTextAlignment) -> UIControl.ContentHorizontalAlignment {
            if textAlignment == .left {
                return UIControl.ContentHorizontalAlignment.left
            }
            else if textAlignment == .right {
                return UIControl.ContentHorizontalAlignment.right
            }
            return UIControl.ContentHorizontalAlignment.center
        }
    }
    
    open class Layer : NX.View {
        open var opacity : CGFloat = 0.0
        
        open var borderWidth : CGFloat = 0.0
        open var borderColor = NX.separatorColor
        
        open var shadowOpacity : CGFloat = 0.0
        open var shadowRadius : CGFloat = 0.0
        open var shadowOffset = CGSize.zero
        open var shadowColor = NX.shadowColor
        
        public required init(){
            super.init()
        }
        
        public init(completion:NX.Completion<NX.Layer>?){
            super.init()
            completion?(self)
        }
    }
    
    open class Separator : NX.View {
        open var insets = UIEdgeInsets.zero
        open var ats : NX.Ats = []
        
        public required init(){
            super.init()
            self.isHidden = true
            self.backgroundColor = NX.separatorColor
        }
        
        public init(completion:NX.Completion<NX.Separator>?){
            super.init()
            self.isHidden = true
            self.backgroundColor = NX.separatorColor
            completion?(self)
        }
    }
}

extension NX {
    open class Widget<View:UIView, Value:NXInitialValue>  {
        open var view = View()
        open var value = Value.initialValue
        
        public init(){
        }
        
        public init(completion:NX.Completion<NX.Widget<View, Value>>?){
            completion?(self)
        }
    }
}

extension NX.View {
    
    public class func update(_ metadata:NX.Appearance, _ view:UIView){
        view.backgroundColor = metadata.backgroundColor
        if let __layer = metadata.layer {
            view.layer.cornerRadius = __layer.cornerRadius
            view.layer.borderWidth = __layer.borderWidth
            view.layer.borderColor = __layer.borderColor.cgColor
        }
        else {
            view.layer.cornerRadius = metadata.cornerRadius
        }
    }

    public class func update(_ metadata:NX.Attribute, _ view:UIView){
        if metadata.isHidden {
            view.isHidden = true
            return
        }
        if let view = view as? UILabel {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            view.numberOfLines = metadata.numberOfLines
            if let attributedText = metadata.attributedString {
                view.attributedText = attributedText
            }
            else {
                view.text = metadata.value
                view.textColor = metadata.color
                view.font = metadata.font
            }
            view.textAlignment = metadata.textAlignment
            
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
        }
        else if let view = view as? UIButton {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            view.setImage(metadata.image, for: .normal)
            view.setTitle(metadata.value, for: .normal)
            view.setTitleColor(metadata.color, for: .normal)
            view.titleLabel?.font = metadata.font
            view.tintColor = metadata.color
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
            view.contentHorizontalAlignment = NX.Attribute.contentHorizontalAlignment(metadata.textAlignment)
        }
        else if let view = view as? UIImageView {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            if let image = metadata.image {
                view.image = image.withRenderingMode(metadata.renderingMode)
                view.tintColor = metadata.color
            }
            else if metadata.value.count > 0 {
                if metadata.value.hasPrefix("http") {
                    NX.image(view, metadata.value)
                }
                else {
                    view.image = UIImage(named: metadata.value)?.withRenderingMode(metadata.renderingMode)
                    view.tintColor = metadata.color
                }
            }
            else {
                view.image = nil
            }
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
        }
        else {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
        }
    }
}

extension NX {
    open class Wrappable<Key: NXInitialValue, OldValue:NXInitialValue, Value: NXInitialValue> {
        open var key = Key.initialValue
        open var oldValue = OldValue.initialValue
        open var value = Value.initialValue
        
        open var dispose : ((_ action:String, _ value:Any?, _ completion:NX.Event<String, NX.Wrappable<Key, OldValue, Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<NX.Wrappable<Key, OldValue, Value>>?) {
            completion?(self)
        }
    }
    
    open class Comparable<MinValue: NXInitialValue, MaxValue:NXInitialValue, Value: NXInitialValue> {
        open var minValue = MinValue.initialValue
        open var maxValue = MaxValue.initialValue
        open var value = Value.initialValue
        
        open var dispose : ((_ action:String, _ value:Any?, _ completion:NX.Event<String, NX.Comparable<MinValue, MaxValue, Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<NX.Comparable<MinValue, MaxValue, Value>>?) {
            completion?(self)
        }
    }
    
    open class Selectable<Value: NXInitialValue> {
        open var selected = Value.initialValue
        open var unselected = Value.initialValue
                    
        public init(completion: NX.Completion<NX.Selectable<Value>>?){
            completion?(self)
        }
    }
}



public protocol NXInitialValue {
    static var initialValue : Self { get }
}

extension Dictionary : NXInitialValue {
    public static var initialValue: Dictionary<Key, Value> {
        return Dictionary<Key, Value>()
    }
}

extension Array : NXInitialValue {
    public static var initialValue: Array<Element> {
        return Array<Element>()
    }
}

extension Set : NXInitialValue {
    public static var initialValue: Set<Element> {
        return Set<Element>()
    }
}

extension String : NXInitialValue {
    public static var initialValue: String {
        return ""
    }
}

extension Bool : NXInitialValue {
    public static var initialValue: Bool {
        return false
    }
}

extension CGPoint : NXInitialValue {
    public static var initialValue : CGPoint {
        return CGPoint.zero
    }
}

extension CGSize : NXInitialValue {
    public static var initialValue: CGSize {
        return CGSize.zero
    }
}

extension CGRect : NXInitialValue {
    public static var initialValue: CGRect {
        return CGRect.zero
    }
}

extension CGVector : NXInitialValue {
    public static var initialValue: CGVector {
        return CGVector.zero
    }
}

extension UIOffset : NXInitialValue {
    public static var initialValue: UIOffset {
        return UIOffset.zero
    }
}

extension UIEdgeInsets : NXInitialValue {
    public static var initialValue: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension CGAffineTransform : NXInitialValue {
    public static var initialValue: CGAffineTransform {
        return CGAffineTransform.identity
    }
}

extension CGFloat : NXInitialValue {
    public static var initialValue: CGFloat {
        return CGFloat.zero
    }
}

extension Int : NXInitialValue {
    public static var initialValue: Int {
        return 0
    }
}

extension Int8 : NXInitialValue {
    public static var initialValue: Int8 {
        return 0
    }
}

extension Int16 : NXInitialValue {
    public static var initialValue: Int16 {
        return 0
    }
}

extension Int32 : NXInitialValue {
    public static var initialValue: Int32 {
        return 0
    }
}

extension Int64 : NXInitialValue {
    public static var initialValue: Int64 {
        return 0
    }
}

extension Float : NXInitialValue {
    public static var initialValue: Float {
        return Float.zero
    }
}

@available(iOS 14.0, watchOS 7.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
extension Float16 : NXInitialValue {
    public static var initialValue: Float16 {
        return Float16.zero
    }
}

extension Double : NXInitialValue {
    public static var initialValue: Double {
        return Double.zero
    }
}

extension NSTextAlignment : NXInitialValue {
    public static var initialValue: NSTextAlignment {
        return NSTextAlignment.center
    }
}

extension UIControl.ContentVerticalAlignment : NXInitialValue {
    public static var initialValue: UIControl.ContentVerticalAlignment {
        return UIControl.ContentVerticalAlignment.center
    }
}

extension UIControl.ContentHorizontalAlignment : NXInitialValue {
    public static var initialValue: UIControl.ContentHorizontalAlignment {
        return UIControl.ContentHorizontalAlignment.center
    }
}

extension UIGestureRecognizer.State : NXInitialValue {
    public static var initialValue: UIGestureRecognizer.State {
        return UIGestureRecognizer.State.possible
    }
}

extension CMTime : NXInitialValue {
    public static var initialValue: CMTime {
        return CMTime.zero
    }
}

extension CMTimeRange : NXInitialValue {
    public static var initialValue: CMTimeRange {
        return CMTimeRange(start: CMTime.initialValue, end: CMTime.initialValue)
    }
}


extension Data : NXInitialValue {
    public static var initialValue: Data {
        return Data()
    }
}

extension UIColor : NXInitialValue {
    public static var initialValue: Self {
        return UIColor.clear as! Self
    }
}

extension UIFont : NXInitialValue {
    public static var initialValue: Self {
        return UIFont.systemFont(ofSize: 15) as! Self
    }
}

extension UIImage : NXInitialValue {
    public static var initialValue: Self {
        return UIImage() as! Self
    }
}

extension Date : NXInitialValue {
    public static var initialValue: Date {
        return Date()
    }
}

extension NSNumber : NXInitialValue {
    public static var initialValue: Self {
        return NSNumber(value: 0) as! Self
    }
}

extension NX.Appearance : NXInitialValue {
    public static var initialValue: Self {
        return NX.Appearance() as! Self
    }
}

extension NX.Attribute : NXInitialValue {
    public static var initialValue: Self {
        return NX.Attribute() as! Self
    }
}

extension NX.Layer : NXInitialValue {
    public static var initialValue: Self {
        return NX.Layer() as! Self
    }
}

extension NX.Separator : NXInitialValue {
    public static var initialValue: Self {
        return NX.Separator() as! Self
    }
}

extension UIImage.RenderingMode: NXInitialValue {
    public static var initialValue: Self {
        return UIImage.RenderingMode.alwaysOriginal
    }
}
