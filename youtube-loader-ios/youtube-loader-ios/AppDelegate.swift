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
        let nc = UINavigationController()
        nc.setRootWireframe(DashboardWireframe())
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        return true
    }
}

