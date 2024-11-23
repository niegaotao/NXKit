//
//  NXAlbumViewController.swift
//  NXKit
//
//  Created by niegaotao on 2022/3/5.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import UIKit

open class NXAlbumViewController: NXWrappedViewController<NXWrappedNavigationController<NXAlbumAssetsViewController>> {
    open var wrapped: NXAsset.Wrapped {
        viewController.viewController.getWrapped()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}
