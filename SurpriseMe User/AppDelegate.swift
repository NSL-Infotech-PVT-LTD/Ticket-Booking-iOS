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
import GoogleMaps
import GooglePlaces
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK:- Varible -
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setInitialSetup()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        //    //MARK: FIREBASE DEVICE TOKEN
               if #available(iOS 10.0, *) {
                   // For iOS 10 display notification (sent via APNS)
                   UNUserNotificationCenter.current().delegate = self
                   
                   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                   UNUserNotificationCenter.current().requestAuthorization(
                       options: authOptions,
                       completionHandler: {_, _ in })
               } else {
                   let settings: UIUserNotificationSettings =
                       UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                   application.registerUserNotificationSettings(settings)
               }
               
               application.registerForRemoteNotifications()
        
        Stripe.setDefaultPublishableKey(StringFile.Publish_Key)

        self.checkUserLogin()
        return true
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }

    
    //MARK:- Set Initial Function -
    func setInitialSetup()  {
        self.window = self.window ?? UIWindow()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        GMSServices.provideAPIKey("AIzaSyAeRjBp9uCEHLe-dIdsGVKegO9KzsmHmwA")
        GMSPlacesClient.provideAPIKey("AIzaSyAeRjBp9uCEHLe-dIdsGVKegO9KzsmHmwA")
        self.checkUserLogin()
        SocketConnectionManager.shared.socket.connect()
    }
    

    //MARK:- Funtion check whether user is login or not -
    func checkUserLogin()  {
        let lang = UserDefaults.standard.value(forKey: "app_lang") as? String ?? ""
        if lang == nil || lang == "" || lang.isEmpty == true {
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }else{
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
                    let vc1 = vc.instantiateViewController(withIdentifier: "LanguageVC")
                    let navigationController = UINavigationController(rootViewController: vc1)
                    navigationController.isNavigationBarHidden = true
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
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
        SocketConnectionManager.shared.socket.disconnect()

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        SocketConnectionManager.shared.socket.disconnect()

    }
    
}

// [START ios_10_message_handling]
@available(iOS 12.0, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        print("the bookking id is \(userInfo["target_id"])")
        
        print("the bookking id is \(userInfo[""])")

        
        if let userInfo = notification.request.content.userInfo as? [String : Any] {
                  print(userInfo["target_id"])
            
            
            
        }
        print("the bookking id iswithCompletionHandler \(userInfo["target_id"] ?? 0)")
               userArtistIDBooking = userInfo["target_id"] as? Int

               
               
//               if let userInfo = notification.request.content.userInfo as? [AnyHashable : Any] {
//                   let bookingID = userInfo["target_id"] ?? 0
//                   userArtistIDBooking = userInfo["target_id"]
//                   let bookingStatus = userInfo["target_model"] ?? ""
//                if bookingStatus as! String == "Booking"{
//                               let rootViewController = self.window!.rootViewController as? UINavigationController
//        let mainStoryboard = UIStoryboard(name: "BookingDetail", bundle: nil)
//
//
//                                      if let bookigDetail = mainStoryboard.instantiateViewController(withIdentifier: "BookingDetailVC") as? BookingDetailVC{
//                                       bookigDetail.bookingIDNotification = userArtistIDBooking ?? 0
//                                      // bookigDetail.bookingID = (bookingID as? Int)!
//
//
//                                          bookigDetail.isComingFrom = "NotificationCame"
//                                        rootViewController?.pushViewController(bookigDetail, animated: true)
//
//                           }else{
//                               
//                           }
//                           }else{
//                   //
//                   //
//                           }
//                   
//                   
//               }
               

            
          

                
//                rootViewController.pushViewController(bookigDetail, animated: true)
//                                                   rootViewController.pushViewController(bookigDetail, animated: true)

            
//                                  let controller = mainStoryboard.instantiateViewController(withIdentifier: "BookingDetails") as! BookingDetails
//           controller.bookingID = userInfo["target_id"] ?? 0
//                                   rootViewController.pushViewController(controller, animated: true)

        
        
        completionHandler([[.alert, .sound]])
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
              let stripeHandled = Stripe.handleURLCallback(with: url)
              if stripeHandled {
               let urlString = url.absoluteString
               let string = urlString
               if string.range(of:"failed") != nil {
                   print("exists")
                   idealPaymentFailed = true
                   let vc = UIStoryboard(name: "Dashboard", bundle: nil)
                   let vc1 = vc.instantiateViewController(withIdentifier: "LoaderVC")
                   let navigationController = UINavigationController(rootViewController: vc1)
                   navigationController.isNavigationBarHidden = true
                   UIApplication.shared.windows.first?.rootViewController = navigationController
                   UIApplication.shared.windows.first?.makeKeyAndVisible()
               }else{
                   print("hello")
                   idealPaymentFailed = false
                   let vc = UIStoryboard(name: "Dashboard", bundle: nil)
                   let vc1 = vc.instantiateViewController(withIdentifier: "LoaderVC")
                   let navigationController = UINavigationController(rootViewController: vc1)
                   navigationController.isNavigationBarHidden = true
                   UIApplication.shared.windows.first?.rootViewController = navigationController
                   UIApplication.shared.windows.first?.makeKeyAndVisible()
               }

                  return true
              }
           
           
          
      
              return false
          }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        print("the bookking id iswithCompletionHandler \(userInfo["target_id"] ?? 0)")
        userArtistIDBooking = userInfo["target_id"] as? Int

        
        
        if let userInfo = response.notification.request.content.userInfo as? [AnyHashable : Any] {
            let bookingID = userInfo["target_id"] ?? 0
            userArtistIDBooking = userInfo["target_id"]
            let bookingStatus = userInfo["target_model"] ?? ""
         if bookingStatus as! String == "Booking"{
                        let rootViewController = self.window!.rootViewController as! UINavigationController
 let mainStoryboard = UIStoryboard(name: "BookingDetail", bundle: nil)


                               if let bookigDetail = mainStoryboard.instantiateViewController(withIdentifier: "BookingDetailVC") as? BookingDetailVC{
                                bookigDetail.bookingIDNotification = userArtistIDBooking ?? 0
                               // bookigDetail.bookingID = (bookingID as? Int)!


                                   bookigDetail.isComingFrom = "NotificationCame"
                                   rootViewController.pushViewController(bookigDetail, animated: true)

                    }else{
                        
                    }
                    }else{
            //
            //
                    }
            
            
        }
        
        
        
            
            
               

//            rootViewController.pushWithAnimate(StoryName: "BookingDetail", Controller: "BookingDetailVC")
        completionHandler()
    }
}
// [END ios_10_message_handling]

@available(iOS 12.0, *)
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.set(fcmToken, forKey: "device_token") //MARK: DEVICE TOKEN SET
    }
}
