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
import Alamofire
import FacebookCore
import FacebookLogin
import FacebookShare
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyBDDZ_L9mBeSxL1A0ZZbG8Oc1_yVT_9V9s")
        GMSPlacesClient.provideAPIKey("AIzaSyBDDZ_L9mBeSxL1A0ZZbG8Oc1_yVT_9V9s")
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if (UserDefaults.standard.object(forKey:"token_id") == nil) {
            let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let rootNavigation = UINavigationController.init(rootViewController: loginViewController)
            loginViewController.navigationController?.navigationBar.isHidden = true
            window!.rootViewController = rootNavigation
        } else {
//            let tabBarViewController = NSVTabBarController()
            let tabBarViewController = mainStoryBoard.instantiateViewController(withIdentifier: "NSVTabBarController") as! NSVTabBarController
            let rootNavigation = UINavigationController.init(rootViewController:tabBarViewController)
            tabBarViewController.navigationController?.navigationBar.isHidden = true
            window!.rootViewController = rootNavigation
        }
        // Override point for customization after application launch.
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if(url.scheme!.isEqual("fb173352946462694")) {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
            
        } else {
            return GIDSignIn.sharedInstance().handle(url as URL!,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
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
    
    private func trustIsValid(_ trust: SecTrust) -> Bool {
        var isValid = false
        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)
    
        if status == errSecSuccess {
            let unspecified = SecTrustResultType.unspecified
            let proceed = SecTrustResultType.proceed
    
    
            isValid = result == unspecified || result == proceed
        }
    
        return isValid
    }
    
    
    
}

