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

struct ViewControllersFactory {
    
    static func searchViewController() -> UIViewController {
        
        let nc = UINavigationController()
        nc.setRootWireframe(DashboardWireframe())
        nc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return nc
    }
    
    static func recentViewController() -> UIViewController {
        
        let nc = UINavigationController()
        nc.setRootWireframe(RecentWireframe())
        nc.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        
        return nc
    }
}
