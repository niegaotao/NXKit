//
//  NXRouter.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/26.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

public extension NXRouter {
    // *注册信息*/
    class URI: NXAny {
        public var scheme = "" // scheme
        public var host = "" // host
        public var path = "" // path
        public var completion: NXKit.Event<Bool, NXRouter.URL>? = nil // 注册后的回调action
    }

    /* 回调信息 */
    class URL {
        public var url: String = ""
        public var info: [String: Any]? // 打开URL传入的参数，输入
        public var completion: NXKit.Event<Bool, NXRouter.URL>? // 打开URL后的回调

        public var scheme = "" // scheme
        public var host = "" // host
        public var path = "" // path
        public var query = [String: String]() // URL对应解析的参数，输出
    }
}

open class NXRouter: NSObject {
    public static let center = NXRouter()
    public private(set) var uris = [NXRouter.URI]() // 存储的uris
    open var exception: ((_ url: String) -> Void)? // 对未注册的或异常的一个回调

    /* 新增URL */
    @discardableResult
    public func add(_ url: String, completion: @escaping NXKit.Event<Bool, NXRouter.URL>) -> NXRouter.URI? {
        guard let url = Foundation.URL(string: url), let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        let uri = NXRouter.URI()
        uri.scheme = components.scheme ?? ""
        uri.host = components.host ?? ""
        uri.path = components.path

        if let index = uris.firstIndex(where: { $0.scheme == uri.scheme && $0.host == uri.host && $0.path == uri.path }) {
            uris.remove(at: index)
        }

        uri.completion = completion
        uris.append(uri)
        return uri
    }

    /* 删除 */
    @discardableResult
    public func remove(_ url: String) -> Bool {
        guard let url = Foundation.URL(string: url), let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        uris.removeAll(where: {
            $0.scheme == (components.scheme ?? "") && $0.host == (components.host ?? "") && $0.path == components.path
        })

        return true
    }

    // 打开链接
    public func open(_ url: String, info: [String: Any]? = nil, completion: NXKit.Event<Bool, NXRouter.URL>? = nil) {
        guard let url = Foundation.URL(string: url), let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            exception?(url)
            return
        }

        let urlValue = NXRouter.URL()
        urlValue.url = url.absoluteString
        urlValue.info = info
        urlValue.completion = completion

        urlValue.scheme = components.scheme ?? ""
        urlValue.host = components.host ?? ""
        urlValue.path = components.path

        if let queryItems = components.queryItems {
            for query in queryItems {
                if let value = query.value {
                    urlValue.query[query.name] = value
                }
            }
        }

        if let uri = uris.first(where: { $0.scheme == urlValue.scheme && $0.host == urlValue.host && $0.path == urlValue.path }) {
            uri.completion?(true, urlValue)
        } else {
            exception?(url.absoluteString)
        }
    }
}

public extension NXRouter {
    // 生成路由URL
    class func create(scheme: String, host: String, path: String, query: [String: Any], encode: Bool) -> String {
        var __querys = [String]()
        for (queryKey, queryValue) in query {
            let key = encode ? NXKit.get(string: NXKit.encodeURIComponent(queryKey), "") : queryKey
            var value = ""
            if let __value = queryValue as? String {
                value = encode ? NXKit.get(string: NXKit.encodeURIComponent(__value), "") : __value
            } else if let __value = queryValue as? [String: Any] {
                value = NXSerialization.JSONObject(toString: __value, encode: encode)
            } else if let __value = queryValue as? [Any] {
                value = NXSerialization.JSONObject(toString: __value, encode: encode)
            }
            __querys.append("\(key)=\(value)")
        }
        var __actionURL = "\(scheme)://\(host)\(path)"
        if __querys.count > 0 {
            __actionURL = __actionURL + "?" + __querys.joined(separator: "&")
        }
        return __actionURL
    }
}
