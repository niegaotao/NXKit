//
//  NXApi.swift
//  NXKit
//
//  Created by 聂高涛 on 2021/8/15.
//

import UIKit

open class NXApi {
    //request
    class public func request(_ request:NXRequest, _ completion:NX.Completion<String, NXRequest>?) {
        NX.Imp.request?(request, completion)
    }
}
