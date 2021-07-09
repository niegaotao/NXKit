//
//  NXWebViewController.swift
//  NXKit
//
//  Created by firelonely on 2018/5/30.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit
import WebKit

extension NXWebViewController {
    open class BackbarWrapperView: NXLCRView<NXButton, UIView, NXButton> {
        open var backBar : NXButton {return self.lhsView }
        open var separatorView : UIView {return self.centerView }
        open var closeBar : NXButton {return self.rhsView }
        open var isAutoable = true
        
        override open func setupSubviews() {
            super.setupSubviews()
            self.lhsView.frame = CGRect(x: 0, y: 0, width: 32, height: 44)
            self.lhsView.setImage(NXApp.image(named:"navi_back_black.png"), for: .normal)
            self.lhsView.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -4, bottom: 0, right: 4)
            
            self.centerView.frame = CGRect(x: 32, y: 14, width: NXDevice.pixel, height: 16)
            self.centerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            self.rhsView.frame = CGRect(x: 33, y: 0, width: 32, height: 44)
            self.rhsView.setImage(NXApp.image(named:"navi_close_black.png"), for: .normal)
            self.rhsView.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 4, bottom: 0, right: -4)
        }
        
        open override func updateSubviews(_ action: String, _ value: Any?) {
            let __isHidden = (value as? Bool) ?? true
            self.rhsView.isHidden = __isHidden
            self.centerView.isHidden = __isHidden
        }
    }
    
    open class KVO:NSObject {
        open var access = ""
        open var isObservable = true
        open var isObserved = false
        
        override init() {
            super.init()
        }
        
        public init(access:String, isObservable:Bool, isObserved:Bool) {
            super.init()
            self.access = access
            self.isObservable = isObservable
            self.isObserved = isObserved
        }
    }
}
 
open class NXWebViewController: NXViewController {
    open var url: String = ""
    open var html : String = ""
    
    open var HTTPMethed : String = "GET"
    
    open var cachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
    open var timeoutInterval: TimeInterval = 60.0

    open var webView = NXWebView(frame: CGRect.zero)
    open var progressView = UIProgressView(progressViewStyle: .bar)
    open var backbarView = NXWebViewController.BackbarWrapperView(frame: CGRect(x: 0, y: 0, width: 65, height: 44))
    
    public let accesses = [KVO(access: "title", isObservable:true, isObserved: false),
                           KVO(access: "estimatedProgress", isObservable:true, isObserved: false)]//通过KVO获取的相关属性
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.title = "加载中..."
        
        self.setupSubviews()
        
        if url.count > 0 {
            self.updateSubviews("update", ["url":self.url])
        }
        else if html.count > 0 {
            if let HTMLURL = Bundle.main.url(forResource: html, withExtension: "") {
                self.webView.updateSubviews("update", URLRequest(url: HTMLURL))
            }
        }
    }
    
    open override func setupSubviews() {
        self.webView.attachedViewController = self
        self.webView.frame = self.contentView.bounds
        self.webView.backgroundColor = UIColor.white
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        for access in self.accesses {
            if access.access.count > 0 && access.isObservable == true && access.isObserved == false {
                access.isObserved = true
                self.webView.addObserver(self, forKeyPath: access.access, options: [.new, .old], context: nil)
            }
        }
        
        self.webView.callbackWithNavigation = {[weak self](navigation, action, isCompleted, error) -> () in
            if action == "result" {
                self?.callbackWithCompletion(isCompleted, error)
            }
        }
        self.webView.callbackWithValue = {[weak self] (value:[String:Any])  in
            self?.callbackWithValue(value)
        }
        self.contentView.addSubview(self.webView)
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        self.backbarView.frame = CGRect(x: 0, y: 0, width: 65, height: 44)
        self.backbarView.backBar.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)
        self.backbarView.closeBar.addTarget(self, action: #selector(onCloseAction), for: .touchUpInside)
        self.backbarView.updateSubviews("", true)
        self.naviView.backView = backbarView
        self.naviView.titleView.x = 15.0 + 44.0 + 1.0
        self.naviView.titleView.w = self.naviView.w - self.naviView.titleView.x * 2.0
        
        self.progressView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.progressView.frame.size.height)
        self.progressView.autoresizingMask = [.flexibleWidth]
        self.progressView.progressTintColor = NXApp.mainColor
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.alpha = 0.0
        self.contentView.addSubview(self.progressView)
    }
    
    open override func updateSubviews(_ action: String, _ value: [String : Any]?) {
        guard let _url = value?["url"] as? String else {
            return
        }
        if let __url = URL(string: _url) {
            var HTTPRequest = URLRequest(url: __url)
            HTTPRequest.httpMethod = self.HTTPMethed
            HTTPRequest.cachePolicy = self.cachePolicy
            HTTPRequest.timeoutInterval = self.timeoutInterval
            HTTPRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
            //将网页需要的请求头数据在这里添加
            //HTTPRequest.setValue("user.id", forHTTPHeaderField: "userid")
            
            self.webView.updateSubviews("update", HTTPRequest)
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let targetView = object as? WKWebView, let accessKey = keyPath else  {
            return
        }
        
        if targetView == self.webView,
           let access = self.accesses.first(where: {$0.access==accessKey}),
           access.isObservable == true && access.isObserved == true {
            if accessKey == "title" {
                self.naviView.title = self.webView.title ?? ""
            }
            else if accessKey == "estimatedProgress" {
                self.progressView.alpha = 1.0
                
                let currentValue : Float = Float(self.webView.estimatedProgress)
                let isAnimated : Bool = (currentValue > self.progressView.progress)
                self.progressView.setProgress(currentValue, animated: isAnimated)
                
                if currentValue >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {[weak self] in
                        self?.progressView.alpha = 0.0
                    }, completion: nil)
                }
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc open func onBackAction(){
        if self.webView.canGoBack {
            self.webView.goBack()
        }
        else{
            self.close()
        }
    }
    
    @objc open func onCloseAction(){
        self.close()
    }
    
    open func callbackWithCompletion(_ isCompleted: Bool, _ error:Error?){
        NXApp.log { return "isCompleted = \(isCompleted)"}
        
        //在这里做导航栏返回按钮
        if isCompleted && self.backbarView.isAutoable {
            if self.webView.canGoBack {
                self.backbarView.updateSubviews("", false)
                self.naviView.titleView.x = 15.0 + 65.0 + 8.0
                self.naviView.titleView.w = self.naviView.w - self.naviView.titleView.x * 2.0
            }
            else{
                self.backbarView.updateSubviews("", true)
                self.naviView.titleView.x = 15.0 + 44.0 + 1.0
                self.naviView.titleView.w = self.naviView.w - self.naviView.titleView.x * 2.0
                NXApp.print("t.f=\(self.naviView.titleView.frame)")
            }
        }
    }
    
    open func callbackWithValue(_ value:[String:Any]){
    
    }
    
    deinit {
        self.webView.stopLoading()
        for access in self.accesses {
            if access.access.count > 0 && access.isObservable == true && access.isObserved == true {
                self.webView.removeObserver(self, forKeyPath: access.access)
            }
        }
    }
}
