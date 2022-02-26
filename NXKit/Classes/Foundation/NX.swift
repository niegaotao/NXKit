//
//  NX.swift
//  NXKit
//
//  Created by niegaotao on 2020/1/23.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit
import WebKit

//应用程序信息
open class NX {
    static public let infoDictionary = Bundle.main.infoDictionary ?? [:]
    static public let namespace = NX.infoDictionary["CFBundleExecutable"] as? String ?? ""
    static public let name = NX.infoDictionary["CFBundleDisplayName"] as? String ?? ""
    static public let version = NX.infoDictionary["CFBundleShortVersionString"] as? String ?? ""
    static public let build = NX.infoDictionary["CFBundleVersion"] as? String ?? ""
    static public let isViewControllerBasedStatusBarAppearance = NX.get(bool: NX.infoDictionary["UIViewControllerBasedStatusBarAppearance"] as? Bool, true)
    
    public typealias Completion<Action, Value> = (_ action:Action, _ value:Value)  -> ()
}

//内容横向纵向边缘缩进
extension NX {
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
        
        public override init(){
            super.init()
        }
        
        public init(completion: NX.Completion<String, NX.Rect>?){
            super.init()
            completion?("init", self)
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
        
        public static var minX = NX.Ats(rawValue: 1)        //2^0
        public static var centerX = NX.Ats(rawValue: 2)     //2^1
        public static var maxX = NX.Ats(rawValue: 4)        //2^2
        
        public static var minY =  NX.Ats(rawValue: 16)      //2^4
        public static var centerY =  NX.Ats(rawValue: 32)   //2^5
        public static var maxY = NX.Ats(rawValue: 64)       //2^6
        
        public static var center = NX.Ats(rawValue: 256)    //2^8
    }
}

extension NX {
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



extension NX {
    //view背景色
    static public var viewBackgroundColor = NX.color(247, 247, 247)
    //contentView背景色
    static public var contentViewBackgroundColor = NX.color(247, 247, 247)
    //tableView背景色
    static public var naviViewBackgroundColor = NX.color(255, 255, 255)
    //tableView背景色
    static public var naviViewForegroundColor = NX.color(51, 51, 51)
    //tableView背景色
    static public var tableViewBackgroundColor = NX.color(247, 247, 247)
    //collectionView背景色
    static public var collectionViewBackgroundColor = NX.color(247, 247, 247)
    //overlay背景色
    static public var overlayBackgroundColor = NX.color(255, 225, 225)
    //背景色
    static public var backgroundColor = NX.color(255, 255, 255)
    //选中背景色
    static public var selectedBackgroundColor = NX.color(218.0, 218.0, 218.0, 0.3)
    //分割线颜色
    static public var separatorColor = NX.color(235, 235, 240)
    //阴影颜色
    static public var shadowColor = NX.color(56, 79, 134)
    // 主色
    static public var mainColor = NX.color(51, 120, 246)
    // 深黑
    static public var darkBlackColor = NX.color(51, 51, 51)
    // 浅黑
    static public var lightBlackColor = NX.color(102, 102, 102)
    // 深灰
    static public var darkGrayColor = NX.color(153, 153, 153)
    // 浅灰
    static public var lightGrayColor = NX.color(192, 192, 192)
    // 转场前容器视图的Alpha值
    static public var minAlphaOfColor = UIColor.black.withAlphaComponent(0.01)
    // 转场后容器视图的Alpha值
    static public var maxAlphaOfColor = UIColor.black.withAlphaComponent(0.30)
    
