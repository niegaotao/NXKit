//
//  DispatchQueue+NXKit.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/5/25.
//  Copyright © 2018年 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/5/25.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
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





