//
//  AppDelegate.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var nasaTabBarController: NasaTabbarController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        nasaTabBarController = NasaTabbarController()
        window?.rootViewController = nasaTabBarController
        window?.makeKeyAndVisible()

        return true
    }
}

