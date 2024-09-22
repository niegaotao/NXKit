//
//  EXAppDelegate.swift
//  NXKit
//
//  Created by niegaotao on 09/18/2021.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit
import NXKit

@UIApplicationMain
class EXAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //授权
        NXKit.Imp.authorization = { (type, queue, isAlertable ,completion) in
            EXApp.authorization(type, queue, completion, isAlertable)
        }
        
        NXKit.Imp.previewAssets = {(assets:[Any], index:Int) in
            if let __assets = assets as? [NXAsset] {
                EXApp.center.preview(__assets, 0)
            }
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        EXApp.naviController.pushViewController(EXViewController(), animated: false)
        self.window?.rootViewController = EXApp.naviController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

