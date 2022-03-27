//
//  NXApi.swift
//  NXKit
//
//  Created by niegaotao on 2021/8/15.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit

open class NXApi {
    //request
    class public func request(_ request:NXRequest, _ completion:NX.Completion<String, NXRequest>?) {
        NX.Imp.request?(request, completion)
    }
}
