//
//  AppDelegate.swift
//  CoreDataDemo
//
//  Created by Вадим on 29.10.2020.
//  Copyright © 2020 Vadim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}

