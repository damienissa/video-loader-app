//
//  ViewControllersFactory.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 27.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import UIKit

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
