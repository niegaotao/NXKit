//
//  NXStorage.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import Foundation

//NSString, NSData, NSNumber, NSDate, NSArray, and NSDictionary

open class NXStorage {
    public static let center = NXStorage()
    public fileprivate(set) var rootValue = [String: Any]()
    public fileprivate(set) var rootKey = "__rootKey"
    public init(){
        if let __rootValue = UserDefaults.standard.object(forKey: rootKey) as? [String: Any]{
            self.rootValue = __rootValue;
        }
    }
    
    @discardableResult
    open func value(forKey key: String) -> Any? {
        if let __value = self.rootValue[key] {
            return __value
        }
        return nil
    }
    
    @discardableResult
    open func set(_ value: Any?, forKey key: String) -> Bool {
        guard key.count > 0 else {
            return false
        }
        if let value = value {
            self.rootValue[key] = value
        }
        else {
            self.rootValue.removeValue(forKey: key)
        }
        UserDefaults.standard.setValue(self.rootValue, forKey: self.rootKey)
        UserDefaults.standard.synchronize()
        return true
    }
    
    @discardableResult
    open func removeValue(forKey key: String) -> Bool {
        guard key.count > 0 else {
            return false
        }
        self.rootValue.removeValue(forKey: key)
        UserDefaults.standard.setValue(self.rootValue, forKey: self.rootKey)
        UserDefaults.standard.synchronize()
        return true
    }
}
