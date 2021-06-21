//
//  LEYApp.swift
//  NXFoundation
//
//  Created by firelonely on 2019/1/23.
//  Copyright © 2019年 无码科技. All rights reserved.
//

import UIKit
import WebKit

//应用程序信息
open class LEYApp {
    static public let infoDictionary = Bundle.main.infoDictionary ?? [:]
    static public let namespace = LEYApp.infoDictionary["CFBundleExecutable"] as? String ?? ""
    static public let name = LEYApp.infoDictionary["CFBundleDisplayName"] as? String ?? ""
    static public let version = LEYApp.infoDictionary["CFBundleShortVersionString"] as? String ?? ""
    static public let build = LEYApp.infoDictionary["CFBundleVersion"] as? String ?? ""
    static public let isViewControllerBasedStatusBarAppearance = LEYApp.get(bool: LEYApp.infoDictionary["UIViewControllerBasedStatusBarAppearance"] as? Bool, true)
    static public var isSeparatorHidden = false
    
    public typealias Completion<Action, Value> = (_ action:Action, _ value:Value)  -> ()
}


//空页面加载动画类型
extension LEYApp {
    open class Animation {
        static public var animationClass : LEYAnimationWrappedView.Type = LEYAnimationWrappedView.self
    }
}


//内容横向纵向边缘缩进
extension LEYApp {
    static public var insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    
    public struct Side : OptionSet {
        public let rawValue : Int
        public init(rawValue:Int) {
            self.rawValue = rawValue
        }
        
        public static var top =  LEYApp.Side(rawValue: 1)
        public static var left = LEYApp.Side(rawValue: 2)
        public static var bottom = LEYApp.Side(rawValue: 4)
        public static var right = LEYApp.Side(rawValue: 8)
    }
    
    public enum AT : Int {
        case unspecified = 0

        case center = 10
        
        case minX = 11
        case maxX = 12

        case minY = 13
        case maxY = 14
    }
    
    open class Rect {
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
        
        public init(completion: LEYApp.Completion<String, LEYApp.Rect>?){
            completion?("", self)
        }
        
        
        public enum Side : Int {
            case unspefified = 0
            case center = 10
            case minX = 11
            case maxX = 12
            case minY = 13
            case maxY = 14
        }
    }
}

extension LEYApp {
    open class func scale(size:CGSize, to:CGSize, mode:UIView.ContentMode) -> CGRect {
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


//状态栏效果
extension LEYApp {
    final public class UI {
        //用户可选的暗黑模式的类型-枚举
        public enum Value : String {
            case unspecified = "unspecified"
            case light = "light"
            case dark = "dark"
        }
        
        //用户设定的暗黑模式类型
        static public private(set) var setupValue = LEYApp.UI.Value.light
        public class func setup(_ action: String, _ newValue: LEYApp.UI.Value){
            LEYApp.UI.setupValue = newValue
        }
        
        public class var currentValue : LEYApp.UI.Value {
            if LEYApp.UI.setupValue == LEYApp.UI.Value.light {
                return LEYApp.UI.Value.light
            }
            else if LEYApp.UI.setupValue == LEYApp.UI.Value.dark {
                if #available(iOS 13.0, *) {
                    return LEYApp.UI.Value.dark
                }
                return LEYApp.UI.Value.light
            }
            else {
                if #available(iOS 13.0, *) {
                    if UITraitCollection.current.userInterfaceStyle == .dark {
                        return LEYApp.UI.Value.dark
                    }
                }
                return LEYApp.UI.Value.light
            }
        }
    }

    final public class Bar {
        //管理状态栏的样式
        public enum Value : String {
            case none = "none"
            case hidden = "hidden"
            case unspecified = "unspecified"
            case light = "light"
            case dark = "dark"
        }
                
        static public private(set) var currentValue = LEYApp.Bar.Value.none
        static public private(set) var currentOrientation = UIInterfaceOrientation.portrait
        
