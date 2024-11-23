//
//  NXKit+DispatchQueue.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/25.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public extension DispatchQueue {
    private static var tokens = [String]()
    class func once(token: String, block: () -> Void) {
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

    func asyncAfter(delay: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: execute)
    }
}
