//
//  EXAppDelegate.swift
//  NXKit
//
//  Created by niegaotao on 09/18/2021.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import NXKit
import UIKit

@UIApplicationMain
class EXAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 授权
        NXKit.Imp.authorization = { type, queue, isAlertable, completion in
            EXApp.authorization(type, queue, completion, isAlertable)
        }

        NXKit.Imp.previewAssets = { (assets: [Any], _: Int) in
            if let __assets = assets as? [NXAsset] {
                EXApp.center.preview(__assets, 0)
            }
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        EXApp.naviController.pushViewController(EXViewController(), animated: false)
        window?.rootViewController = EXApp.naviController
        window?.makeKeyAndVisible()

        return true
    }
}
