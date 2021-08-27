//
//  NXWebView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/30.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore


open class NXWebView: WKWebView {
    open var ctxs : WKWebViewConfiguration?
    
    //派发一个操作的回调 isCompleted表示表示是否已经处理完成，第二次调用传值为true已经完成
    open var dispatchWithValue : ((_ value:[String:Any], _ isDisposed:Bool) -> ())? = nil
    //这个函数主要处理:本模块没有实现的特殊的回调需求
    open var callbackWithValue : ((_ value:[String:Any]) -> ())? = nil
    //临时导航:action=start-false-nil/redirect/result
    open var callbackWithProvisionalNavigation : ((_ navigation: WKNavigation, _ action:String, _ isCompleted:Bool, _ error:Error?) -> ())? = nil
    //导航:action=start-false-nil/result
    open var callbackWithNavigation: ((_ navigation: WKNavigation, _ action:String, _ isCompleted:Bool, _ error:Error?) -> ())? = nil
    
    //弹框的处理:actions表示一个或者多个按钮
    open var callbackWithAlert:((_ text:String, _ actions:[String], _  completion: @escaping NX.Completion<String, Int>) -> ())? = nil
    //重定向判断
    open var navigationAction:((_ navigation:WKNavigationAction, _ completion: @escaping NX.Completion<String, WKNavigationActionPolicy>) -> ())? = nil
    //重定向响应
    open var navigationResponse:((_ navigation:WKNavigationResponse, _ completion: @escaping NX.Completion<String, WKNavigationResponsePolicy>) -> ())? = nil
    //被持有的viewcontroller
    open weak var attachedViewController : NXWebViewController? = nil
    //内部处理代理的类
    open var wrapped : NXWebView.Wrapped? = nil
    
    public convenience init(frame:CGRect) {
        let __wrapped = NXWebView.Wrapped()
        
        let __config = WKWebViewConfiguration()
        if #available(iOS 11.0, *) {
            for scheme in NX.Association.schemes {
                __config.setURLSchemeHandler(__wrapped, forURLScheme: scheme)
            }
        }
        __config.allowsInlineMediaPlayback = true
        __config.preferences = WKPreferences()
        __config.preferences.javaScriptEnabled = true;
        __config.preferences.javaScriptCanOpenWindowsAutomatically = true;
        __config.processPool = WKProcessPool()
        __config.userContentController = WKUserContentController()
        self.init(frame: frame, configuration: __config)
        self.wrapped = __wrapped
        self.setupSubviews()
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.ctxs = configuration
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupSubviews(){
        self.wrapped?.contentView = self

        //设置代理
        self.uiDelegate = self.wrapped
        self.navigationDelegate = self.wrapped
        
        if let __wrapped = self.wrapped {
            
            //注册js对象，设置UI和导航的代理
            //window.webkit.messageHandlers.rrxc.postMessage({"action":"rrxc://"})
            if NX.Association.names.count > 0 {
                for name in NX.Association.names {
                    self.configuration.userContentController.add(__wrapped, name: name)
                }
            }
            
            //注入js脚本
            if NX.Association.scripts.count > 0 {
                for script in NX.Association.scripts {
                    self.configuration.userContentController.addUserScript(WKUserScript(source: script.source, injectionTime: script.injectionTime, forMainFrameOnly: script.isForMainFrameOnly))
                }
            }
        }
        
        
        //iOS 9.0以上
        self.evaluateJavaScript("navigator.userAgent") { (retValue, error) in
            guard error == nil, let ua = retValue as? String, ua.count > 0 else {
                return
            }
            NX.log { return "navigator.userAgent=\(ua)"}
        }
    }
    
    open func updateSubviews(_ action:String, _ value:Any?){
        if let request = value as? URLRequest {
            self.load(request)
        }
    }
    
    deinit {
        NX.log { return "NXWebView"}
        for name in NX.Association.names {
            self.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
}

extension NXWebView {
    open class Wrapped: NSObject,
        WKUIDelegate,
        WKNavigationDelegate,
        WKScriptMessageHandler,
        WKURLSchemeHandler {
        //网页容器
        public fileprivate(set) weak var contentView: NXWebView?
        
        //WKScriptMessageHandler
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
            if NX.Association.names.contains(message.name) {
                NX.log { return "message.name=\(message.name),\nmessage.body=\(message.body)"}
                // 依据协定好的数据格式将参数转成dic
                if let value = message.body as? [String:Any] {
                    //1.支持未经处理的[String:Any]结构
                    dispose(scheme:message.name, mapValue:value)
                }
                else if let value = message.body as? String {
                    //支持map-data-jsonString-urlencode处理的字符串
                    let dicValue = NXSerialization.JSONString(toDictionary: value, decode: true)
                    dispose(scheme:message.name, mapValue:dicValue)
                }
            }
        }
        
        
        //WKUIDelegate
        //js:window.close()触发的关闭操作
        public func webViewDidClose(_ webView: WKWebView) {
            if let __viewController = self.contentView?.attachedViewController {
                __viewController.close()
            }
        }
        
        //弹框：只有一个确定按钮
        public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            if let callback = self.contentView?.callbackWithAlert {
                callback(message, ["确定"], { (_, _) in
                    completionHandler()
                })
            }
            else {
                NXActionView.alert(title: "温馨提示", subtitle: message, actions: ["确定"]) { (action, index) in
                    completionHandler()
                }
            }
        }
        
        //弹框：两个按钮或更多按钮，点击后需要回调
        public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            if let callback = self.contentView?.callbackWithAlert {
                callback(message, ["取消","确定"], { (_, index) in
                    completionHandler(index == 1)
                })
            }
            else {
                NXActionView.alert(title: "温馨提示", subtitle: message, actions: ["取消","确定"]) { (action, index) in
                    completionHandler(index == 1)
                }
            }
        }
        
