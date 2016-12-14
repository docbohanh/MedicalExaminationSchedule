//
//  AppDelegate.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 11/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyC5XSeP7MCiM5N9zlT9zM68folx1GD5dXw")
        GMSPlacesClient.provideAPIKey("AIzaSyC5XSeP7MCiM5N9zlT9zM68folx1GD5dXw")
        
        if (UserDefaults.standard.object(forKey:"token_id") == nil) {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            window!.rootViewController = loginViewController
        } else {
            let mainStoryBoard = UIStoryboard(name: "TabBar", bundle: nil)
            let tabbarViewController = mainStoryBoard.instantiateViewController(withIdentifier: "NSVTabBarController") as! NSVTabBarController
            window!.rootViewController = tabbarViewController
        }
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}

