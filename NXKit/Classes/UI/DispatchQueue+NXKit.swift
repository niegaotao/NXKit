//
//  DispatchQueue+NXKit.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/25.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    private static var tokens = [String]()
    public class func once(token: String, block: ()->Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if DispatchQueue.tokens.contains(token) {
            return
        }
        
        DispatchQueue.tokens.append(token)
        block()
    }
    
    public func asyncAfter(delay: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: execute)
    }
}





