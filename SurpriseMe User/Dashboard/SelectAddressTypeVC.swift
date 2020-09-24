//
//  SelectAddressTypeVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 31/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SelectAddressTypeVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewHeader: UIView!
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addBottomShadow()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- CUstom button's Action -
    @IBAction func btnSelectOtherLocation(_ sender: UIButton) {
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ManualAddressVC)
        
    }
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        cameFrom = false
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.UpdateLocationVC)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

