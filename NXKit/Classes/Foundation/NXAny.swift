//
//  NXAny.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/8.
//  Copyright (c) 2020 niegaotao. All rights reserved.
//

import UIKit

open class NXAny: Equatable {
    public static func == (lhs: NXAny, rhs: NXAny) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public required init() {}
}
