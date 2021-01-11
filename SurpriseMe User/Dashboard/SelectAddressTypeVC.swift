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
import CoreLocation

class SelectAddressTypeVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnOtherLocation: UIButton!
    var locationManager = CLLocationManager()

    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setTitle("back".localized(), for: .normal)
        btnCurrentLocation.setTitle("CURRENT_LOCATION".localized(), for: .normal)
        btnOtherLocation.setTitle("OTHER_LOCATION".localized(), for: .normal)
        
        self.viewHeader.addBottomShadow()
        self.currentLocationGet()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- CUstom button's Action -
    @IBAction func btnSelectOtherLocation(_ sender: UIButton) {
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ManualAddressVC)
        
    }
    
    
    
     func currentLocationGet(){
            //Mark:- Get current Lat/Long.
            if (CLLocationManager.locationServicesEnabled()) {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.distanceFilter = 10.0
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
//                let getLatLong = locationManager.location
                print("Location services are not enabled");
    //            self.getAddressFromLatLon(pdblLatitude: getLatLong?.coordinate.latitude ?? 0.0, withLongitude: getLatLong?.coordinate.longitude ?? 0.0)
    //            currentLat = getLatLong?.coordinate.latitude ?? 0.0
    //            currentLong = getLatLong?.coordinate.longitude ?? 0.0
    //            self.getDataBookingList(pageNumber: 1)
                
                
            } else {
                print("Location services are not enabled");
            }
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

extension SelectAddressTypeVC : CLLocationManagerDelegate{
    
    //MARK:- start point latitude and longitude convert into Address
//    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
//
//        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(pdblLatitude),\(pdblLongitude)&key=\("AIzaSyAeRjBp9uCEHLe-dIdsGVKegO9KzsmHmwA")"
//
//        Alamofire.request(url).validate().responseJSON { response in
//            switch response.result {
//            case .success:
//
//                let responseJson = response.result.value! as! NSDictionary
//                print("the location is \(responseJson)")
//                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
//                    if results.count > 0 {
//                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
//                           // self.locationTf.text = results[0]["formatted_address"] as? String
//                            if self.locationTf.text == ""{
//                              //  self.currentLocationGetAgain()
//                            }
//
//                            currentAddress = self.locationTf.text!
//                        }
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//
//
//    }
    
    // After user tap on 'Allow' or 'Disallow' on the dialog
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("the user location is \(locations.first?.coordinate.latitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }
}
