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
    
    func showLocationAccessAlert() {
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "settings", style: .default, handler: {(cAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)

    }
    
    
    
    
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        cameFrom = false
        
        
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                
                    self.showLocationAccessAlert()
                
                
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.UpdateLocationVC)
                }
            } else {
                print("Location services are not enabled")
            self.showLocationAccessAlert()

        }
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

