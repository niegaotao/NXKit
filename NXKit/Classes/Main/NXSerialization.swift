//
//  NXSerialization.swift
//  NXSerialization
//
//  Created by firelonely on 2018/8/3.
//  Copyright © 2018年 无码科技. All rights reserved.
//

open class NXSerialization {
    
    public enum Category : String {
        case Dictionary = "Dictionary"
        case Array = "Array"
    }
    
    //=========================================
    //data -> toJSONObject
    public class func data(toObject data: Data?) -> Any? {
        guard let data = data else {return nil}
        do{
            let toObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
            return toObject
        }
        catch{
        }
        return nil
    }
        
    
    //data -> toDictionary
    public class func data(toDictionary data: Data?) -> [String:Any] {
        if let map = NXSerialization.data(toObject: data) as? [String:Any] {
            return map
        }
        return [:]
    }
    
    //data -> toArray
    public class func data(toArray data: Data?) -> [Any] {
        if let array = NXSerialization.data(toObject: data) as? [Any] {
            return array
        }
        return []
    }
    
    //=========================================
    //map/array->data
    public class func JSONObject(toData jsonObject:Any, options:JSONSerialization.WritingOptions) -> Data? {
        if JSONSerialization.isValidJSONObject(jsonObject) {
            do{
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
                return data
            }
            catch{
            }
        }
        return nil
    }
    
    //=========================================
    //map/array -> data -> string
    public class func JSONObject(toString jsonObject: Any) -> String {
        return NXSerialization.JSONObject(toString: jsonObject, encode: false)
    }
    
    
    //=========================================
    //data-string
    public class func data(toString data:Data?) -> String {
        if let data = data {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    
    //=========================================
    //jsonstring->(decode->) data -> toDictionary
    public class func JSONString(toDictionary value: String?, decode:Bool) -> [String:Any] {
        if let value = value {
            var newValue = value
            if decode {
                newValue = NXApp.decodeURIComponent(newValue)
            }
            guard let data = newValue.data(using: String.Encoding.utf8) else {return [:]}
            return NXSerialization.data(toDictionary: data)
        }
        return [:]
    }
    
    //jsonstring->(decode->) data -> toArray
    public class func JSONString(toArray value: String?, decode:Bool) -> [Any] {
        if let value = value {
            var newValue = value
            if decode {
                newValue = NXApp.decodeURIComponent(newValue)
            }
            guard let data = newValue.data(using: String.Encoding.utf8) else {return []}
            return NXSerialization.data(toArray: data)
        }
        return []
    }
    
    //=========================================
    //map/array->data->string->(urlencode)->string)
    public class func JSONObject(toString jsonObject:Any, encode: Bool) -> String {
        if let data = NXSerialization.JSONObject(toData: jsonObject, options: []) {
            let output = NXSerialization.data(toString: data)
            if encode {
                if let encodeOutput = NXApp.encodeURIComponent(output) {
                    return encodeOutput
                }
            }
            else{
                return output
            }
        }
        return ""
    }
    
    //filepath -> data
    public class func file(toData path:String?) -> Data? {
        guard let path = path else {return nil}
        let url = URL(fileURLWithPath: path)
        do{
            let data = try Data(contentsOf: url)
            return data
        }
        catch{
        }
        return nil
    }
    
    
    //filepath -> data -> toDictionary
    public class func file(toDictionary path:String?) -> [String: Any] {
        guard let path = path else {return [:]}
        return NXSerialization.data(toDictionary: NXSerialization.file(toData: path))
    }
    
    //filepath -> data -> toArray
    public class func file(toArray path:String?) -> [Any] {
        guard let path = path else {return []}
        return NXSerialization.data(toArray: NXSerialization.file(toData: path))
    }
    
    //生成路由URL
    public class func createURL(path:String, action:String, param:[String:Any]) -> String {
        return NXSerialization.createURL(scheme: NXApp.URI.scheme, path: path, action: action, param: param)
    }
    
    public class func createURL(scheme:String, path:String, action:String, param:[String:Any]) -> String {
        let __action = NXApp.encodeURIComponent(action) ?? action
        if param.count > 0 {
            let __param = NXSerialization.JSONObject(toString:param, encode:true)
            return "\(scheme)://\(path)?action=\(__action)&param=\(__param)"
        }
        return "\(scheme)://\(path)?action=\(__action)"
    }
    
    
    public class func createURL(scheme:String, path:String, query:[String:String], encode:Bool) -> String {
        var __querys = [String]()
        for (queryKey, queryKalue) in query {
            let __queryKey = encode ? NXApp.get(string:NXApp.encodeURIComponent(queryKey), ""): queryKey
            let __queryValue = encode ? NXApp.get(string:NXApp.encodeURIComponent(queryKalue), ""): queryKalue
            __querys.append("\(__queryKey)=\(__queryValue)")
        }
        var __actionURL = "\(scheme)://\(path)"
        if __querys.count > 0 {
            __actionURL = __actionURL + "?" + __querys.joined(separator: "&")
        }
        return __actionURL
    }
}
