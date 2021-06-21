//
//  LEYSubscriber.swift
//  NXFoundation
//
//  Created by firelonely on 2020/7/12.
//

import UIKit

open class LEYSubscriber  {
    public static fileprivate(set) var items = [LEYSubscriber.Item]()
    public static var queue = DispatchQueue.main
    public static var delay : TimeInterval = 0.0
    
    open class Item : NSObject {
        weak open var observer : NSObject? = nil
        open var name = ""
        open var dispose : LEYApp.Completion<String, Any?>? = nil

        public init(observer:NSObject, name:String, dispose:LEYApp.Completion<String, Any?>?) {
            super.init()
            self.observer = observer
            self.name = name
            self.dispose = dispose
        }
        
        deinit {
            LEYApp.log { return "LEYSubscriber.Item"}
        }
    }
    
    open class func add(observer:NSObject?, name:String, dispose:LEYApp.Completion<String, Any?>?){
        self.clear()
        guard let __observer = observer, name.count > 0 else {
            return
        }

        if let item = self.items.first(where: { (item) -> Bool in return item.observer == __observer && item.name == name }) {
            item.dispose = dispose
        }
        else {
            let item = LEYSubscriber.Item(observer: __observer, name:name, dispose:dispose)
            self.items.append(item)
        }
    }
    
    open class func add(observer:NSObject?, names:[String], dispose:LEYApp.Completion<String, Any?>?){
        names.forEach { (name) in
            self.add(observer: observer, name:name, dispose:dispose)
        }
    }
    
    open class func post(name: String, info: Any?, queue:DispatchQueue = LEYSubscriber.queue, delay:TimeInterval = LEYSubscriber.delay){
        self.clear()
        
        self.items.forEach { (item) in
            if item.name == name {
                queue.asyncAfter(deadline: .now() + delay) {
                    item.dispose?(name, info)
                }
            }
        }
    }
    
    open class func remove(observer:NSObject?, name:String?){
        self.clear()
        
        if let __observer = observer, let __name = name, __name.count > 0 {
            self.items.removeAll { (item) -> Bool in
                return item.observer == __observer && item.name == name
            }
        }
        else {
            self.items.removeAll { (item) -> Bool in
                return item.observer == observer || item.name == name
            }
        }
    }
    
    open class func clear(){
        self.items.removeAll { (item) -> Bool in
            return item.observer == nil
        }
    }
}
