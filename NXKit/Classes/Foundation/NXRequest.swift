//
//  NXRequest.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/18.
//

import UIKit

public protocol NXRequestProtocol {
    var method : String {set get}
    var service : String {set get}
    
    var path : String {set get}
    var url : String {set get}
    var headers : [String:String] {set get}
    var parameters : [String:Any] {set get}

    var isEncrypted : Bool {set get} //上行参数是否加密
    var isDecrypted : Bool {set get} //下行参数是否解密

    var code : Int {set get}
    var error : String {set get}
    var data : [String:Any] {set get}
    var completion : NX.Completion<String, NXRequestProtocol>? {set get}

    var retry : Int {set get}
    var isDisposeable : Bool {set get}
}

open class NXRequest: NXAny, NXRequestProtocol {    
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
    open var completion : NX.Completion<String, NXRequestProtocol>? = nil
    
    open var retry : Int = 0
    open var isDisposeable = true
    
    public override init(){
        super.init()
    }
}