        //新打开
        public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url, url.absoluteString.count > 0  {
                webView.load(navigationAction.request)
            }
            return nil
        }
        
        //WKNavigationDelegate
        //询问是否允许加载：允许则webView(:didStartProvisionalNavigation:);反之结束
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let callback = self.contentView?.navigationAction {
                callback(navigationAction) { (_, policy) in
                    decisionHandler(policy)
                }
            }
            else {
                self.navigationAction(navigationAction, decisionHandler)
            }
        }
        
        
        //上一步allow且是非universallink后会触发didStartProvisionalNavigation，表示即将开始开始加载主文档
        //Provisional：页面开始加载后为了更好的区分加载的各个阶段，会讲网络加载的初始阶段命名为临时状态，此时的页面是不会计入历史的。
        //直到接受到第一个数据包，才会对当前的页面进行committed提交，并触发didCommitNavigation方法通知UIProcess进程改时间，同时将网络data给WebContent进行渲染树生成。
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
            self.contentView?.callbackWithProvisionalNavigation?(navigation, "start", false, nil)
        }
        
        public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            self.contentView?.callbackWithProvisionalNavigation?(navigation, "redirect", false, nil)
        }
        
        //当NetworkProcess进程发生网络错误的时候，错误首先有NSURLSession回调到WebContent层。
        //WebContent会判断当前主文档加载状态，如果处于临时态，则错误会毁掉给didFailProvisionalNavigation方法；如果处于提交态，则错误会回调给didFailNavigation方法。
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
            self.contentView?.callbackWithProvisionalNavigation?(navigation, "result", false, error)
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if let callback = self.contentView?.navigationResponse {
                callback(navigationResponse) { (_, policy) in
                    decisionHandler(policy)
                }
            }
            else {
                self.navigationResponse(navigationResponse, decisionHandler)
            }
        }
        
        
        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
            self.contentView?.callbackWithNavigation?(navigation, "start", false, nil)
        }
        
        //我们已经理解了 NetworkProcess 层也是使用 NSURLSession 加载主文档的。当 NSURLSession 接收到 finish 事件时，会将该消息通过进程通信方式传递给 WebContent 进程，WebContent 进程再传递给 UIProcess 进程，直到被我们的代理方法响应。因此 didFinishNavigation 在 NSURLSession 的网络加载结束时就会触发，但因为跨了两次进程通信，因此对比网络层，实际上是有一定的延迟的。与子资源加载和页面上屏无时间先后关系。
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
            //执行加载成功的回调<可选>
            self.contentView?.callbackWithNavigation?(navigation, "result", true, nil)
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
            //执行加载失败的回调<可选>
            self.contentView?.callbackWithNavigation?(navigation, "result", false, error)
        }
        
        
        //这里做重定向的黑名单/白名单的拦截处理
        public func navigationAction(_ navigationAction: WKNavigationAction, _ completion: @escaping ((_ policy:WKNavigationActionPolicy) -> ())){
            guard let url = navigationAction.request.url else {
                completion(WKNavigationActionPolicy.cancel)
                return
            }
            
            guard let scheme = url.scheme else {
                completion(WKNavigationActionPolicy.cancel)
                return
            }
            
            if scheme == "http" || scheme == "https" {
                //处理白名单/黑名单的业务
                completion(WKNavigationActionPolicy.allow)
            }
            else if NX.Association.scheme == scheme {
                //这种事通过自定义url重定向打开页面的或常用操作的
                self.dispose(scheme:NX.Association.scheme, mapValue: ["action":url.absoluteString])
                completion(WKNavigationActionPolicy.cancel)
            }
            else if NX.Association.openURLs.contains(scheme) {
                //这种是在网页中通过重定向的方式：常用App的，目前支持一下微信/AppStore
                NX.open(url, [:])
                completion(WKNavigationActionPolicy.cancel)
            }
            else{
                completion(WKNavigationActionPolicy.cancel)
            }
        }
        
        //先在这里做优先级的判断和跳转处理
        public func dispose(scheme:String, mapValue: [String:Any]){
            //参数的检查
            guard mapValue.count > 0, let __contentView = self.contentView else {return}
            
            //处理之前的回调
            __contentView.dispatchWithValue?(mapValue, false)
            
            //如果返回true，则NXURLNavigator自己有能力处理本次操作，反之返回false
            //如果返回false，则回调给具体的业务模块去处理
            if let isDisposed = NX.dispose("action", __contentView, mapValue, self.contentView?.attachedViewController), isDisposed == true {
                //如果能处理
            }
            else {
                //登录？处理需要回调的
                __contentView.callbackWithValue?(mapValue)
            }
            
            //处理之后的回调
            __contentView.dispatchWithValue?(mapValue, true)
        }
        
        //响应的拦截
        public func navigationResponse(_ navigationResponse: WKNavigationResponse, _ completion: @escaping ((_ policy:WKNavigationResponsePolicy) -> ())){
            if let response = navigationResponse.response as? HTTPURLResponse, response.statusCode == 200 {
                completion(WKNavigationResponsePolicy.allow)
            }
            else {
                completion(WKNavigationResponsePolicy.cancel)
            }
        }
        
        @available(iOS 11.0, *)
        public func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
            NX.dispose("task", webView, ["task":urlSchemeTask,"status":"start"], self.contentView?.attachedViewController)
        }
        
        @available(iOS 11.0, *)
        public func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
            NX.dispose("task", webView, ["task":urlSchemeTask,"status":"stop"], self.contentView?.attachedViewController)
        }
        
        deinit {
            NX.log { return "NXWebView.Wrapped"}
        }
    }
}
