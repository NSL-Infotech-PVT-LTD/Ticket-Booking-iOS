//
//  AppDelegate.swift
//  DemoDesignBreadmen
//
//  Created by Loveleen Kaur Atwal on 08/08/19.
//  Copyright © 2019 Loveleen Kaur. All rights reserved.
//

import UIKit
import IQKeyboardManager
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = self.window ?? UIWindow()
        IQKeyboardManager.shared().isEnabled = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true

        self.checkUserLogin()
        return true
    }
    
    
    func checkUserLogin()  {
           if let isLogin = UserDefaults.standard.bool(forKey: UserdefaultKeys.isLogin) as? Bool{
               if isLogin == true{
                   
                   let vc = UIStoryboard(name: "Main", bundle: nil)
                   let vc1 = vc.instantiateViewController(withIdentifier: "DashboardTabBarController")
                   
                   let navigationController = UINavigationController(rootViewController: vc1)
                   navigationController.isNavigationBarHidden = true
                   UIApplication.shared.windows.first?.rootViewController = navigationController
                   UIApplication.shared.windows.first?.makeKeyAndVisible()

               }else{
                   
                   let vc = UIStoryboard(name: "Main", bundle: nil)
                                  let vc1 = vc.instantiateViewController(withIdentifier: "WalkThroughVC")
                                  let navigationController = UINavigationController(rootViewController: vc1)
                                  navigationController.isNavigationBarHidden = true
                                  UIApplication.shared.windows.first?.rootViewController = navigationController
                                  UIApplication.shared.windows.first?.makeKeyAndVisible()
               }
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

