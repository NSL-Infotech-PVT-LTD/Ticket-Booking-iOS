//
//  customTabBar.swift
//  CustomTabBar
//
//  Created by Jujhar Singh on 30/08/20.
//  Copyright © 2020 Jujhar Singh. All rights reserved.
//

import UIKit

class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let storyboardHome = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboardHome.instantiateViewController(withIdentifier: "HOmeViewController") as! HOmeViewController
        controllerNavigationController = UINavigationController(rootViewController: controller)
        controllerNavigationController.tabBarItem.image = UIImage.init(named: "Home-2")
        controllerNavigationController.tabBarItem.selectedImage = UIImage.init(named: "artist_navbar")
        controllerNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -10, right: 0)
        
        let storyboardBooking = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controllerBooking = storyboardBooking.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        controllerBookingSecond = UINavigationController(rootViewController: controllerBooking)
        controllerBookingSecond.tabBarItem.image = UIImage.init(named: "Booking")
        controllerBookingSecond.tabBarItem.selectedImage = UIImage.init(named: "calender_navbar")
        controllerBookingSecond.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
       
        
        
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "FriendListVC") as? FriendListVC {
            navgitaionController1 = UINavigationController(rootViewController: secondViewController)
            navgitaionController1.tabBarItem.image = UIImage.init(named: "Chat-2")
            navgitaionController1.tabBarItem.selectedImage = UIImage.init(named: "chat_navbar")
            navgitaionController1.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
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
