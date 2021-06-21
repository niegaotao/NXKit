//
//  AppDelegate.swift
//  LEYFoundation
//
//  Created by niegaotao on 03/26/2019.
//  Copyright (c) 2019 niegaotao. All rights reserved.
//

import UIKit
import NXKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LEYApp.viewBackgroundColor = LEYApp.color(LEYApp.color(247, 247, 247), LEYApp.color(0, 0, 0))
        LEYApp.backgroundColor = LEYApp.color(LEYApp.color(255, 255, 255), LEYApp.color(28, 28, 28))
        LEYApp.darkBlackColor = LEYApp.color(LEYApp.color(30, 30, 30), LEYApp.color(255, 255, 255))
        //LEYApp.Animation.animationClass = RRXCAnimationView.self

        LEYApp.Authorize.authorization = {
            (_ type: LEYApp.AuthorizeType,
            _ queue:DispatchQueue,
            _ alert: Bool,
            _ completion:((LEYApp.AuthorizeState) -> ())?) in
            
            RRXCAuthorizeManager.authorization(type, queue, completion, alert)
        }
        
        let nav = LEYNavigationController()
        nav.pushViewController(NXDesktopViewController(), animated: true)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        
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

