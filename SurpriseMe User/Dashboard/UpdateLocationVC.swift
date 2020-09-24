//
//  UpdateLocationVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 28/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class UpdateLocationVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var otherAddressTF: UITextField!
    @IBOutlet weak var btnHoe: UIButton!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var tfLandMark: UITextField!
    @IBOutlet weak var tfHouserNumber: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var btnCross: UIButton!
    
    //MARK:- Variable -
    let marker = GMSMarker()
    var addressType = String()
    var addressSelected = String()
    var addressLat = String()
    var addressLong = String()
    var objectViewModel = ManageAddressViewModel()
    var addressID = Int()
    var isEdit = Bool()
    var modelObjectDict = ManageAddressModel()
    var locationManager = CLLocationManager()

    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
        self.btnCross.isHidden = true
        
        if isEdit == true{
            let location = GMSCameraPosition.camera(withLatitude: modelObjectDict.lat ?? 0.0, longitude: modelObjectDict.long ?? 0.0, zoom: 19.0)
            mapView.camera = location
            self.tfAddress.text =  ""
            
        }else{
            if cameFrom == false{
                self.currentLocationGet()
            }else{
                self.setMarkerCustomLocation()
            }
        }
        self.mapView.delegate = self
        self.otherAddressTF.isHidden = true
        self.objectViewModel.delegate = self
        
    }
    
    
    
    @IBAction func btnCrossAction(_ sender: UIButton) {
        self.otherAddressTF.isHidden = true
        self.btnCross.isHidden = true
        addressType = ""
    }
    
    
    func getAddress(address:String){
        
        let key : String = "AIzaSyAeRjBp9uCEHLe-dIdsGVKegO9KzsmHmwA"
        let postParameters:[String: Any] = [ "address": address,"key":key]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        self.tfAddress.text =  address
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            
            if let receivedResults = response.result.value
            {
                
                let dictArray = receivedResults as! [String:Any]
                print(dictArray)
                let dictArrayValue  = dictArray["results"] as! [[String:Any]]
                print(dictArrayValue)
                let gemotry = dictArrayValue[0]
                let gemortyDict = gemotry["geometry"] as! [String:Any]
                let dictLocation = gemortyDict["location"] as! [String : Any]
                print(dictLocation["lat"] ?? 0.0)
                let latitude = dictLocation["lat"] as! Double
                let lognitude = dictLocation["lng"] as! Double
                
                let location = GMSCameraPosition.camera(withLatitude:latitude, longitude: lognitude, zoom: 19.0)
                self.mapView.camera = location
                self.tfAddress.text =  address
            }
        }
    }
    
    func setMarkerCustomLocation()  {
        self.getAddress(address: addressSelected)
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
              let getLatLong = locationManager.location
              print("Location services are not enabled");
            
              currentLat = getLatLong?.coordinate.latitude ?? 0.0
               currentLong = getLatLong?.coordinate.longitude ?? 0.0
              let location = GMSCameraPosition.camera(withLatitude: currentLat, longitude: currentLong, zoom: 19.0)
                             mapView.camera = location
                             self.tfAddress.text =  ""
             
              
          } else {
              print("Location services are not enabled");
          }
          
      }
    
    
    
    @IBAction func btnOtherAction(_ sender: UIButton) {
        addressType = "Other"
        self.otherAddressTF.isHidden = false
        self.btnCross.isHidden = false
        
    }
    
    @IBAction func btnWorkAction(_ sender: UIButton) {
        self.addressType = "Work"
        self.btnWork.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
        self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
        self.btnHoe.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
        
    }
    
    @IBAction func btnHomeAction(_ sender: UIButton) {
        self.addressType = "Home"
        self.btnHoe.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
        self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
        self.btnWork.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
        
        
    }
    
    func setAddress()  {
        var dictParam = [String : Any]()
        if addressType == "Other"{
            dictParam = ["name":otherAddressTF.text!,"longitude":addressLat,"latitude":addressLong,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.tfAddress.text!]
        }else{
            dictParam = ["name":addressType,"longitude":addressLat,"latitude":addressLong,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.tfAddress.text!]
        }
        self.objectViewModel.getParamForAddAddress(param: dictParam)
    }
    
    
    func setEditAddress()  {
        var dictParam = [String : Any]()
        if addressType == "Other"{
            dictParam = ["name":otherAddressTF.text!,"longitude":addressLat,"latitude":addressLong,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.tfAddress.text! , "id":modelObjectDict.id ?? 0]
        }else{
            dictParam = ["name":addressType,"longitude":addressLat,"latitude":addressLong,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.tfAddress.text! , "id":modelObjectDict.id ?? 0]
        }
        self.objectViewModel.getParamForEditAddress(param: dictParam)
    }
    
    
    @IBAction func btnSaveAddress(_ sender: UIButton) {
        
        if isEdit == true{
            
            if self.tfLandMark.text! == "" {
                Helper.showOKAlert(onVC: self, title: "", message: "Please select landmark")
            }else if self.tfHouserNumber.text! == ""{
                Helper.showOKAlert(onVC: self, title: "", message: "Please select House/flat Number")
            }
                
            else if addressType == "" {
                Helper.showOKAlert(onVC: self, title: "", message: "Please select address type")
            }else if self.otherAddressTF.text?.count == 0 && addressType == "Other"{
                Helper.showOKAlert(onVC: self, title: "", message: "Please enter other address")
            }
            else{
                self.setEditAddress()
            }
        }else{
            if self.tfLandMark.text! == "" {
                Helper.showOKAlert(onVC: self, title: "", message: "Please select landmark")
            }else if self.tfHouserNumber.text! == ""{
                Helper.showOKAlert(onVC: self, title: "", message: "Please select House/flat Number")
            }
            else if addressType == "" {
                Helper.showOKAlert(onVC: self, title: "", message: "Please select address type")
            }else if self.otherAddressTF.text?.count == 0 && addressType == "Other"{
                Helper.showOKAlert(onVC: self, title: "", message: "Please enter other address")
            }
            else{
                self.setAddress()
            }
        }
        
        
        
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String)  {
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(pdblLatitude),\(pdblLongitude)&key=\("AIzaSyAeRjBp9uCEHLe-dIdsGVKegO9KzsmHmwA")"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                let responseJson = response.result.value! as! NSDictionary
                print("the location is \(responseJson)")
                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if results[0]["address_components"]! is [NSDictionary] {
                            self.tfAddress.text = results[0]["formatted_address"] as? String
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
        
    }
    
}
extension UpdateLocationVC : GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(position.target.latitude)
        
        if isEdit == true{
            print("the edit address is \(position.target.latitude)")
            tfAddress.text = modelObjectDict.street_address ?? ""
            self.getAddressFromLatLon(pdblLatitude: "\(position.target.latitude )", withLongitude: "\(position.target.longitude )")
            self.tfLandMark.text = modelObjectDict.country ?? ""
            self.tfHouserNumber.text = modelObjectDict.state ?? ""
            addressLat = "\(position.target.latitude )"
            addressLong = "\(position.target.longitude )"
            
            if modelObjectDict.name == "Home"{
                self.btnHoe.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
                self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
                self.btnWork.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            }else if modelObjectDict.name == "Work"{
                self.btnWork.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
                self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
                self.btnHoe.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            }else{
                
                self.otherAddressTF.isHidden = false
                self.otherAddressTF.text = modelObjectDict.name ?? ""
                
            }
        }else{
            self.getAddressFromLatLon(pdblLatitude: "\(position.target.latitude )", withLongitude: "\(position.target.longitude )")
            addressLat = "\(position.target.latitude )"
            addressLong = "\(position.target.longitude )"
        }
        
        
    }
}

