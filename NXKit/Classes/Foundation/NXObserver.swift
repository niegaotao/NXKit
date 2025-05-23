//
//  NXObserver.swift
//  NXKit
//
//  Created by niegaotao on 2021/7/12.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXObserver {
    public fileprivate(set) static var sets = NSMapTable<AnyObject, NXObserver.Array>(keyOptions: [.weakMemory], valueOptions: [.strongMemory])

    open class Array: NSObject {
        open var observations = [NXObserver.Observation]()

        deinit {
            NXKit.print(NSStringFromClass(self.classForCoder))
        }
    }

    open class Observation: NSObject {
        open var name = ""
        open var dispose: NXKit.Event<String, Any?>? = nil

        public init(name: String, dispose: NXKit.Event<String, Any?>?) {
            super.init()
            self.name = name
            self.dispose = dispose
        }

        deinit {
            NXKit.print(NSStringFromClass(self.classForCoder))
        }
    }

    open class func add(observer: AnyObject?, name: String, dispose: NXKit.Event<String, Any?>?) {
        guard let __observer = observer, name.count > 0 else {
            return
        }

        let array = sets.object(forKey: observer) ?? NXObserver.Array()
        if let observation = array.observations.first(where: { item -> Bool in return item.name == name }) {
            observation.dispose = dispose
        } else {
            let observation = NXObserver.Observation(name: name, dispose: dispose)
            array.observations.append(observation)
            sets.setObject(array, forKey: __observer)
        }
    }

    open class func add(observer: AnyObject?, names: [String], dispose: NXKit.Event<String, Any?>?) {
        for name in names {
            add(observer: observer, name: name, dispose: dispose)
        }
    }

    open class func post(name: String, info: Any?) {
        for observer in sets.keyEnumerator() {
            if let array = sets.object(forKey: observer as AnyObject) {
                for observation in array.observations {
                    if observation.name == name {
                        observation.dispose?(name, info)
                    }
                }
            }
        }
    }

    open class func remove(observer: AnyObject?, name: String?) {
        if let __observer = observer, let array = sets.object(forKey: __observer) {
            if let __name = name, __name.count > 0 {
                array.observations.removeAll { item -> Bool in return item.name == __name }

                if array.observations.count > 0 {
                    sets.setObject(array, forKey: __observer)
                } else {
                    sets.removeObject(forKey: __observer)
                }
            } else {
                sets.removeObject(forKey: observer)
            }
        }
    }
}
