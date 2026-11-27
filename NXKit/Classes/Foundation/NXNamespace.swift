//
//  NXNamespace.swift
//  NXKit
//
//  Created by niegaotao on 2020/1/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

public struct NXNamespace<RawValue> {
    public let rawValue : RawValue
    public init(_ rawValue:RawValue){
        self.rawValue = rawValue
    }
}

public protocol NXNamespaceReferenceWrappable : AnyObject {}
    
extension NXNamespaceReferenceWrappable {
    public var nx : NXNamespace<Self> {
        set { }
        get { return NXNamespace<Self>(self) }
    }
    
    static public var nx : NXNamespace<Self>.Type {
        set { }
        get { return NXNamespace<Self>.self }
    }
}

public protocol NXNamespaceValueWrappable {}
    
extension NXNamespaceValueWrappable {
    public var nx : NXNamespace<Self> {
        set { }
        get { return NXNamespace<Self>(self) }
    }
    
    static public var nx : NXNamespace<Self>.Type {
        set { }
        get { return NXNamespace<Self>.self }
    }
}

/*
/*1.让类遵守协议*/
extension UIView : NXNamespaceReferenceWrappable {}
 
/*2.扩展NXNamespace*/
extension NXNamespace where RawValue : UIView {
    public func debug(){
        print("NXNamespace-UIView:frame=\(self.rawValue.frame)");
    }
}
/*使用*/
func test(){
    let v = UIView()
    v.nx.debug()
    v.nx.debug()
}
*/

