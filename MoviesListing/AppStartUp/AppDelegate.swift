//
//  AppDelegate.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 28/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//
import Alamofire
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var navigator = AppNavigator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigator.installRoot(into: window)
        window?.makeKeyAndVisible()
        return true
    }
}

