//
//  AppDelegate.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 11/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation
import CoreData
import GooglePlaces
import GoogleMaps
import Alamofire
import FacebookCore
import FacebookLogin
import FacebookShare
import Google
import MagicalRecord

protocol AlarmApplicationDelegate
{
    
    func playAlarmSound(_ soundName: String)
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate {

    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var audioPlayer: AVAudioPlayer?
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        MagicalRecord.setupCoreDataStack(withStoreNamed: "medhub.sqlite")
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey("AIzaSyADBdp9CDPnMRv3O9VTIt2As2kTOv4yEFY")
        GMSPlacesClient.provideAPIKey("AIzaSyADBdp9CDPnMRv3O9VTIt2As2kTOv4yEFY")
//        GMSServices.provideAPIKey("AIzaSyChOnJLUwPBEYI5IVmg7wXpfJSBaFcYIR4")
//        GMSPlacesClient.provideAPIKey("AIzaSyChOnJLUwPBEYI5IVmg7wXpfJSBaFcYIR4")

        alarmScheduler.setupNotificationSettings()
        
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
        
        
        //Config GAI
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
        }
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.verbose  // remove before app release
        gai.dispatchInterval = 10 // default = 120 giây
        
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
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        /*AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
         nil,
         vibrationCallback,
         nil)*/
        //if app is in foreground, show a alert
        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
        //todo, snooze
        var isSnooze: Bool = false
        var soundName: String = ""
        var index: Int = -1
        if let userInfo = notification.userInfo {
            isSnooze = userInfo["snooze"] as! Bool
            soundName = userInfo["soundName"] as! String
            index = userInfo["index"] as! Int
        }
        
        playAlarmSound(soundName)
        
        
        
        if isSnooze  == true
        {
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let now = Date()
            //snooze 9 minutes later
            let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 9, to: now, options:.matchStrictly)!
            
            let snoozeOption = UIAlertAction(title: "Snooze", style: .default) {
                (action:UIAlertAction)->Void in self.audioPlayer?.stop()
                
                self.alarmScheduler.setNotificationWithDate(snoozeTime, onWeekdaysForNotify: [Int](), snooze: true, soundName: soundName, index: index)
            }
            storageController.addAction(snoozeOption)
        }
        let stopOption = UIAlertAction(title: "OK", style: .default) {
            (action:UIAlertAction)->Void in self.audioPlayer?.stop()
            Alarms.sharedInstance.setEnabled(false, AtIndex: index)
            let vc = self.window?.rootViewController! as! UINavigationController
            let cells = (vc.topViewController as! MainAlarmViewController).tableView.visibleCells
            for cell in cells
            {
                if cell.tag == index{
                    let sw = cell.accessoryView as! UISwitch
                    sw.setOn(false, animated: false)
                }
            }}
        
        storageController.addAction(stopOption)
        
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewVC = storyboard.instantiateViewController(withIdentifier: "CustomAlarmViewController")
        
        window?.rootViewController!.present(viewVC, animated: true, completion: nil)
        
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void){
    if identifier == "mySnooze"
    {
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let now = Date()
    let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 9, to: now, options:.matchStrictly)!
    var soundName: String = ""
    var index: Int = -1
    if let userInfo = notification.userInfo {
    soundName = userInfo["soundName"] as! String
    index = userInfo["index"] as! Int
    self.alarmScheduler.setNotificationWithDate(snoozeTime, onWeekdaysForNotify: [Int](), snooze: true, soundName: soundName, index: index)
    }
    }
    completionHandler()
    }
    //print out all registed NSNotification for debug
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        print(notificationSettings.types.rawValue)
    }
    
    //AlarmApplicationDelegate protocol
    func playAlarmSound(_ soundName: String) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        let url = URL(
            fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
    
    
    
    
    
    //todo,vibration infinity
    func vibrationCallback(_ id:SystemSoundID, _ callback:UnsafeMutableRawPointer) -> Void
    {
        print("callback", terminator: "")
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully
        flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer,
                                        error: Error?) {
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
    }

}

