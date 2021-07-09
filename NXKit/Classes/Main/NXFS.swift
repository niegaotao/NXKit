//
//  NXFS.swift
//  NXKit
//
//  Created by firelonely on 2021/1/26.
//

import Foundation

/*
 
 {
    "Documents":{
        "350":{},
        "1949":{}
    },
    "Library": {
        "Caches":{
            "app":{},
            "com.apple.WebKit.Networking":{},
            "com.apple.WebKit.WebContent":{},
            "com.ibireme.yykit":{},
            "com.wuma.teamphoto":{},
            "com.wuma.teamphoto.compose":{},
        },
        "Cookies":{},
        "Preferences":{},
        "Saved Application State":{},
        "SplashBoard":{},
        "WebKit":{}
    },
    "tmp":{},
    "SystemData":{}
 }
 */

open class NXFS {
    
}

extension NXFS {
    public enum Directory {
        case sandbox(String)
        case document(String)
        case cache(String)
        case temporary(String)
        case bundle(String)
    }
}

extension NXFS {
    open class func path(_ directory:NXFS.Directory, _ createAllowed:Bool = true) -> String {
        if case .sandbox(let specified) = directory {
            var pathValue = NSHomeDirectory()
            if specified.count > 0 {
                pathValue = pathValue + "/\(specified)"
                if createAllowed == true && NXFS.fileExists(pathValue) == false {
                    NXFS.createDirectory(pathValue)
                }
            }
            return pathValue
        }
        else if case .document(let specified) = directory {
            var pathValue = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            if specified.count > 0 {
                pathValue = pathValue + "/\(specified)"
                if createAllowed == true && NXFS.fileExists(pathValue) == false {
                    NXFS.createDirectory(pathValue)
                }
            }
            return pathValue
        }
        else if case .cache(let specified) = directory {
            var pathValue = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
            if specified.count > 0 {
                pathValue = pathValue + "/\(specified)"
                if createAllowed == true && NXFS.fileExists(pathValue) == false {
                    NXFS.createDirectory(pathValue)
                }
            }
            return pathValue
        }
        else if case .temporary(let specified) = directory {
            var pathValue = NSTemporaryDirectory()
            if specified.count > 0 {
                pathValue = pathValue + "\(specified)"
                if createAllowed == true && NXFS.fileExists(pathValue) == false {
                    NXFS.createDirectory(pathValue)
                }
            }
            return pathValue
        }
        else if case .bundle(let specified) = directory {
            var pathValue = Bundle.main.resourcePath ?? ""
            if specified.count > 0 {
                pathValue = pathValue + "/\(specified)"
            }
            return pathValue
        }
        return ""
    }
    
    open class func file(_ directory:NXFS.Directory, _ filename:String, _ createAllowed:Bool = true) -> String {
        var path = NXFS.path(directory) + "/\(filename).json"
        if filename.contains(".json") {
            path = NXFS.path(directory) + "/\(filename)"
        }
        if createAllowed == true && NXFS.fileExists(path) == false {
            NXFS.createFile(path)
        }
        return path
    }
    
