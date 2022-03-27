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
        
        public required init(){
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
        public static var Xs = NX.Ats(rawValue: 7)          //2^0+2^1+2^2

        public static var minY =  NX.Ats(rawValue: 16)      //2^4
        public static var centerY =  NX.Ats(rawValue: 32)   //2^5
        public static var maxY = NX.Ats(rawValue: 64)       //2^6
        public static var Ys = NX.Ats(rawValue: 112)        //2^4+2^5+2^6

        public static var center = NX.Ats(rawValue: 34)    //2^1+2^5
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
        case update      //下拉刷新
        case more        //上拉加载更多
    }
}




extension NX {
    public static var isLoggable : Bool = true
    private static let formatter = DateFormatter()
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
        static public var size = CGSize(width: NXUI.width*0.8, height: 48.0)
    }
    
    public class Imp {
        //处理图片浏览
        static public var previewAssets:((_ type:String, _ assets:[Any], _ index:Int) -> ())?
        
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
        static public var request:((_ request:NXRequest, _ completion:NX.Completion<String, NXRequest>?) -> ())?
    }
}


// 图片
extension NX {
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
        open var backgroundColor = NXUI.backgroundColor
        public required init() {
            super.init()
        }
    }
    
    open class Appearance : NX.View {
        open var selectedBackgroundColor = NXUI.selectedBackgroundColor
        open var isHighlighted = false
        open var isEnabled = true
        open var isCloseable = true
        
        open var value : Any? = nil
        
        public let separator = NX.Separator{(_,_) in}
        
        open var cornerRadius : CGFloat = 0
        open var layer : NX.Layer? = nil

        public required init(){
            super.init()
        }
        
        public init(completion:NX.Completion<String, NX.Appearance>?){
            super.init()
            completion?("init", self)
        }
    }

    open class Attribute : NX.View {
        open var color = NXUI.darkBlackColor
        open var textAlignment = NSTextAlignment.center
        open var numberOfLines: Int = 1
        open var lineSpacing : CGFloat = 2.5
        open var isAttributed : Bool = false
        open var value = ""
        open var font = NXUI.font(15)
        
        open var image : UIImage? = nil
        
        open var cornerRadius : CGFloat = 0
        open var layer : NX.Layer? = nil
        
        public required init(){
            super.init()
        }
        
        public init(completion:NX.Completion<String, NX.Attribute>?){
            super.init()
            completion?("init", self)
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
        open var masksToBounds : Bool = false
        open var cornerRadius : CGFloat = 0.0
        
        open var borderWidth : CGFloat = 0.0
        open var borderColor = NXUI.separatorColor
        
        open var shadowOpacity : CGFloat = 0.0
        open var shadowRadius : CGFloat = 0.0
        open var shadowOffset = CGSize.zero
        open var shadowColor = NXUI.shadowColor
        
        public required init(){
            super.init()
        }
        
        public init(completion:NX.Completion<String, NX.Layer>?){
            super.init()
            completion?("init", self)
        }
    }
    
    open class Separator : NX.View {
        open var insets = UIEdgeInsets.zero
        open var ats : NX.Ats = []
        
        public required init(){
            super.init()
            self.isHidden = true
            self.backgroundColor = NXUI.separatorColor
        }
        
        public init(completion:NX.Completion<String, NX.Separator>?){
            super.init()
            self.isHidden = true
            self.backgroundColor = NXUI.separatorColor
            completion?("init", self)
        }
    }
}

extension NX {
    open class Widget<View:UIView, Value:NXInitialValue>  {
        open var view = View()
        open var value = Value.initialValue
        
        public init(){
        }
        
        public init(completion:NX.Completion<String, NX.Widget<View, Value>>?){
            completion?("init", self)
        }
    }
}

extension NX.View {
    
    open class func update(_ metadata:NX.Appearance, _ view:UIView){
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

    open class func update(_ metadata:NX.Attribute, _ view:UIView){
        if metadata.isHidden {
            view.isHidden = true
            return
        }
        if let view = view as? UILabel {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            view.numberOfLines = metadata.numberOfLines
            if metadata.isAttributed {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = metadata.lineSpacing
                let attributedText = NSAttributedString(string: metadata.value,
                                                        attributes: [NSAttributedString.Key.font:metadata.font,
                                                                     NSAttributedString.Key.foregroundColor:metadata.color,
                                                                     NSAttributedString.Key.paragraphStyle:paragraph])
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
                view.image = image
            }
            else if metadata.value.count > 0 {
                if metadata.value.hasPrefix("http") {
                    NXUI.image(view, metadata.value)
                }
                else {
                    view.image = UIImage(named: metadata.value)
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
    
    open class Disposeable<Value:Any>{
        open var value : Value? = nil
        open var dispose : ((_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Disposeable<Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<String, NX.Disposeable<Value>>?) {
            completion?("", self)
        }
    }
    
    open class Wrappable<Key: NXInitialValue, OldValue:NXInitialValue, Value: NXInitialValue> {
        open var key = Key.initialValue
        open var oldValue = OldValue.initialValue
        open var value = Value.initialValue
        
        open var dispose : ((_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Wrappable<Key, OldValue, Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<String, NX.Wrappable<Key, OldValue, Value>>?) {
            completion?("", self)
        }
    }
    
    open class Comparable<Minimum: NXInitialValue, Maximum:NXInitialValue, Value: NXInitialValue> {
        open var minValue = Minimum.initialValue
        open var maxValue = Maximum.initialValue
        open var value = Value.initialValue
        
        open var dispose : ((_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Comparable<Minimum, Maximum, Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<String, NX.Comparable<Minimum, Maximum, Value>>?) {
            completion?("", self)
        }
    }
    
    open class Selectable<Value: NXInitialValue> {
        open var selected = Value.initialValue
        open var unselected = Value.initialValue
                    
        public init(completion: NX.Completion<String, NX.Selectable<Value>>?){
            completion?("", self)
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