    //用户设定的暗黑模式类型
    static private(set) var __userInterfaceStyle = NX.Color.light
    static public var userInterfaceStyle : NX.Color {
        set{
            __userInterfaceStyle = newValue
        }
        get{
            if __userInterfaceStyle == NX.Color.light {
                return NX.Color.light
            }
            else if __userInterfaceStyle == NX.Color.dark {
                if #available(iOS 13.0, *) {
                    return NX.Color.dark
                }
                return NX.Color.light
            }
            else {
                if #available(iOS 13.0, *) {
                    if UITraitCollection.current.userInterfaceStyle == .dark {
                        return NX.Color.dark
                    }
                }
                return NX.Color.light
            }
        }
    }
    
    //初始化的状态栏样式
    static private(set) var __statusBarStyle = NX.Bar.dark
    static public var statusBarStyle : NX.Bar {
        set{
            if NX.isViewControllerBasedStatusBarAppearance {
                if newValue !=  .none {
                    __statusBarStyle = newValue
                }
            }
            else {
                if newValue == NX.Bar.hidden {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = true
                }
                else if newValue == NX.Bar.unspecified {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
                }
                else if newValue == NX.Bar.light {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
                }
                else if newValue == NX.Bar.dark {
                    __statusBarStyle = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    if #available(iOS 13.0, *) {
                        if userInterfaceStyle == NX.Color.dark {
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
        case update      //下拉刷新
        case more        //上拉加载更多
    }
        
    static public var AnimationClass : NXAnimationWrappedView.Type = NXAnimationWrappedView.self //空页面加载动画类型
    static public var HUDAnimationClass : NXAnimationWrappedView.Type = NXAnimationWrappedView.self//loading
    
    static public var isSeparatorHidden = false
}


// 颜色和字体
extension NX {
    //颜色:rgb+alpha, rgb:[0,255],a:[0,1]
    public class func color(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat = 1.0) -> UIColor {
        return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
    }
    
    //颜色：hex+alpha
    public class func color(_ hex:Int, _ a: CGFloat = 1.0) -> UIColor {
        return NX.color(((CGFloat)((hex & 0xFF0000) >> 16)), ((CGFloat)((hex & 0xFF00) >> 8)), ((CGFloat)(hex & 0xFF)), a)
    }
    
    //创建浅色/暗黑模式的颜色
    public class func color(_ lightColor:UIColor, _ darkColor:UIColor? = nil) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (__collection) -> UIColor in
                if let __darkColor = darkColor, NX.userInterfaceStyle == NX.Color.dark {
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
        return NX.font(size, blod)
    }
}

extension NX {
    public static var isLoggable : Bool = true
    
    public class func print(_ items:Any?, _ file:String = #file, _ method: String = #function, _ line: Int = #line) {
        guard NX.isLoggable, let value = items else {
            return
        }
        Swift.print("\((file as NSString).lastPathComponent)[\(line)],\(method):\n\(value)\n")
    }
    
    public class func log(_ get:(() -> Any?)?, _ file:String = #file, _ method: String = #function, _ line: Int = #line){
        guard NX.isLoggable, let value = get?() else {
            return
        }
        let time = NX.descriptionOf(date: Date(), format: "YYYY-MM-dd HH:mm:ss SSS")
        Swift.print("\((file as NSString).lastPathComponent)[\(line)],\(method):--💚💚\(time)--\n\(value)\n")
    }
    
    //yyyy-MM-dd HH:mm
    class public func descriptionOf(date:Date, format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}


extension NX {
    //占位图
    public class Placeholder {
        static public var frame = CGRect(x: 0, y: 0, width: 320, height: 256)
        
        static public var m = NX.Attribute { (_, __sender) in
            __sender.frame = CGRect(x: 0, y: 0, width: 320, height: 170)
        }
        
        static public var t = NX.Attribute { (_, __sender) in
            __sender.frame = CGRect(x: 0, y: 175, width: 320, height: 55)
            __sender.value = "暂无数据～"
            __sender.textAlignment = .center
            __sender.numberOfLines = 0
            __sender.font = NX.font(16)
            __sender.color = NX.darkGrayColor
        }
    }
    
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
        
        static public var tableViewStyle = UITableView.Style.grouped
        static public var separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //alert/action的单元格最大宽度、高度
        static public var size = CGSize(width: NXUI.width*0.8, height: 48.0)
    }
    
    public class Imp {
        //处理图片浏览
        static public var previewAssets:((_ type:String, _ assets:[Any]) -> ())?
        
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
        static public var showToast:((_ message:String, _ ats:NX.Ats , _ superview:UIView?) -> ())?
        
        //处理animation
        static public var showLoading:((_ message:String, _ ats:NX.Ats, _ superview:UIView?) -> ())?
        
        //处理toast
        static public var hideLoading:((_ superview:UIView?) -> ())?
        
        //处理网络请求
        static public var request:((_ request:NXRequestProtocol, _ completion:NX.Completion<String, NXRequestProtocol>?) -> ())?
    }
}


// 图片
extension NX {
    //加载获取bundle中图片
    public class func image(named name:String) -> UIImage? {
        guard name.count > 0 else {return nil}
        if NX.Association.root.count > 0 {
            return UIImage(named: "\(NX.Association.root)/NXKit.bundle/NX.bundle/\(name)")
        }
        return UIImage(named: name)
    }
    
    //处理图片浏览
    class public func previewAssets(type:String, assets:[Any]){
        NX.Imp.previewAssets?(type, assets)
    }
    
    //设置图像
    class public func image(_ targetView:UIView?, _ url:String, _ state:UIControl.State = UIControl.State.normal){
        NX.Imp.image?(targetView, url, state)
    }

    //encodeURIComponent
    class public func encodeURIComponent(_ uri:String) -> String? {
        if NX.Imp.encodeURIComponent != nil {
            return NX.Imp.encodeURIComponent?(uri)
        }
        /*!*'();:@&=+$,/?%#[]{}   增加了对"和\ --> !*'();:@&=+$,/?%#[]{}\"\\ */
        return String.encodeURIComponent(uri)
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
    
    //toast
    class public func showToast(message:String, _ ats:NX.Ats = .center, _ superview:UIView? = UIApplication.shared.keyWindow){
        if let handler = NX.Imp.showToast {
            handler(message, ats, superview)
        }
        else {
            (superview ?? UIApplication.shared.keyWindow)?.makeToast(message: message, ats: ats)
        }
    }
    
    //处理loading
    class public func showLoading(_ message:String, _ ats:NX.Ats = .center, _ superview:UIView? = UIApplication.shared.keyWindow){
        if let handler = NX.Imp.showLoading {
            handler(message, ats, superview)
        }
        else {
            (superview ?? UIApplication.shared.keyWindow)?.makeLoading(message: message, ats: ats)
        }
    }
    
    //处理loading
    class public func hideLoading(superview:UIView? = UIApplication.shared.keyWindow){
        if let handler = NX.Imp.hideLoading {
            handler(superview)
        }
        else {
            (superview ?? UIApplication.shared.keyWindow)?.hideLoading()
        }
    }
    
    //request
    class public func request(_ request:NXRequestProtocol, _ completion:NX.Completion<String, NXRequestProtocol>?) {
        NX.Imp.request?(request, completion)
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
