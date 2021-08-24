//
//  NXWrappedViewController.swift
//  NXKit
//
//  Created by niegaotao on 2021/7/13.
//

import UIKit

open class NXWrappedViewController<WrappedView: UIView>: NXViewController {

    open var wrappedView : WrappedView? = nil
    
    open override func viewDidLoad() {
        super.viewDidLoad()

    }
}