        public class func update(_ newValue: LEYApp.Bar.Value, _ animated:Bool = true){
            if LEYApp.isViewControllerBasedStatusBarAppearance {
                if newValue !=  .none {
                    LEYApp.Bar.currentValue = newValue
                }
            }
            else {
                if newValue == LEYApp.Bar.Value.hidden {
                    LEYApp.Bar.currentValue = newValue
                    UIApplication.shared.isStatusBarHidden = true
                }
                else if newValue == LEYApp.Bar.Value.unspecified {
                    LEYApp.Bar.currentValue = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: animated)
                }
                else if newValue == LEYApp.Bar.Value.light {
                    LEYApp.Bar.currentValue = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: animated)
                }
                else if newValue == LEYApp.Bar.Value.dark {
                    LEYApp.Bar.currentValue = newValue
                    UIApplication.shared.isStatusBarHidden = false
                    if #available(iOS 13.0, *) {
                        if LEYApp.UI.currentValue == LEYApp.UI.Value.dark {
                            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: animated)
                        }
                        else {
                            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.darkContent, animated: animated)
                        }
                    }
                    else{
                        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: animated)
                    }
                }
            }
        }
    }
}


// 颜色和字体
extension LEYApp {
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
        return LEYApp.font(size, blod)
    }
}

extension LEYApp {
    
    //颜色:rgb+alpha, rgb:[0,255],a:[0,1]
    public class func color(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat = 1.0) -> UIColor{
        return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
    }
    
    //颜色：hex+alpha
    public class func color(_ hex:Int, _ a: CGFloat = 1.0) -> UIColor {
        return LEYApp.color(((CGFloat)((hex & 0xFF0000) >> 16)), ((CGFloat)((hex & 0xFF00) >> 8)), ((CGFloat)(hex & 0xFF)), a)
    }
    
    //创建浅色/暗黑模式的颜色
    public class func color(_ lightColor:UIColor, _ darkColor:UIColor? = nil) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (__collection) -> UIColor in
                if let __darkColor = darkColor, LEYApp.UI.currentValue == LEYApp.UI.Value.dark {
                    return __darkColor
                }
                return lightColor
            }
        }
        return lightColor;
    }
    //window背景色
    static public var windowBackgroundColor = LEYApp.color(247, 247, 247)
    //view背景色
    static public var viewBackgroundColor = LEYApp.color(247, 247, 247)
    //contentView背景色
    static public var contentViewBackgroundColor = LEYApp.color(247, 247, 247)
    //tableView背景色
    static public var tableViewBackgroundColor = LEYApp.color(247, 247, 247)
    //collectionView背景色
    static public var collectionViewBackgroundColor = LEYApp.color(247, 247, 247)
    //overlay背景色
    static public var overlayBackgroundColor = LEYApp.color(255, 225, 225)
    //背景色
    static public var backgroundColor = LEYApp.color(255, 255, 255)
    //选中背景色
    static public var selectedBackgroundColor = LEYApp.color(218.0, 218.0, 218.0, 0.3)
    //分割线颜色
    static public var separatorColor = LEYApp.color(235, 235, 240)
    //阴影颜色
    static public var shadowColor = LEYApp.color(56, 79, 134)
    // 主色
    static public var mainColor = LEYApp.color(51, 120, 246)
    // 深黑
    static public var darkBlackColor = LEYApp.color(51, 51, 51)
    // 浅黑
    static public var lightBlackColor = LEYApp.color(102, 102, 102)
    // 深灰
    static public var darkGrayColor = LEYApp.color(153, 153, 153)
    // 浅灰
    static public var lightGrayColor = LEYApp.color(192, 192, 192)
    // 转场前容器视图的Alpha值
    static public var minAlphaOfColor = UIColor.black.withAlphaComponent(0.01)
    // 转场后容器视图的Alpha值
    static public var maxAlphaOfColor = UIColor.black.withAlphaComponent(0.30)
}

extension LEYApp {
    public static var isLoggable : Bool = true
    
    public class func print(_ items:Any?, _ file:String = #file, _ method: String = #function, _ line: Int = #line) {
        guard LEYApp.isLoggable, let value = items else {
            return
        }
        Swift.print("\((file as NSString).lastPathComponent)[\(line)],\(method):\n\(value)\n")
    }
    
    public class func log(_ file:String = #file, _ method: String = #function, _ line: Int = #line, _ get:(()->(Any?))?){
        guard LEYApp.isLoggable, let value = get?() else {
            return
        }
        let format = "YYYY-MM-dd HH:mm:ss SSS"
        let time = getCurrentTime(format)
        Swift.print("\((file as NSString).lastPathComponent)[\(line)],\(method):--💚💚\(time)--\n\(value)\n")
    }
    
