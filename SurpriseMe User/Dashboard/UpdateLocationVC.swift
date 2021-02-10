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
import GooglePlaces
import CoreLocation

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
    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var lblAddressTextValue: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblAddDETAILS: UILabel!
    @IBOutlet weak var lblLandmark: UILabel!
    @IBOutlet weak var btnSaveAdd: ZFRippleButton!
    
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
    var isCurrentLocation = false
    var selectedFirstIndexAddress = String()
    var selectedFirstIndexId = Int()
    var selectedFirstIndexLat = Double()
    var selectedFirstIndexLong = Double()

    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setTitle("back".localized(), for: .normal)
        lblAddDETAILS.text = "ADD_DETAILS".localized()
        lblLandmark.text = "LANDMARK".localized()
        otherAddressTF.placeholder = "OTHER_ADD".localized()
        btnSaveAdd.setTitle("SAVE_ADD".localized(), for: .normal)
        btnHoe.setTitle("HOME".localized(), for: .normal)
        btnWork.setTitle("WORK".localized(), for: .normal)
        btnOther.setTitle("OTHER".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
        self.mapView.delegate = self
        self.stackViews.isHidden = false
        self.otherAddressTF.isHidden = true
        self.objectViewModel.delegate = self
        self.btnCross.isHidden = true
        currentLocationGet()
        lblAddressTextValue.isUserInteractionEnabled = true
        let tapviewAboutUs = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewAboutUs(_:)))
        lblAddressTextValue.addGestureRecognizer(tapviewAboutUs)
        if isEditValue == true && isEditAddress == true{
            setEditAddressAgain()
        }else if isEditValue == true && isEditAddress == false{
            setAddressInTextField()
        }
        else{
            self.setMarkerCustomLocation()
        }
    }
    
    @IBAction func btnEditActions(_ sender: UIButton) {
        isEditAddress = true
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ManualAddressVC") as! ManualAddressVC
        navigationController?.pushViewController(controller, animated: false)
    }
    
    func setEditAddressAgain()  {
        if addressSelected == ""{
            self.lblAddressTextValue.text =  addressStreetAddressAfterEdit
            self.getAddress(address: addressStreetAddressAfterEdit)
        }else{
            self.lblAddressTextValue.text =  addressSelected
            self.getAddress(address: addressSelected)
        }
        
       if addressLandMarkEdit  == "N/A" || addressLandMarkEdit  == ""{
        }else{
            self.tfLandMark.text = addressLandMarkEdit
        }
        if addressAdditionalDetailEdit == "N/A" || addressAdditionalDetailEdit == ""{
        }else{
            self.tfHouserNumber.text = addressAdditionalDetailEdit
        }
        if addressTypeEdit == "Home"{
            self.btnHoe.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
            self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.btnWork.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.stackViews.isHidden = false
            self.btnCross.isHidden = true
            self.otherAddressTF.isHidden = true
        }else if addressTypeEdit == "Work"{
            self.btnWork.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
            self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.btnHoe.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.stackViews.isHidden = false
            self.btnCross.isHidden = true
            self.otherAddressTF.isHidden = true
        }else if addressTypeEdit == "Other"{
            self.btnWork.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
            self.btnOther.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
            self.btnHoe.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.stackViews.isHidden = false
            self.btnCross.isHidden = true
            self.otherAddressTF.isHidden = true
        }
        else{
            self.stackViews.isHidden = true
            self.btnCross.isHidden = false
            self.otherAddressTF.isHidden = false
            self.otherAddressTF.text = otherAddresssFeildValue
        }
    }
    
    @IBAction func btnCurrentLocationAction(_ sender: UIButton) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.showLocationAccessAlert()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.currentLocationGet()
            }
        } else {
            print("Location services are not enabled")
            self.showLocationAccessAlert()
            
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
    
    @objc func handletapviewAboutUs(_ sender: UITapGestureRecognizer? = nil)
    {
        isEditAddress = true
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ManualAddressVC") as! ManualAddressVC
        navigationController?.pushViewController(controller, animated: false)
    }
    
    
    @IBAction func btnCrossAction(_ sender: UIButton) {
        self.otherAddressTF.isHidden = true
        self.btnCross.isHidden = true
        addressType = "Other"
        self.btnHoe.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
        self.btnOther.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
        self.btnWork.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
        self.otherAddressTF.text = ""
        self.stackViews.isHidden = false
    }
    
    func getAddress(address:String){
        
        let key : String = googleKey
        let postParameters:[String: Any] = [ "address": address,"key":key]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            
            if let receivedResults = response.result.value
            {
                let dictArray = receivedResults as! [String:Any]
                print(dictArray)
                let dictArrayValue  = dictArray["results"] as! [[String:Any]]
                print(dictArrayValue)
                if dictArrayValue.count > 0{
                    let gemotry = dictArrayValue[0]
                    let gemortyDict = gemotry["geometry"] as! [String:Any]
                    let dictLocation = gemortyDict["location"] as! [String : Any]
                    print(dictLocation["lat"] ?? 0.0)
                    let latitude = dictLocation["lat"] as! Double
                    let lognitude = dictLocation["lng"] as! Double
                    self.addressLat = "\(latitude)"
                    self.addressLong = "\(lognitude)"
                    let location = GMSCameraPosition.camera(withLatitude:latitude, longitude: lognitude, zoom: 19.0)
                    self.mapView.camera = location
                }else{
                }
            }
        }
    }
    
    func setMarkerCustomLocation()  {
        self.lblAddressTextValue.text =  addressSelected
        print("hii i am abhishek mishra")
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
            var location = GMSCameraPosition()
            print("Location services are not enabled");
            isCurrentLocation = true
            currentLat = getLatLong?.coordinate.latitude ?? 0.0
            currentLong = getLatLong?.coordinate.longitude ?? 0.0
            location = GMSCameraPosition.camera(withLatitude: currentLat, longitude: currentLong, zoom: 19.0)
            mapView.camera = location
        } else {
            print("Location services are not enabled");
        }
    }
    
    
    @IBAction func btnOtherAction(_ sender: UIButton) {
        addressType = "Other"
        self.otherAddressTF.isHidden = false
        self.stackViews.isHidden = true
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
        LoaderClass.shared.loadAnimation()
        
        var dictParam = [String : Any]()
        if addressType == "Other"{
            if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                
                if otherAddressTF.text! == ""{
                    
                    dictParam = ["name":"Other","longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else{
                    dictParam = ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
                
                
                
            
            }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                
                if otherAddressTF.text! == ""{
                    
                    dictParam = ["name":"Other","longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else{
                    dictParam = ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
                
                
            }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                
                
                if otherAddressTF.text! == ""{
                    dictParam = ["name":"Other","longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else{
                    dictParam = ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
                
                
               
            }
            else{
                
                if otherAddressTF.text! == ""{
                    dictParam = ["name":"Other","longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else{
                    dictParam = ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
                
                
                
            }
        }else{
            if addressType == ""{
                if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                    dictParam = ["name":"other","longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                    dictParam = ["name":"other","longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                    dictParam = ["name":"other","longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
                else{
                    dictParam = ["name":"other","longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
                
            }else{
                if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                    dictParam = ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                    dictParam = ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                    dictParam = ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
                else{
                    dictParam = ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text!]
                    print("the dict param is totally \(dictParam)")
                    self.objectViewModel.getParamForAddAddress(param: dictParam)
                }
            }
        }
       
    }
    
    
    func setEditAddress()  {
        LoaderClass.shared.loadAnimation()
        var dictParam = [String : Any]()
        if addressType == "Other" || addressType != "Home" || addressType != "Work"{
            if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else{
                    dictParam =
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
            }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else{
                    dictParam =
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
            }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else{
                    dictParam =
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
            }
            else{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else{
                    dictParam =
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
            }
        }else{
            if addressType == ""{
                if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                    dictParam =
                        ["name":"other","longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                    dictParam =
                        ["name":"other","longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                    dictParam =
                        ["name":"other","longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
                else{
                    dictParam =
                        ["name":"other","longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
            }else{
                if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
                else{
                    dictParam =
                        ["name":addressType,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":modelObjectDict.id ?? 0]
                }
            }
        }
        self.objectViewModel.getParamForEditAddress(param: dictParam)
        
        selectedFirstIndexLat = dictParam["latitude"] as? Double ?? 0.0
        selectedFirstIndexLong = dictParam["longitude"] as? Double ?? 0.0
        selectedFirstIndexAddress = dictParam["street_address"] as? String ?? ""
        selectedFirstIndexId = dictParam["id"] as? Int ?? 0

  
    }
    
    func setAddressEditAgain()  {
        
        LoaderClass.shared.loadAnimation()
        var dictParam = [String : Any]()
        if addressTypeEdit == "Other" || addressTypeEdit != "Home" || addressTypeEdit != "Work"{
            if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }else{
                    dictParam =
                        
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }
            }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }else{
                    dictParam =
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }
            }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"self.tfHouserNumber.text!","city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }else{
                    dictParam =
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }
            }
            else{
                if self.otherAddressTF.text == ""{
                    dictParam =
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }else{
                    dictParam =
                        ["name":otherAddressTF.text!,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }
            }
        }else{
            if addressType == ""{
                dictParam =
                    ["name":"other","longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
            }else{
                if self.tfLandMark.text! == "" && self.tfHouserNumber.text! == ""{
                    dictParam =
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }else  if self.tfLandMark.text! == "" && self.tfHouserNumber.text! != ""{
                    dictParam =
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":"N/A","zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }else  if self.tfLandMark.text! != "" && self.tfHouserNumber.text! == ""{
                    dictParam =
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":"N/A","city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }
                else{
                    dictParam =
                        ["name":addressTypeEdit,"longitude":addressLong,"latitude":addressLat,"country":self.tfLandMark.text!,"zip":"zip","state":self.tfHouserNumber.text!,"city":"city","street_address":self.lblAddressTextValue.text! , "id":addressIDEdit]
                }
            }
        }
        self.objectViewModel.getParamForEditAddress(param: dictParam)
        selectedFirstIndexLat = dictParam["latitude"] as? Double ?? 0.0
        selectedFirstIndexLong = dictParam["longitude"] as? Double ?? 0.0
        selectedFirstIndexAddress = dictParam["street_address"] as? String ?? ""
    }
    
    
    @IBAction func btnSaveAddress(_ sender: UIButton) {
        
        if isEditValue == true && isEditAddress == false{
           self.setEditAddress()
        }else if isEditValue == true && isEditAddress == true{
            setAddressEditAgain()
        }
        else{
            self.setAddress()
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String)  {
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(pdblLatitude),\(pdblLongitude)&key=\(googleKey)"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                let responseJson = response.result.value! as! NSDictionary
                print("the location is \(responseJson)")
                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if results[0]["address_components"]! is [NSDictionary] {
                            self.lblAddressTextValue.text = results[0]["formatted_address"] as? String
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
        self.getAddressFromLatLon(pdblLatitude: "\(position.target.latitude )", withLongitude: "\(position.target.longitude)")
        addressLat = "\(position.target.latitude )"
        addressLong = "\(position.target.longitude )"
        //        }
        
        
    }
}

//Error handling Signup Api Here:-
extension UpdateLocationVC: ManageAddressViewModelProtocol {
    func addAddress(isEdit: Bool) {
        print("added successfully")
        
        
        if isEdit == true{
            
            UserDefaults.standard.set( selectedFirstIndexLat, forKey: "SelectedLatValue")
            UserDefaults.standard.set( selectedFirstIndexAddress, forKey: "SelectedStreetAddress")
            UserDefaults.standard.set( selectedFirstIndexLong, forKey: "SelectedLongValue")
          //  UserDefaults.standard.set( selectedFirstIndexId, forKey: "SelectedIdValue")
            
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ManageAddressVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    isEditAddress = false
                    isEditAddress = false
                    isEditValue = false
                    isEditAddress = false
                    isEditValue = false
                    isEditAddress = false
                    addressIDEdit = ""
                    addressTypeEdit =  ""
                    addressAdditionalDetailEdit = ""
                    addressLandMarkEdit =  ""
                    otherAddresssFeildValue = ""
                    break
                }
            }
            
            
        }else{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ManageAddressVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    isEditAddress = false
                    isEditAddress = false
                    isEditValue = false
                    isEditAddress = false
                    isEditValue = false
                    isEditAddress = false
                    addressIDEdit = ""
                    addressTypeEdit =  ""
                    addressAdditionalDetailEdit = ""
                    addressLandMarkEdit =  ""
                    otherAddresssFeildValue = ""
                    break
                }
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
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(pdblLatitude),\(pdblLongitude)&key=\(googleKey)"
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                let responseJson = response.result.value! as! NSDictionary
                print("the location is \(responseJson)")
                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            print("the location is value \(results[0]["formatted_address"] as? String)")
                            //  self.lblAddressTextValue.text = results[0]["formatted_address"] as? String
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    //
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
        print("the user location is \(locations.first?.coordinate.latitude ?? 0.0)")
        
        //        if isCurrentLocation == true{
        //            addressLat = "\(locations.first?.coordinate.latitude ?? 0.0 )"
        //            addressLong = "\(locations.first?.coordinate.longitude ?? 0.0)"
        //        }
        
        // self.getAddressFromLatLon(pdblLatitude: "\(locations.first?.coordinate.latitude ?? 0.0 )", withLongitude: "\(locations.first?.coordinate.longitude ?? 0.0)")
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }
}

//set address in textfields
extension UpdateLocationVC {
    
    
    
    
    func setEditNew()  {
        
    }
    
    
    func setAddressInTextField() {
        
        
       // modelObjectDict = modelObjectAdress
        lblAddressTextValue.text = modelObjectDict.street_address ?? ""
        
        print("the run is \(modelObjectDict.street_address ?? "")")
        
        let location = GMSCameraPosition.camera(withLatitude: modelObjectDict.lat ?? 0.0, longitude: modelObjectDict.long ?? 0.0, zoom: 19.0)
        let cameraUpdate = GMSCameraUpdate.setCamera(location)
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        self.mapView.animate(with: cameraUpdate)
        CATransaction.commit()
        mapView.camera = location
        self.mapView.camera = location
        print("the param is \(isEditAddress)")
        print("the param is \(modelObjectDict.street_address ?? "")")
        print("the param is \(modelObjectDict.name ?? "" )")
        print("the latittude is \(modelObjectDict.lat ?? 0.0)")
        print("the long is \(modelObjectDict.long ?? 0.0)")
        if modelObjectDict.country ?? "" == "N/A" || modelObjectDict.country ?? "" == ""{
        }else{
            self.tfLandMark.text = modelObjectDict.country ?? ""
        }
        if modelObjectDict.state ?? "" == "N/A" || modelObjectDict.state ?? "" == ""{
        }else{
            self.tfHouserNumber.text = modelObjectDict.state ?? ""
        }
        addressLat = "\(modelObjectDict.lat ?? 0.0)"
        addressLong = "\(modelObjectDict.long ?? 0.0)"
        self.addressType = modelObjectDict.name ?? ""
        if modelObjectDict.name == "Home"{
            self.btnHoe.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
            self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.btnWork.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.stackViews.isHidden = false
            self.btnCross.isHidden = true
            self.otherAddressTF.isHidden = true
        }else if modelObjectDict.name == "Work"{
            self.btnWork.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
            self.btnOther.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.btnHoe.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.stackViews.isHidden = false
            self.btnCross.isHidden = true
            self.otherAddressTF.isHidden = true
        }else if modelObjectDict.name == "other"{
            self.btnWork.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.btnOther.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255.0, alpha: 1)
            self.btnHoe.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255.0, alpha: 1)
            self.stackViews.isHidden = false
            self.btnCross.isHidden = true
            self.otherAddressTF.isHidden = true
        }
        else{
            self.stackViews.isHidden = true
            self.btnCross.isHidden = false
            self.otherAddressTF.isHidden = false
            self.otherAddressTF.text = modelObjectDict.name ?? ""
        }
        addressIDEdit = "\(modelObjectDict.id ?? 0)"
        addressTypeEdit = modelObjectDict.name ?? ""
        addressStreetAddressAfterEdit = modelObjectDict.street_address ?? ""
        addressAdditionalDetailEdit = modelObjectDict.state ?? ""
        addressLandMarkEdit = modelObjectDict.country ?? ""
        otherAddresssFeildValue = self.otherAddressTF.text ?? ""
    }
}
