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

        return true
    }
}

class EXSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        EXApp.naviController.setViewControllers([EXViewController()], animated: false)
        window.rootViewController = EXApp.naviController
        self.window = window
        window.makeKeyAndVisible()
    }
}
