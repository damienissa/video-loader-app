//
//  TabBarViewController.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    convenience init(controllers: [UIViewController]) {
        self.init()
        
        viewControllers = controllers
    }
}