    public class func error(_ file:String = #file, _ method: String = #function, _ line: Int = #line, _ get:(()->(Any?))?){
        guard LEYApp.isLoggable, let value = get?() else {
            return
        }
        let format = "YYYY-MM-dd HH:mm:ss SSS"
        let time = getCurrentTime(format)
        Swift.print("\((file as NSString).lastPathComponent)[\(line)],\(method):--💔💔\(time)--\n\(value)\n")
    }
    
    public class func warn(_ file:String = #file, _ method: String = #function, _ line: Int = #line, _ get:(()->(Any?))?){
        guard LEYApp.isLoggable, let value = get?() else {
            return
        }
        let format = "YYYY-MM-dd HH:mm:ss SSS"
        let time = getCurrentTime(format)
        Swift.print("\((file as NSString).lastPathComponent)[\(line)],\(method):--💛💛\(time)--\n\(value)\n")
    }
}


// 图片
extension LEYApp {
    
    public class Asset {
        //默认使用的bundle图片的path
        static public var path = Bundle(for: LEYApp.self).bundlePath + "/LEYFoundation.bundle/"

        //处理图片浏览
        static public var showAssets:((_ type:String, _ assets:[Any]) -> ())?
        
        //设置url
        static public var image : ((_ targetView: UIView?, _ url:String, _ state:UIControl.State) -> ())?
    }
    
    //加载获取bundle中图片
    public class func image(named name:String, _ scale:Int = Int(UIScreen.main.scale)) -> UIImage? {
        guard name.count > 0 else {return nil}

        var __name = name
        if LEYApp.Asset.path.count > 0 {
            if __name.contains("@2x.") || __name.contains("@3x.")  {
                
            }
            else {
                if scale == 2 || scale == 3 {
                    __name = __name.replacingOccurrences(of: ".png", with: "@\(scale)x.png")
                }
            }
            __name = LEYApp.Asset.path + __name
        }
        return UIImage(named: __name)
    }
    
    //处理图片浏览
    class public func showAssets(type:String, assets:[Any]){
        LEYApp.Asset.showAssets?(type, assets)
    }
    
    //设置图像
    open class func image(_ targetView:UIView?, _ url:String, _ state:UIControl.State = UIControl.State.normal){
        LEYApp.Asset.image?(targetView, url, state)
    }
}

extension LEYApp {
    
    public class Codable {
        //进行urlcomponent编码的字符
        static public var characters = "!*'();:@&=+$,/?%#[]{}\"\\"
        
        //encodeURIComponent
        static public var encodeURIComponent:((_ uri:String) -> (String))?
        
        //decodeURIComponent
        static public var decodeURIComponent:((_ uri:String) -> (String))?
    }
    
    //encodeURIComponent
    class public func encodeURIComponent(_ uri:String) -> String? {
        if LEYApp.Codable.encodeURIComponent != nil {
            return LEYApp.Codable.encodeURIComponent?(uri)
        }
        /*!*'();:@&=+$,/?%#[]{}   增加了对"和\ --> !*'();:@&=+$,/?%#[]{}\"\\ */
        let allowedCharacters = CharacterSet(charactersIn: LEYApp.Codable.characters).inverted
        let retValue = uri.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        return retValue ?? ""
    }
    
    //decodeURIComponent
    class public func decodeURIComponent(_ uri:String) -> String {
        if LEYApp.Codable.decodeURIComponent != nil {
            return LEYApp.Codable.decodeURIComponent?(uri) ?? uri
        }
        let retValue = uri.removingPercentEncoding
        return retValue ?? ""
    }
}


//网页/导航中的相关配置
extension LEYApp {
    public class URI {
        //根据scheme处理
        //使用LEYSerialization生成actionURL时带的前缀
        static public var scheme = ""
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
}

extension LEYApp {
    //授权
    open class Authorize {
        //授权的回调
        static public var authorization:((_ type: LEYApp.AuthorizeType, _ queue:DispatchQueue, _ isAlertable: Bool, _ completion:((LEYApp.AuthorizeState) -> ())?) ->())?
    }
    
    //授权类型
    public enum AuthorizeType {
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
    
    //获取授权/请求授权入口
    open class func authorization(_ type: LEYApp.AuthorizeType, _ queue:DispatchQueue, _ isAlertable: Bool, _ completion:((LEYApp.AuthorizeState) -> ())?){
        LEYApp.Authorize.authorization?(type, queue, isAlertable, completion)
    }
}

extension LEYApp {
    public class Web {
        
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
        
