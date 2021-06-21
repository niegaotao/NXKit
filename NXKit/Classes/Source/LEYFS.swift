//
//  LEYFS.swift
//  NXFoundation
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

open class LEYFS {
    
}

extension LEYFS {
    public enum Directory {
        case sandbox(String)
        case document(String)
        case cache(String)
        case temporary(String)
        case bundle(String)
    }
}

extension LEYFS {
    open class func path(_ directory:LEYFS.Directory, _ createAllowed:Bool = true) -> String {
        if case .sandbox(let specified) = directory {
            var pathValue = NSHomeDirectory()
            if specified.count > 0 {
                pathValue = pathValue + "/\(specified)"
                if createAllowed == true && LEYFS.fileExists(pathValue) == false {
                    LEYFS.createDirectory(pathValue)
                }
            }
            return pathValue
        }
        else if case .document(let specified) = directory {
            var pathValue = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            if specified.count > 0 {
                pathValue = pathValue + "/\(specified)"
                if createAllowed == true && LEYFS.fileExists(pathValue) == false {
                    LEYFS.createDirectory(pathValue)
                }
            }
            return pathValue
        }
        else if case .cache(let specified) = directory {
            var pathValue = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
            if specified.count > 0 {
                pathValue = pathValue + "/\(specified)"
                if createAllowed == true && LEYFS.fileExists(pathValue) == false {
                    LEYFS.createDirectory(pathValue)
                }
            }
            return pathValue
        }
        else if case .temporary(let specified) = directory {
            var pathValue = NSTemporaryDirectory()
            if specified.count > 0 {
                pathValue = pathValue + "\(specified)"
                if createAllowed == true && LEYFS.fileExists(pathValue) == false {
                    LEYFS.createDirectory(pathValue)
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
    
    open class func file(_ directory:LEYFS.Directory, _ filename:String, _ createAllowed:Bool = true) -> String {
        var path = LEYFS.path(directory) + "/\(filename).json"
        if filename.contains(".json") {
            path = LEYFS.path(directory) + "/\(filename)"
        }
        if createAllowed == true && LEYFS.fileExists(path) == false {
            LEYFS.createFile(path)
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
        if LEYFS.fileExists(path) {
            return false
        }
        FileManager.default.createFile(atPath:path, contents:nil, attributes:nil)
        return true
    }
}

extension LEYFS {
    public static let file = LEYApp.namespace

    //setValue:写入数据
    open class func setValue(_ value: Any, forKey: String, directory: LEYFS.Directory, filename: String) {
        
        if case .bundle(_) = directory {
            return
        }
        
        //路径
        let path = LEYFS.file(directory, filename, true)
        
        //存储的key存在，则获取之前的map，通过key写入到该文件再存储
        if forKey.count > 0 {
            var map = LEYSerialization.data(toDictionary: LEYFS.contentsOf(path))
            map[forKey] = value
            
            let data = LEYSerialization.JSONObject(toData: map, options: [.prettyPrinted]) as NSData?
            let result = data?.write(toFile: path, atomically: true) ?? false
            LEYApp.print("JSON:save result is: \(String(describing: result))")
        }
        else{
            //存储的key不存在，则将内容直接存入该文件[这种需要验证传入值的类型为数组或者map
            if let mapValue = value as? [String:Any] {
                let data = LEYSerialization.JSONObject(toData: mapValue, options: [.prettyPrinted]) as NSData?
                let result = data?.write(toFile: path, atomically: true) ?? false
                LEYApp.print("JSON:save result is: \(String(describing: result))")
            }
            else if let arrValue = value as? [Any?] {
                let data = LEYSerialization.JSONObject(toData: arrValue, options: [.prettyPrinted]) as NSData?
                let result = data?.write(toFile: path, atomically: true) ?? false
                LEYApp.print("JSON:save result is: \(String(describing: result))")
            }
        }
    }
    
    //value(forKey:从json读取数据:默认不需要后缀名
    open class func value(forKey: String, directory: LEYFS.Directory, filename: String) -> Any? {
        return LEYFS.value(forKey: forKey, directory: directory, filename: filename, isDictionary: true)
    }
    
    open class func value(forKey: String, directory: LEYFS.Directory, filename: String, isDictionary:Bool) -> Any? {
        let path = LEYFS.file(directory,filename, false)
        if LEYFS.fileExists(path) {
            if isDictionary {
                let map = LEYSerialization.data(toDictionary: LEYFS.contentsOf(path))
                if forKey.count > 0 {
                    return map[forKey]
                }
                return map
            }
            else {
                return LEYSerialization.data(toArray: LEYFS.contentsOf(path))
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

extension LEYFS {
    open class MIME {
        static var mimes = [String:String]()
        
        public class func fetch(_ filename:String) -> String {
            var url : URL? = URL(string: filename)
            if filename.hasPrefix("http") == false {
                url = URL(fileURLWithPath: filename)
            }
            return LEYFS.MIME.fetchMIME(LEYApp.get(string:url?.pathExtension, ""))
        }
        
        public class func fetchMIME(_ fileExtension:String) -> String {
            if LEYFS.MIME.mimes.count == 0 {
                LEYFS.MIME.mimes[".png"] = "image/png"
                LEYFS.MIME.mimes[".jpg"] = "image/jpeg"
                LEYFS.MIME.mimes[".jpeg"] = "image/jpeg"
                LEYFS.MIME.mimes[".gif"] = "image/gif"
                LEYFS.MIME.mimes[".svg"] = "image/svg+xml"

                LEYFS.MIME.mimes[".mp3"] = "audio/x-mpeg"
                
                LEYFS.MIME.mimes[".mp4"] = "video/mp4"
                LEYFS.MIME.mimes[".mpg4"] = "video/mp4"
                
                LEYFS.MIME.mimes[".js"] = "application/x-javascript"
                //LEYFS.MIME.mimes[".css"] = "application/x-pointplus"//text/css
                //LEYFS.MIME.mimes[".ttf"] = "application/x-font-truetype"
                LEYFS.MIME.mimes[".html"] = "text/html"
            }
            if let value = LEYFS.MIME.mimes[fileExtension] {
                return value
            }
            return "application/octet-stream"
        }
        
    }
}

