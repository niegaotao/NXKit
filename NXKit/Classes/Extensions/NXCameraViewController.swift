//
//  NXCameraViewController.swift
//  NXKit
//
//  Created by niegaotao on 2022/3/5.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import UIKit

open class NXCameraViewController: NXWrappedViewController<NXCameraCaptureController> {

    open var wrapped : NXAsset.Wrapped {
        self.viewController.getWrapped()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
