//
//  NXRequest.swift
//  NXKit
//
//  Created by niegaotao on 2021/9/18.
//

import UIKit

open class NXRequest: NXAny {
    open var method = "post"
    
    open var service = ""
    
    open var path = ""
    open var url = ""
    open var headers = [String:String]()
    open var parameters = [String:Any]()
    
    open var isEncrypted = false //上行参数是否加密
    open var isDecrypted = false //下行参数是否解密
        
    open var code = -1
    open var error = ""
    open var data = [String:Any]()
    open var completion : NX.Completion<String, NXRequest>? = nil
    
    open var retry : Int = 0
}
