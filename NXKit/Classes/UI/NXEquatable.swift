//
//  NXEquatable.swift
//  NXKit
//
//  Created by niegaotao on 2021/9/8.
//

import UIKit

open class NXEquatable: Equatable {
    
    public static func == (lhs: NXEquatable, rhs: NXEquatable) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
