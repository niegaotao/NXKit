//
//  LEYRouter.swift
//  NXFoundation
//
//  Created by firelonely on 2018/7/26.
//  Copyright © 2018年 无码科技. All rights reserved.
//


extension LEYRouter {
    /*回调的实例*/
    public struct Wrapped {
        public var url: String = ""
        public var query: [String: String]? = nil                   //URL对应解析的参数，输出
        public var info: [String: Any]? = nil                      //打开URL传入的参数，输入
        public var completion: LEYApp.Completion<Bool, [String: Any]?>? = nil//打开URL后的回调
    }
    
    //*这里采用类对象的方式保存注册信息*/
    open class URI : NSObject {
        open var url : String = ""                                    //scheme+host+path
        open var components: (scheme:String, path:String) = ("","")   //各部分的值
        open var completion: LEYApp.Completion<Bool, LEYRouter.Wrapped?>? = nil//注册后的回调action
    }
}

open class LEYRouter {
    public private(set) var uris = [LEYRouter.URI]()                //存储的paths
    public private(set) var schemes = [String]()                    //支持的schemes
    public private(set) var isRepeatable = false                    //是否支持重复的path
    open var exception : ((_ url:String) -> ())?                    //对未注册的或异常的一个回调
    
    public init(schemes: [String], isRepeatable: Bool) {
        self.schemes.append(contentsOf: schemes)
        self.isRepeatable = isRepeatable
    }
    
    /*新增URL*/
    @discardableResult
    public func add(_ url: String, completion:@escaping LEYApp.Completion<Bool, LEYRouter.Wrapped?>) -> LEYRouter.URI? {
        let components = self.components(url: url)
        if components.scheme.count > 0 || components.path.count > 0 {
            return self.add(scheme:components.scheme, path:components.path, completion: completion)
        }
        return nil
    }
    
    /*新增URL*/
    @discardableResult
    public func add(schemes:[String], paths: [String], completion:@escaping LEYApp.Completion<Bool, LEYRouter.Wrapped?>) -> [LEYRouter.URI?] {
        var currentURIs = [LEYRouter.URI?]()
        for scheme in schemes {
            if paths.count > 0 {
                for path in paths {
                    currentURIs.append(self.add(scheme:scheme, path:path, completion: completion))
                }
            }
            else{
                //支持无path的注入
                currentURIs.append(self.add(scheme: scheme, path: "", completion: completion))
            }
        }
        return currentURIs
    }
    
    /*新增URL*/
    @discardableResult
    public func add(scheme:String, path: String, completion:@escaping LEYApp.Completion<Bool, LEYRouter.Wrapped?>) -> LEYRouter.URI? {
        let compatible = self.compatibleURI(url: scheme + "://" + path)
        
        if compatible.components.isValid == false {
            return nil
        }
        
        if isRepeatable == false {
            if let uri = compatible.uri {
                if let index = self.uris.firstIndex(of: uri){
                    self.uris.remove(at: index)
                }
            }
        }
        
        //创建一个资源定位符号
        let uri = LEYRouter.URI()
        uri.url = compatible.components.url
        uri.completion = completion
        uri.components.scheme = scheme
        uri.components.path = path

        uris.append(uri)
        
        return uri
    }
    
    /*删除*/
    @discardableResult
    public func remove(_ url: String, uri: LEYRouter.URI? = nil) -> Bool {
        let __components = self.components(url: url)
        if __components.isValid == false {
            return false
        }
        
        var isRemoved : Bool = false
        
        if let __target = uri {
            self.uris.removeAll { (__uri) -> Bool in
                if __target == __uri {
                    isRemoved = true
                    return true
                }
                return false
            }
        }
        else {
            self.uris.removeAll { (__uri) -> Bool in
                if __uri.components.scheme == __components.scheme && __uri.components.path == __components.path {
                    isRemoved = true
                    return true
                }
                return false
            }
        }
        return isRemoved
    }
    
    //open(_ url: String, info: [String: Any]?, completion: LEYRouter.RawValue.Completion?)
    public func open(_ url: String, params: [String: Any]?, completion: LEYApp.Completion<Bool, [String: Any]?>?) {
        self.open(url, info: params, completion: completion)
    }
    
    //打开链接
    public func open(_ url: String, info: [String: Any]?, completion: LEYApp.Completion<Bool, [String: Any]?>?) {
        let compatible = self.compatibleURI(url: url)
        if compatible.components.isValid, let uri = compatible.uri{
            var rawValue = LEYRouter.Wrapped()
            rawValue.url = url
            rawValue.info = info
            rawValue.query = LEYRouter.query(url: url)
            rawValue.completion = completion
            uri.completion?(true, rawValue)
        }
        else {
            self.exception?(url)
        }
    }
    
    /*检测url的有效性*/
    public func components(url: String) -> (isValid:Bool, url:String, scheme:String, path:String){
        var components : (isValid:Bool, url:String, scheme:String, path:String) = (false, "", "", "")
        if let encodeURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed) {
            if let __url = URL(string: encodeURL), let __scheme = __url.scheme , self.schemes.contains(__scheme){
                components.isValid = true
                components.url = encodeURL
                components.scheme = __scheme
                components.path = (__url.host ?? "") + __url.path
            }
        }
        
        return components
    }
    
    
    /*匹配URL*/
    public func compatibleURI(url: String) -> (components:(isValid:Bool, url:String, scheme:String, path:String), uri:LEYRouter.URI?) {
        let components = self.components(url: url)
        
        for uri in self.uris {
            
            var compare : (scheme:Bool, path:Bool) = (true, true)
            if uri.components.scheme.count > 0 {
                compare.scheme = uri.components.scheme == components.scheme
            }
            else {
                compare.scheme = true
            }
            
            if uri.components.path.count > 0 {
                compare.path = uri.components.path == components.path
            }
            else {
                compare.path = true
            }
            
            if compare.scheme && compare.path {
                return (components, uri)
            }
        }
        
        return (components, nil)
    }
    
    
    /*解析URL自带的参数规则*/
    class public func query(url: String) -> [String: String]? {
        if let __url = URL(string: url), let query = __url.query, query.count > 0 {
            var dicValue = [String: String]()
            
            let components = query.components(separatedBy: "&")
            for component in components {
                guard component.count > 0 else {
                    continue
                }
                
                let values = component.components(separatedBy: "=")
                if values.count == 2 {
                    dicValue[values[0]] = values[1]
                }
            }
            
            return dicValue.count > 0 ? dicValue : nil
        }
        return nil
    }
}

