//
//  AppDelegate.swift
//  To-Do-List
//
//  Created by Harshal on 8/19/17.
//  Copyright © 2017 Harshal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupTabBar()
        
        return true
    }
}

