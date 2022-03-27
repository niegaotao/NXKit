//
//  NXObserver.swift
//  NXKit
//
//  Created by niegaotao on 2021/7/12.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXKVOObserver : NSObject {
    public fileprivate(set) weak var observer : NSObject? = nil
    public fileprivate(set) var observations = [NXKVOObserver.Observation]()
    
    open class Observation : NSObject {
        weak open var object : NSObject? = nil
        open var key = ""
        open var options: NSKeyValueObservingOptions = []
        open var context: UnsafeMutableRawPointer? = nil
        open var completion : NX.Completion<String, [NSKeyValueChangeKey : Any]?>? = nil
        
        public init(object:NSObject, key:String, options:NSKeyValueObservingOptions, context:UnsafeMutableRawPointer?, completion:NX.Completion<String, [NSKeyValueChangeKey : Any]?>?) {
            self.object = object
            self.key = key
            self.options = options
            self.context = context
            self.completion = completion
        }
    }
    
    public init(observer:NSObject) {
        self.observer = observer
    }
    
    open func add(object: NSObject, key: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer? = nil, completion:NX.Completion<String, [NSKeyValueChangeKey : Any]?>? = nil){
        if self.observations.contains(where: { kvo in return kvo.object == object && kvo.key == key}) {
            
        }
        else {
            let observation = NXKVOObserver.Observation(object: object, key: key, options:options, context: context, completion: completion)
            self.observations.append(observation)
            object.addObserver(self, forKeyPath: key, options: options, context: context)
        }
    }
    
    open func remove(object: NSObject, key: String) {
        if let index = self.observations.firstIndex(where: { kvo in return kvo.object == object && kvo.key == key}){
            self.observations.remove(at: index)
            object.removeObserver(self, forKeyPath: key)
        }
    }
    
    open func removeAll() {
        for observation in self.observations {
            observation.object?.removeObserver(self, forKeyPath: observation.key)
        }
        self.observations.removeAll()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let __object = object as? NSObject, let observation = self.observations.first(where: { kvo in return kvo.object == __object && kvo.key == keyPath}){
            if observation.completion != nil {
                observation.completion?(observation.key, change)
            }
            else if let __observer = self.observer,__observer.responds(to: #selector(NSObject.observeValue(forKeyPath:of:change:context:))) == true {
                __observer.observeValue(forKeyPath: observation.key, of: observation.object, change: change, context: context)
            }
        }
    }
    
    deinit {
        NX.print(NSStringFromClass(self.classForCoder))
    }
}
