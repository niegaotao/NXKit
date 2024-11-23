//
//  NXKVOObserver.swift
//  NXKit
//
//  Created by niegaotao on 2021/7/12.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXKVOObserver: NSObject {
    public fileprivate(set) weak var observer: NSObject? = nil
    public fileprivate(set) var observations = [NXKVOObserver.Observation]()

    open class Observation: NSObject {
        open weak var object: NSObject? = nil
        open var key = ""
        open var options: NSKeyValueObservingOptions = []
        open var context: UnsafeMutableRawPointer? = nil
        open var completion: NXKit.Event<String, [NSKeyValueChangeKey: Any]?>? = nil

        public init(object: NSObject, key: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?, completion: NXKit.Event<String, [NSKeyValueChangeKey: Any]?>?) {
            self.object = object
            self.key = key
            self.options = options
            self.context = context
            self.completion = completion
        }
    }

    public init(observer: NSObject) {
        self.observer = observer
    }

    open func add(object: NSObject, key: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer? = nil, completion: NXKit.Event<String, [NSKeyValueChangeKey: Any]?>? = nil) {
        if observations.contains(where: { kvo in kvo.object == object && kvo.key == key }) {}
        else {
            let observation = NXKVOObserver.Observation(object: object, key: key, options: options, context: context, completion: completion)
            observations.append(observation)
            object.addObserver(self, forKeyPath: key, options: options, context: context)
        }
    }

    open func remove(object: NSObject, key: String) {
        if let index = observations.firstIndex(where: { kvo in kvo.object == object && kvo.key == key }) {
            observations.remove(at: index)
            object.removeObserver(self, forKeyPath: key)
        }
    }

    open func removeAll() {
        for observation in observations {
            observation.object?.removeObserver(self, forKeyPath: observation.key)
        }
        observations.removeAll()
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let __object = object as? NSObject, let observation = observations.first(where: { kvo in kvo.object == __object && kvo.key == keyPath }) {
            if observation.completion != nil {
                observation.completion?(observation.key, change)
            } else if let __observer = observer, __observer.responds(to: #selector(NSObject.observeValue(forKeyPath:of:change:context:))) == true {
                __observer.observeValue(forKeyPath: observation.key, of: observation.object, change: change, context: context)
            }
        }
    }

    deinit {
        NXKit.print(NSStringFromClass(self.classForCoder))
    }
}
