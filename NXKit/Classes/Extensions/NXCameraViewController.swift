//
//  NXCameraViewController.swift
//  NXKit
//
//  Created by 聂高涛 on 2022/3/5.
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
