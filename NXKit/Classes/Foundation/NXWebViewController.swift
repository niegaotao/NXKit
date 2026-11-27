//
//  NXWebViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/30.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit
import WebKit

open class NXBackbarWrappedView: NXLCRView<NXButton, UIView, NXButton> {
    open var isAutoable = true
    override open func setupSubviews() {
        super.setupSubviews()
        lhsView.frame = CGRect(x: 0, y: 0, width: 32, height: 44)
        lhsView.setImage(NXKit.image(named: "navi-back.png", mode: .alwaysTemplate), for: .normal)
        lhsView.contentHorizontalAlignment = .left
        lhsView.tintColor = NXKit.barForegroundColor

        centerView.frame = CGRect(x: 32, y: 14, width: NXKit.pixel, height: 16)
        centerView.backgroundColor = NXKit.barForegroundColor.withAlphaComponent(0.6)

        rhsView.frame = CGRect(x: 33, y: 0, width: 32, height: 44)
        rhsView.setImage(NXKit.image(named: "navi-close.png", mode: .alwaysTemplate), for: .normal)
        rhsView.contentHorizontalAlignment = .right
        rhsView.tintColor = NXKit.barForegroundColor
    }

    override open func updateSubviews(_ value: Any?) {
        let __isHidden = (value as? Bool) ?? true
        centerView.isHidden = __isHidden
        rhsView.isHidden = __isHidden
    }
}

open class NXWebViewController: NXViewController {
    open var url: String = ""
    open var html: String = ""

    open var HTTPMethed: String = "GET"

    open var cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
    open var timeoutInterval: TimeInterval = 60.0

    open var webView = NXWebView(frame: CGRect.zero)
    open var progressView = UIProgressView(progressViewStyle: .bar)
    open var backbarView = NXBackbarWrappedView(frame: CGRect(x: 0, y: 0, width: 65, height: 44))
    lazy var observer: NXKVOObserver = .init(observer: self)

    override open func viewDidLoad() {
        super.viewDidLoad()

        navigationView.title = "加载中..."

        setupSubviews()

        if url.count > 0 {
            updateSubviews(["url": url])
        } else if html.count > 0 {
            if let HTMLURL = Bundle.main.url(forResource: html, withExtension: "") {
                webView.updateSubviews(URLRequest(url: HTMLURL))
            }
        }
    }

    override open func setupSubviews() {
        webView.webViewController = self
        webView.frame = contentView.bounds
        webView.backgroundColor = NXKit.viewBackgroundColor
        webView.isOpaque = false
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        observer.add(object: webView, key: "title", options: [.new, .old], context: nil, completion: nil)
        observer.add(object: webView, key: "estimatedProgress", options: [.new, .old], context: nil, completion: nil)

        webView.ctxs.callbackWithNavigation = { [weak self] _, action, isCompleted, error in
            if action == "result" {
                self?.callbackWithCompletion(isCompleted, error)
            }
        }
        webView.ctxs.callbackWithValue = { [weak self] (value: [String: Any]) in
            self?.callbackWithValue(value)
        }
        contentView.addSubview(webView)
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        }

        backbarView.frame = CGRect(x: 0, y: 0, width: 65, height: 44)
        backbarView.lhsView.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)
        backbarView.rhsView.addTarget(self, action: #selector(onCloseAction), for: .touchUpInside)
        backbarView.updateSubviews(true)
        navigationView.leftView = backbarView
        navigationView.titleView.x = 15.0 + 44.0 + 1.0
        navigationView.titleView.width = navigationView.width - navigationView.titleView.x * 2.0

        progressView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: progressView.frame.size.height)
        progressView.autoresizingMask = [.flexibleWidth]
        progressView.progressTintColor = NXKit.primaryColor
        progressView.trackTintColor = UIColor.clear
        progressView.alpha = 0.0
        contentView.addSubview(progressView)
    }

    override open func updateSubviews(_ value: Any?) {
        guard let value = value as? [String: Any], let _url = value["url"] as? String else {
            return
        }
        if let __url = URL(string: _url) {
            var HTTPRequest = URLRequest(url: __url)
            HTTPRequest.httpMethod = HTTPMethed
            HTTPRequest.cachePolicy = cachePolicy
            HTTPRequest.timeoutInterval = timeoutInterval
            HTTPRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
            // 将网页需要的请求头数据在这里添加
            // HTTPRequest.setValue("user.id", forHTTPHeaderField: "userid")

            webView.updateSubviews(HTTPRequest)
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let targetView = object as? WKWebView, let accessKey = keyPath else {
            return
        }

        if targetView == webView {
            if accessKey == "title" {
                navigationView.title = webView.title ?? ""
            } else if accessKey == "estimatedProgress" {
                progressView.alpha = 1.0

                let currentValue = Float(webView.estimatedProgress)
                let isAnimated: Bool = (currentValue > progressView.progress)
                progressView.setProgress(currentValue, animated: isAnimated)

                if currentValue >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: { [weak self] in
                        self?.progressView.alpha = 0.0
                    }, completion: nil)
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    @objc open func onBackAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            close()
        }
    }

    @objc open func onCloseAction() {
        close()
    }

    open func callbackWithCompletion(_ isCompleted: Bool, _: Error?) {
        NXKit.log { "isCompleted = \(isCompleted)" }

        // 在这里做导航栏返回按钮
        if isCompleted && backbarView.isAutoable {
            if webView.canGoBack {
                backbarView.updateSubviews(false)
                navigationView.titleView.x = 15.0 + 65.0 + 8.0
                navigationView.titleView.width = navigationView.width - navigationView.titleView.x * 2.0
            } else {
                backbarView.updateSubviews(true)
                navigationView.titleView.x = 15.0 + 44.0 + 1.0
                navigationView.titleView.width = navigationView.width - navigationView.titleView.x * 2.0
            }
        }
    }

    open func callbackWithValue(_: [String: Any]) {}

    deinit {
        self.webView.stopLoading()
        self.observer.removeAll()
    }
}
