//
//  ViewController.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 25/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tabBar : UITabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createTabBarControl()
    }


    func createTabBarControl()   {
        tabBar = UITabBarController()
        tabBar.tabBar.tintColor = .black
        
        let view1 = LoginVC()
        view1.title = "Home"
        
//        tabBar[0].titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0)
    
        
        let view12 = LoginVC()
        view12.title = "Freind"
        
        tabBar.viewControllers = [view1,view12]
//        self.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        self.view.addSubview(tabBar.view)
         present(ViewController(), animated: false, completion: nil)
        
        
    }
}