    @discardableResult
    open class func fileExists(_ path:String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    @discardableResult
    open class func createDirectory(_ path:String) -> Bool {
        do{
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        catch{
            return false
        }
        return true
    }
    
    @discardableResult
    open class func removeDirectory(_ path:String) -> Bool {
        do{
            try FileManager.default.removeItem(atPath: path)
        }
        catch{
            return false
        }
        return true
    }
    
    @discardableResult
    open class func createFile(_ path:String) -> Bool {
        if NXFS.fileExists(path) {
            return false
        }
        FileManager.default.createFile(atPath:path, contents:nil, attributes:nil)
        return true
    }
}

extension NXFS {
    public static let file = NXApp.namespace

    //setValue:写入数据
    open class func setValue(_ value: Any, forKey: String, directory: NXFS.Directory, filename: String) {
        
        if case .bundle(_) = directory {
            return
        }
        
        //路径
        let path = NXFS.file(directory, filename, true)
        
        //存储的key存在，则获取之前的map，通过key写入到该文件再存储
        if forKey.count > 0 {
            var map = NXSerialization.data(toDictionary: NXFS.contentsOf(path))
            map[forKey] = value
            
            let data = NXSerialization.JSONObject(toData: map, options: [.prettyPrinted]) as NSData?
            let result = data?.write(toFile: path, atomically: true) ?? false
            NXApp.print("JSON:save result is: \(String(describing: result))")
        }
        else{
            //存储的key不存在，则将内容直接存入该文件[这种需要验证传入值的类型为数组或者map
            if let mapValue = value as? [String:Any] {
                let data = NXSerialization.JSONObject(toData: mapValue, options: [.prettyPrinted]) as NSData?
                let result = data?.write(toFile: path, atomically: true) ?? false
                NXApp.print("JSON:save result is: \(String(describing: result))")
            }
            else if let arrValue = value as? [Any?] {
                let data = NXSerialization.JSONObject(toData: arrValue, options: [.prettyPrinted]) as NSData?
                let result = data?.write(toFile: path, atomically: true) ?? false
                NXApp.print("JSON:save result is: \(String(describing: result))")
            }
        }
    }
    
    //value(forKey:从json读取数据:默认不需要后缀名
    open class func value(forKey: String, directory: NXFS.Directory, filename: String) -> Any? {
        return NXFS.value(forKey: forKey, directory: directory, filename: filename, isDictionary: true)
    }
    
    open class func value(forKey: String, directory: NXFS.Directory, filename: String, isDictionary:Bool) -> Any? {
        let path = NXFS.file(directory,filename, false)
        if NXFS.fileExists(path) {
            if isDictionary {
                let map = NXSerialization.data(toDictionary: NXFS.contentsOf(path))
                if forKey.count > 0 {
                    return map[forKey]
                }
                return map
            }
            else {
                return NXSerialization.data(toArray: NXFS.contentsOf(path))
            }
        }
        return nil
    }
    
    //读取内容
    open class func contentsOf(_ file:String) -> Data? {
        var url : URL? = URL(fileURLWithPath: file)
        if file.hasPrefix("http") {
            url = URL(string: file)
        }
        else {
            url = URL(fileURLWithPath: file)
        }
        guard let _url = url else {
            return nil
        }
        var data : Data? = nil
        do {
            data = try Data(contentsOf: _url)
        }
        catch {
            
        }
        return data
    }
}

extension NXFS {
    open class MIME {
        static var mimes = [String:String]()
        
        public class func fetch(_ filename:String) -> String {
            var url : URL? = URL(string: filename)
            if filename.hasPrefix("http") == false {
                url = URL(fileURLWithPath: filename)
            }
            return NXFS.MIME.fetchMIME(NXApp.get(string:url?.pathExtension, ""))
        }
        
        public class func fetchMIME(_ fileExtension:String) -> String {
            if NXFS.MIME.mimes.count == 0 {
                NXFS.MIME.mimes[".png"] = "image/png"
                NXFS.MIME.mimes[".jpg"] = "image/jpeg"
                NXFS.MIME.mimes[".jpeg"] = "image/jpeg"
                NXFS.MIME.mimes[".gif"] = "image/gif"
                NXFS.MIME.mimes[".svg"] = "image/svg+xml"

                NXFS.MIME.mimes[".mp3"] = "audio/x-mpeg"
                
                NXFS.MIME.mimes[".mp4"] = "video/mp4"
                NXFS.MIME.mimes[".mpg4"] = "video/mp4"
                
                NXFS.MIME.mimes[".js"] = "application/x-javascript"
                //NXFS.MIME.mimes[".css"] = "application/x-pointplus"//text/css
                //NXFS.MIME.mimes[".ttf"] = "application/x-font-truetype"
                NXFS.MIME.mimes[".html"] = "text/html"
            }
            if let value = NXFS.MIME.mimes[fileExtension] {
                return value
            }
            return "application/octet-stream"
        }
        
    }
}

