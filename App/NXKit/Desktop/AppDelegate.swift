//
//  AppDelegate.swift
//  NXFoundation
//
//  Created by niegaotao on 03/26/2019.
//  Copyright (c) 2019 niegaotao. All rights reserved.
//

import UIKit
import NXKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var strongView : UIView? = nil
    
    weak var weakView : UIView? = nil


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NXApp.viewBackgroundColor = NXApp.color(NXApp.color(247, 247, 247), NXApp.color(0, 0, 0))
        NXApp.backgroundColor = NXApp.color(NXApp.color(255, 255, 255), NXApp.color(28, 28, 28))
        NXApp.darkBlackColor = NXApp.color(NXApp.color(30, 30, 30), NXApp.color(255, 255, 255))

        NXApp.Authorize.authorization = {
            (_ type: NXApp.AuthorizeType,
            _ queue:DispatchQueue,
            _ alert: Bool,
            _ completion:((NXApp.AuthorizeState) -> ())?) in
            
            RRXCAuthorizeManager.authorization(type, queue, completion, alert)
        }
        
        let nav = NXNavigationController()
        nav.pushViewController(NXDesktopViewController(), animated: true)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.strongView = testView
        self.weakView = testView
        print("testView=\(testView.hash);strongView=\(self.strongView!.hash);weakView=\(self.weakView!.hash)")
        print("testView=\(testView.hashValue);strongView=\(self.strongView!.hashValue);weakView=\(self.weakView!.hashValue)")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

