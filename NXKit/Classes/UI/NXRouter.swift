//
//  NXRouter.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/26.
//  Copyright © 2018年 无码科技. All rights reserved.
//


extension NXRouter {
    /*回调的实例*/
    public class Wrapped {
        public var url: String = ""
        public var query: [String: String]? = nil                   //URL对应解析的参数，输出
        public var info: [String: Any]? = nil                      //打开URL传入的参数，输入
        public var completion: NX.Completion<Bool, [String: Any]>? = nil//打开URL后的回调
    }
    
    //*这里采用类对象的方式保存注册信息*/
    open class URI : NSObject {
        open var url = ""           //url
        open var scheme = ""        //scheme
        open var host = ""          //host
        open var port = ""          //port
        open var path = ""          //path
        open var query = ""         //query
        open var fragment = ""      //fragment
        open var completion: NX.Completion<Bool, NXRouter.Wrapped?>? = nil//注册后的回调action
    }
    
    //检查过程中的临时变量
    open class Record : URI {
        open var isValid = false
        open var uri: URI? = nil
    }
}

open class NXRouter {
    public private(set) var uris = [NXRouter.URI]()                //存储的paths
    public private(set) var schemes = [String]()                    //支持的schemes
    public private(set) var isRepeatable = false                    //是否支持重复的path
    open var exception : ((_ url:String) -> ())?                    //对未注册的或异常的一个回调
    
    public init(schemes: [String], isRepeatable: Bool) {
        self.schemes.append(contentsOf: schemes)
        self.isRepeatable = isRepeatable
    }
    
    /*新增URL*/
    @discardableResult
    public func add(_ url: String, completion:@escaping NX.Completion<Bool, NXRouter.Wrapped?>) -> NXRouter.URI? {
        let record = self.compatibleURI(url: url)
        return self.add(record: record, completion: completion)
    }
    
    /*新增URL*/
    @discardableResult
    public func add(schemes:[String], paths: [String], completion:@escaping NX.Completion<Bool, NXRouter.Wrapped?>) -> [NXRouter.URI?] {
        var currentURIs = [NXRouter.URI?]()
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
    public func add(scheme:String, path: String, completion:@escaping NX.Completion<Bool, NXRouter.Wrapped?>) -> NXRouter.URI? {
        let record = self.compatibleURI(url: scheme + "://" + path)
        return self.add(record: record, completion: completion)
    }
    
    /*新增URL*/
    @discardableResult
    fileprivate func add(record: NXRouter.Record, completion:@escaping NX.Completion<Bool, NXRouter.Wrapped?>) -> NXRouter.URI? {
        
        if record.isValid == false {
            return nil
        }
        
        if isRepeatable == false {
            if let uri = record.uri {
                if let index = self.uris.firstIndex(of: uri){
                    self.uris.remove(at: index)
                }
            }
        }
        
        //创建一个资源定位符号
        let uri = NXRouter.URI()
        uri.url = record.url
        uri.scheme = record.scheme
        uri.path = record.path
        uri.completion = completion
        uris.append(uri)
        
        return uri
    }
    
    
    
    /*删除*/
    @discardableResult
    public func remove(_ url: String, uri: NXRouter.URI? = nil) -> Bool {
        let __components = self.compatibleURI(url: url)
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
                if __uri.scheme == __components.scheme && __uri.path == __components.path {
                    isRemoved = true
                    return true
                }
                return false
            }
        }
        return isRemoved
    }
    
    //打开链接
    public func open(_ url: String, info: [String: Any]?, completion: NX.Completion<Bool, [String: Any]>?) {
        let compatible = self.compatibleURI(url: url)
        if compatible.isValid, let uri = compatible.uri {
            let rawValue = NXRouter.Wrapped()
            rawValue.url = url
            rawValue.info = info
            rawValue.query = NXRouter.query(url: url)
            rawValue.completion = completion
            uri.completion?(true, rawValue)
        }
        else {
            self.exception?(url)
        }
    }
    
    /*检测url的有效性,匹配URL*/
    public func compatibleURI(url: String) -> NXRouter.Record {
        let record = NXRouter.Record()
        if let encodeURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed) {
            if let __url = URL(string: encodeURL), let __scheme = __url.scheme , self.schemes.contains(__scheme){
                record.isValid = true
                record.url = encodeURL
                record.scheme = __scheme
                record.path = (__url.host ?? "") + __url.path
            }
        }
        
        for uri in self.uris {
            
            var compare : (scheme:Bool, path:Bool) = (true, true)
            if uri.scheme.count > 0 {
                compare.scheme = uri.scheme == record.scheme
            }
            else {
                compare.scheme = true
            }
            
            if uri.path.count > 0 {
                compare.path = uri.path == record.path
            }
            else {
                compare.path = true
            }
            
            if compare.scheme && compare.path {
                record.uri = uri
                return record
            }
        }
        
        return record
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

extension NXRouter {
    //生成路由URL
    public class func create(scheme:String, path:String, operation:String, data:[String:Any]) -> String {
        let __operation = NX.encodeURIComponent(operation) ?? operation
        if data.count > 0 {
            let encode = NXSerialization.JSONObject(toString:data, encode:true)
            return "\(scheme)://\(path)?operation=\(__operation)&data=\(encode)"
        }
        return "\(scheme)://\(path)?operation=\(__operation)"
    }
    
    public class func create(scheme:String, path:String, query:[String:String], encode:Bool) -> String {
        var __querys = [String]()
        for (queryKey, queryKalue) in query {
            let __queryKey = encode ? NX.get(string:NX.encodeURIComponent(queryKey), ""): queryKey
            let __queryValue = encode ? NX.get(string:NX.encodeURIComponent(queryKalue), ""): queryKalue
            __querys.append("\(__queryKey)=\(__queryValue)")
        }
        var __actionURL = "\(scheme)://\(path)"
        if __querys.count > 0 {
            __actionURL = __actionURL + "?" + __querys.joined(separator: "&")
        }
        return __actionURL
    }
}