        //这里处理网页中回调的js桥接
        static public var webView : ((_ action:String, _ contentView: WKWebView, _ value:[String:Any],  _ viewController:LEYWebViewController?) -> Bool)?
    }
    
    //这里处理网页中回调的js桥接
    @discardableResult
    class public func dispose(_ action:String, _ webView:WKWebView, _ value:[String:Any], _ viewController:LEYWebViewController?) -> Bool? {
        return LEYApp.Web.webView?(action, webView, value, viewController)
    }
}

extension LEYApp {
    public class Table {
        static public var tableViewStyle = UITableView.Style.grouped
        static public var separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        //这里处理单元格高度的通过autoLayout计算的一种回调
        static public var tableView : ((_ tableView: UITableView?, _ value:LEYItem, _ indexPath:IndexPath) -> CGFloat)?
    }
    
    //这里处理单元格高度的通过autoLayout计算的一种回调
    class public func heightForRow(_ tableView:UITableView?, _ value:LEYItem, _ indexPath:IndexPath) -> CGFloat? {
        return LEYApp.Table.tableView?(tableView, value, indexPath)
    }
}

extension LEYApp {
    public class Overlay {
        //alert/action的单元格最大宽度、高度
        static public var size = CGSize(width: LEYDevice.width*0.8, height: 48.0)
        //处理toast
        static public var showToast:((_ message:String, _ at:LEYApp.AT , _ superview:UIView?) -> ())?
        
        //处理animation
        static public var showAnimation:((_ message:String, _ superview:UIView?) -> ())?
        
        //处理toast
        static public var hideAnimation:((_ superview:UIView?) -> ())?
    }
    
    //处理图片浏览
    class public func showToast(message:String, _ at:LEYApp.AT = .center , _ superview:UIView? = UIApplication.shared.keyWindow){
        LEYApp.Overlay.showToast?(message, at, superview)
    }
    
    //处理animation
    class public func showAnimation(_ message:String, _ superview:UIView? = UIApplication.shared.keyWindow){
        LEYApp.Overlay.showAnimation?(message, superview)
    }
    
    //处理toast
    class public func hideAnimation(superview:UIView? = UIApplication.shared.keyWindow){
        LEYApp.Overlay.hideAnimation?(superview)
    }
}

extension LEYApp {
    public class Placeholder {
        static public var frame = CGRect(x: 0, y: 0, width: 320, height: 256)
        
        static public var m = LEYApp.Attribute { (_, __sender) in
            __sender.frame = CGRect(x: 0, y: 0, width: 320, height: 170)
        }
        
        static public var t = LEYApp.Attribute { (_, __sender) in
            __sender.frame = CGRect(x: 0, y: 175, width: 320, height: 55)
            __sender.value = "暂无数据～"
            __sender.textAlignment = .center
            __sender.numberOfLines = 0
            __sender.font = LEYApp.font(16)
            __sender.color = LEYApp.darkGrayColor
        }
    }
}

extension LEYApp {
    open class func get(dictionary:[String:Any]?, _ nonnullValue:[String:Any] = [:]) -> [String:Any] {
        if let __value = dictionary, __value.count > 0 {
            return __value
        }
        return nonnullValue
    }
    
    open class func get(array:[Any]?, _ nonnullValue:[Any] = []) -> [Any] {
        if let __value = array, __value.count > 0 {
            return __value
        }
        return nonnullValue
    }
    
    open class func get(string:String?, _ nonnullValue:String = "") -> String {
        if let __value = string, __value.count > 0 {
            return __value
        }
        return nonnullValue
    }
    
    open class func get(int:Int?, _ nonnullValue:Int = 0) -> Int {
        if let __value = int {
            return __value
        }
        return nonnullValue
    }
    
    open class func get(float:CGFloat?, _ nonnullValue:CGFloat = 0.0) -> CGFloat {
        if let __value = float {
            return __value
        }
        return nonnullValue
    }
    
    open class func get(bool:Bool?, _ nonnullValue:Bool = false) -> Bool {
        if let __value = bool {
            return __value
        }
        return nonnullValue
    }
    
    open class func get<T:Equatable>(value:T?, _ nonnullValue:T) -> T {
        if let __value = value {
            return __value
        }
        return nonnullValue
    }
}
