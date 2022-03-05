//
//  NXAlbumViewController.swift
//  NXKit
//
//  Created by 聂高涛 on 2022/3/5.
//

import UIKit

open class NXAlbumViewController: NXWrappedViewController<NXWrappedNavigationController<NXAlbumAssetsViewController>> {
    
    open var wrapped : NXAsset.Wrapped {
        self.viewController.viewController.getWrapped()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
}
