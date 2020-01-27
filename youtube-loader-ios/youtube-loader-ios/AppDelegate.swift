//
//  AppDelegate.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
    
        window?.rootViewController = TabBarViewController(controllers: [ViewControllersFactory.searchViewController(), ViewControllersFactory.recentViewController()])
        window?.makeKeyAndVisible()
        
        return true
    }
}
