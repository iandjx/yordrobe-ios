//
//  AppDelegate.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/12/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import IQKeyboardManagerSwift
import PopupDialog
import ESTabBarController_swift
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var dic_filterProduct: Dictionary! = [:]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        IQKeyboardManager.shared.enable = true
        // Pay pal 
        
        //TODO: - Enter your credentials
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "Aa5BwLbBbHBqkc2LA7xIzNRlIck5we_wlvzQLePJNFVv-ZSvFt1H0IPT2YWPbHAetW6UKEi_mH8GpLNV", PayPalEnvironmentSandbox: "AeB87QqlMOr_0-345GYchDNJJ5gTbOXI5N-taFuFcLbGjfGWE2REesLLXNEOkulv0rQeoB7tf80hyvgK"])
        
        // Customize overlay appearance
        
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled = true
        ov.blurRadius  = 20
        ov.liveBlur    = true
        ov.opacity     = 0.2
        ov.color       = UIColor.lightGray
        let buttonAppearance = DefaultButton.appearance()
        // Default button
        //buttonAppearance.titleFont      = UIFont.systemFont(ofSize: 14)
        buttonAppearance.titleColor     = UIColor(red: 185/255, green: 139/255, blue: 87/255, alpha: 1)
        buttonAppearance.buttonColor    = UIColor.clear
        buttonAppearance.separatorColor = UIColor(white: 0.9, alpha: 1)
        
        
      
      
        
        /*
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "W9wZWBHzfr34FARmYJRJTAvcebPIxKfdPOffYqSC"
            ParseMutableClientConfiguration.clientKey = "b07l11egtcd5eNeM5d7bUEtKT8u6QdyIPs7GJugL"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
        })
        Parse.initialize(with: parseConfiguration)
        */
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "bRdYRbNcL4ljBBkzemivt9C0WoX4thFUe9itX9gU"
            ParseMutableClientConfiguration.clientKey = "EI9kfM3AdhMq0ONDBGWG9B135vZxZfcWr3qt9iGk"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
         //   PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
        })
        Parse.initialize(with: parseConfiguration)
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
       // PFACL.setDefault(PFACL(), withAccessForCurrentUser: true)
        // Push notification 
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard error == nil else { return }
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }else {
            }
        }
        //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        // Auto login feature
        let storyboard = grabStoryboard()
        let defaults = UserDefaults.standard
        let userLogin = defaults.object(forKey: "autoLogin")
          //defaults.set(false, forKey: "isPopUp")
        if let userlogin = userLogin {
            print("userlogin == \(userlogin)")
            // Store the deviceToken in the current installation and save it to Parse.
            let installation =  PFInstallation.current()
            if (installation != nil) {
                installation?.setDeviceTokenFrom(deviceToken_data)
                installation?.setObject(PFUser.current()!, forKey: "user")
                installation?.saveEventually()
            }
            self.window?.rootViewController = ExampleProvider.customIrregularityStyle(delegate: nil)
        }else {
            //let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }

        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    var deviceToken_data : Data!
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
       let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        deviceToken_data = deviceToken
        // Store the deviceToken in the current installation and save it to Parse.
        let installation =  PFInstallation.current()
        if (installation != nil) {
            installation?.setDeviceTokenFrom(deviceToken)
            installation?.saveEventually()
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        
        print("i am not available in simulator === \(error)")
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    
    {
        print("user info == \(userInfo)")
        switch application.applicationState
        {
        case .inactive:
            self.App_inBackgroundMode(application: application, data: userInfo)
            completionHandler(.newData)
        case .background:
            completionHandler(.newData)
        case .active:
            completionHandler(.newData)
        }
    }
    
    var isPushRecieved = false
    func App_inBackgroundMode(application: UIApplication, data:Dictionary<AnyHashable, Any>) -> Void
        
    {
        isPushRecieved = true
        self.window?.rootViewController = ExampleProvider.customIrregularityStyle(delegate: nil)
//        if data["reason"] as? String == "Comment" {
//            isPushRecieved = true
//            self.window?.rootViewController = ExampleProvider.customIrregularityStyle(delegate: nil)
//        }
    }
    

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        completionHandler(UIBackgroundFetchResult.noData)
//    }
//    func grabStoryboard() -> UIStoryboard {
//        
//        var storyboard: UIStoryboard
//        if DeviceType.IS_IPHONE_4_OR_LESS {
//            storyboard = UIStoryboard(name: "Main4", bundle: nil)
//        }
//        else if DeviceType.IS_IPHONE_5 {
//            storyboard = UIStoryboard(name: "Main", bundle: nil)
//        }
//        else{
//            storyboard = UIStoryboard(name: "Main", bundle: nil)
//        }
//        
//        return storyboard
//    }

//    func applicationWillResignActive(_ application: UIApplication) {
//        FBSDKAppEvents.activateApp()
//    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        AppEvents.singleton.activateApp()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        let installation =  PFInstallation.current()
        if (installation != nil) {
            installation?.badge = 0
            installation?.saveEventually()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

