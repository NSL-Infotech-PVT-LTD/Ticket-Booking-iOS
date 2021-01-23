//
//  customTabBar.swift
//  CustomTabBar
//
//  Created by Jujhar Singh on 30/08/20.
//  Copyright © 2020 Jujhar Singh. All rights reserved.
//

import UIKit

class DashboardTabBarController: UITabBarController , UITabBarControllerDelegate{
    
    //MARK:- Variables -
    var controllerNavigationController = UINavigationController()
    var navgitaionController1 = UINavigationController()
    var controllerBookingSecond = UINavigationController()
    var controllerNavProfile = UINavigationController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        //MARK:- TABBAR LINE TOP ON PICS
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor(red: 212/255, green: 20/255, blue: 90/255, alpha: 1), size: CGSize(width: (view.frame.width/4), height: tabBar.frame.height), lineHeight: 2.0)
    }
    
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
           tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -15)
           print(item.image ?? "")
           print(item.index)
           
           if item == (self.tabBar.items!)[0]{
               //Do something if index is 0
               tabBar.items?[0].image = UIImage.init(named: "artist_navbar")
               tabBar.items?[1].image = nil
               tabBar.items?[2].image = nil
               
               tabBar.items?[0].title = ""
               tabBar.items?[1].title = "Booking"
               tabBar.items?[2].title = "Chat"
               
           }else if item == (self.tabBar.items!)[1]{
               //Do something if index is 1
               tabBar.items?[0].image = nil
               tabBar.items?[1].image = UIImage.init(named: "calender_navbar")
               tabBar.items?[2].image = nil
               
               tabBar.items?[0].title = "Home"
               tabBar.items?[1].title = ""
               tabBar.items?[2].title = "Chat"
               
           } else if item == (self.tabBar.items!)[2] {
               tabBar.items?[0].image = nil
               tabBar.items?[1].image = nil
               tabBar.items?[2].image = UIImage.init(named: "chat_navbar")
               
               tabBar.items?[0].title = "Home"
               tabBar.items?[1].title = "Booking"
               tabBar.items?[2].title = ""
           }
           tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor(red: 36/255, green: 29/255, blue: 255/255, alpha: 1), size: CGSize(width: (view.frame.width/4), height: tabBar.frame.height), lineHeight: 2.0)
       }
       
       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
           print(viewController)
       }
       
       func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           print("Should select viewController: \(viewController.title ?? "") ?")
           return true;
       }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 15)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        
        
//        let storyboardBooking = UIStoryboard(name: "BookingSetting", bundle: nil)
//                let controllerBooking = storyboardBooking.instantiateViewController(withIdentifier: "SchueduleVC") as! SchueduleVC
//                controlleBookingrNavigation = UINavigationController(rootViewController: controllerBooking)
//                controlleBookingrNavigation.isNavigationBarHidden = true
//                controlleBookingrNavigation.tabBarItem.title = "SCHEDULE".localized()
//                controlleBookingrNavigation.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -15)
//                //controlleBookingrNavigation.tabBarItem.image = UIImage.init(named: "TabbarSchedule")
//                //controlleBookingrNavigation.tabBarItem.selectedImage = UIImage.init(named: "TabbarCalandar")
//                controlleBookingrNavigation.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
        
        
        
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let storyboardHome = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboardHome.instantiateViewController(withIdentifier: "HOmeViewController") as! HOmeViewController
        controllerNavigationController = UINavigationController(rootViewController: controller)
        
        
        
        
//        controlleHomeNavigation.tabBarItem.image = UIImage.init(named: "TabbarHome")
//                controlleHomeNavigation.tabBarItem.selectedImage = UIImage.init(named: "TabbarHomeMike")
//                controlleHomeNavigation.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        
        controllerNavigationController.isNavigationBarHidden = true
        //controllerNavigationController.tabBarItem.title = "Home"
        controllerNavigationController.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -15)
        controllerNavigationController.tabBarItem.image = UIImage.init(named: "artist_navbar")
        controllerNavigationController.tabBarItem.selectedImage = UIImage.init(named: "artist_navbar")
        controllerNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)

        
        
        
        let storyboardBooking = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controllerBooking = storyboardBooking.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        controllerBookingSecond = UINavigationController(rootViewController: controllerBooking)
        
        
        controllerBookingSecond.isNavigationBarHidden = true
        controllerBookingSecond.tabBarItem.title = "Booking"
        controllerBookingSecond.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -15)
                    //controlleChatNavigation.tabBarItem.image = UIImage.init(named: "TabbarChatTitle")
                    //controlleChatNavigation.tabBarItem.selectedImage = UIImage.init(named: "TabbarChat")
        controllerBookingSecond.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        

//        controllerBookingSecond.tabBarItem.image = UIImage.init(named: "Booking")
//        controllerBookingSecond.tabBarItem.selectedImage = UIImage.init(named: "calender_navbar")
//        controllerBookingSecond.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -10, right: 0)
//
       
        
        
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "FriendListVC") as? FriendListVC {
            navgitaionController1 = UINavigationController(rootViewController: secondViewController)
//
//            navgitaionController1.tabBarItem.title = "Chat"
//            navgitaionController1.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -15)
            
            navgitaionController1.isNavigationBarHidden = true
            navgitaionController1.tabBarItem.title = "Chat"
            navgitaionController1.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -15)
                        //controlleChatNavigation.tabBarItem.image = UIImage.init(named: "TabbarChatTitle")
                        //controlleChatNavigation.tabBarItem.selectedImage = UIImage.init(named: "TabbarChat")
            navgitaionController1.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
//            navgitaionController1.tabBarItem.image = UIImage.init(named: "Chat-2")
//            navgitaionController1.tabBarItem.selectedImage = UIImage.init(named: "chat_navbar")
//            navgitaionController1.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -10, right: 0)
            var array = self.viewControllers
            array?.append(navgitaionController1)
            self.viewControllers = [controllerNavigationController,controllerBookingSecond,navgitaionController1]
        }
    }
    
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x :0,y: -2), size: CGSize(width: size.width, height: lineHeight)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