//Error handling Signup Api Here:-
extension UpdateLocationVC: ManageAddressViewModelProtocol {
    func addAddress() {
        print("added successfully")
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ManageAddressVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func manageAddressApiResponse(message: String, modelArray response:  [ManageAddressModel],isError :Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "OK") {
            }
        }else{
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
    
    func successAlert(susccessTitle: String, successMessage: String ,from:Bool)
    {
        Helper.showOKAlertWithCompletion(onVC: self, title: "", message: successMessage, btnOkTitle: "OK") {
            cameFrom = false
            if from == true{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ManageAddressVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            
        }
    }
    
}
extension UpdateLocationVC : CLLocationManagerDelegate{
    
    //MARK:- start point latitude and longitude convert into Address
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(pdblLatitude),\(pdblLongitude)&key=\("AIzaSyAeRjBp9uCEHLe-dIdsGVKegO9KzsmHmwA")"

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                let responseJson = response.result.value! as! NSDictionary
                print("the location is \(responseJson)")
                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            print("the location is value \(results[0]["formatted_address"] as? String)")
//                            self.locationTf.text = results[0]["formatted_address"] as? String
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
//                                    if (temp[0] == "postal_code") {
//                                        self.pincode = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "locality") {
//                                        self.city = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "administrative_area_level_1") {
//                                        self.state = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "country") {
//                                        self.country = component["long_name"] as? String
//                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
       
        
    }
    
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
