//
//  NXAny.swift
//  NXKit
//
//  Created by niegaotao on 2021/9/8.
//

import UIKit

open class NXAny: Equatable {
    
    public static func == (lhs: NXAny, rhs: NXAny) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
