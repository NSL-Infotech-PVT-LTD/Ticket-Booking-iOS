//
//  HOmeViewController.swift
//  SwiftApp_Demo
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import KJNavigationViewAnimation
import CoreLocation
import Alamofire
import Cosmos
import Stripe


class HOmeViewController: UIViewController , UIGestureRecognizerDelegate, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return UIViewController()
    }
    
    
    //MARK:- Outlets -
    @IBOutlet weak var viewUpdateLocation: UIView!
    @IBOutlet weak var searchHeaderView: KJNavigationViewAnimation!
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tableView_out: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var upperAnimatedView: KJNavigationViewAnimation!
    @IBOutlet weak var noDataFound: UIView!
    @IBOutlet weak var locationTf: UILabel!
    
    //MARK:- Variable -
    var viewModelObject  = HomeScreenViewModel()
    var arrayHomeArtistList = [GetArtistListHomeModel]()
    var arrayHomeArtistListLoadMore = [GetArtistListHomeModel]()
    var objectViewModel = ProfileViewModel()
    var locationManager = CLLocationManager()
    var pageInt = 1
    var isLoadMore = Bool()
    var animalList = [AnyObject]()
    
    
    
    //MARK:- View's Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("the user custom address is \(currentAddress)")
        

        self.showToast(message: "Your Toast Message", font: .systemFont(ofSize: 12.0))

        
        
        self.setDashLine()
        self.SetInitialSetup()
        self.tableView_out.isHidden = true
        self.noDataFound.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        topHeaderView.layer.cornerRadius = 1
        topHeaderView.layer.shadowColor = UIColor.darkGray.cgColor
        topHeaderView.layer.shadowOpacity = 1
        topHeaderView.layer.shadowRadius = 1
        //MARK:- Shade a view
        topHeaderView.layer.shadowOpacity = 0.5
        topHeaderView.layer.shadowOffset = CGSize(width: 1.0, height: 0.5)
        topHeaderView.layer.masksToBounds = false
        
        let tapviewimgUserProfile = UITapGestureRecognizer(target: self, action: #selector(self.handletaptapviewimgUserProfile(_:)))
        imgUserProfile.isUserInteractionEnabled = true
        imgUserProfile.addGestureRecognizer(tapviewimgUserProfile)
    }
    
    @objc func handletaptapviewimgUserProfile(_ sender: UITapGestureRecognizer? = nil) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- Setting tap gesture -
    func SetInitialSetup() {
        upperAnimatedView.setupFor(Tableview: tableView_out,
                                   viewController: self)
        upperAnimatedView.topbarMinimumSpace = .custom
        upperAnimatedView.isBlurrBackground = false
        upperAnimatedView.topbarMinimumSpaceCustomValue = 8
        tabBarController?.tabBarItem.selectedImage = UIImage.init(named: "artist_navbar")
        self.searchTxt.isUserInteractionEnabled = false
        self.viewSearch.isUserInteractionEnabled = true
        let tapviewFacebook = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewSearch(_:)))
        viewSearch.addGestureRecognizer(tapviewFacebook)
        let viewTapUpdateLocation = UITapGestureRecognizer(target: self, action: #selector(self.handletapLocation(_:)))
        viewUpdateLocation.addGestureRecognizer(viewTapUpdateLocation)
        if customAddress == false{
            self.currentLocationGet()
        }else{
            let dict = ["latitude":currentLat ,"longitude":currentLong ]
            print("the dictionary is \(dict)")
            self.viewModelObject.getParamForBookingList(param: dict)
            self.locationTf.text = currentAddress
        }
        viewModelObject.delegate = self
        objectViewModel.delegate = self
        objectViewModel.getParamForGetProfile(param: [:])
    }
    
    func getDataBookingList(pageNumber : Int )  {
        let dict = ["latitude":currentLat ,"longitude":currentLong , "limit" : "20" , "page" : pageNumber ] as [String : Any]
        self.viewModelObject.getParamForBookingList(param: dict)
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
            self.getAddressFromLatLon(pdblLatitude: getLatLong?.coordinate.latitude ?? 0.0, withLongitude: getLatLong?.coordinate.longitude ?? 0.0)
            currentLat = getLatLong?.coordinate.latitude ?? 0.0
            currentLong = getLatLong?.coordinate.longitude ?? 0.0
            self.getDataBookingList(pageNumber: 1)
            print("the user custom address is \(currentAddress)")
            print("the user custom address is \(self.locationTf.text!)")
            
            
        } else {
            print("Location services are not enabled");
        }
    }
    
    
    func setDashLine()  {
        let color = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00).cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = viewHeader.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 6).cgPath
        viewHeader.layer.addSublayer(shapeLayer)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK:- Handling tap Gesture Method -
    @objc func handletapviewSearch(_ sender: UITapGestureRecognizer? = nil) {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchArtistByNameVC") as! SearchArtistByNameVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handletapLocation(_ sender: UITapGestureRecognizer? = nil) {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        transition.type = .fade
        transition.subtype = .fromRight
        controller.hidesBottomBarWhenPushed = true
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(controller, animated: false)
    }
    
    
    
    @IBAction func btnViewProfileAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        transition.type = .fade
        transition.subtype = .fromRight
        controller.hidesBottomBarWhenPushed = true
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(controller, animated: false)
        
    }
    
    
    @objc func btnBookAction(sender:UIButton)  {
        userArtistID = arrayHomeArtistList[sender.tag].id ?? 0
//        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ScheduleBookingVC)
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "SchueduleVC") as! SchueduleVC
               let transition = CATransition()
               transition.duration = 0.5
               transition.timingFunction = CAMediaTimingFunction(name: .default)
               transition.type = .fade
               transition.subtype = .fromRight
               controller.hidesBottomBarWhenPushed = true
               navigationController?.view.layer.add(transition, forKey: kCATransition)
               navigationController?.pushViewController(controller, animated: false)
        
    }
    
    
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        transition.type = .fade
        transition.subtype = .fromRight
        controller.hidesBottomBarWhenPushed = true
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(controller, animated: false)
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView_out.contentOffset.y + tableView_out.frame.size.height) >= tableView_out.contentSize.height)
        {
            print("scrollViewDidEndDragging")
            if isLoadMore == false{
                self.pageInt = self.pageInt + 1
                print("scrollViewDidEndDragging page number is \(self.pageInt)")
                let dict = ["latitude":currentLat ,"longitude":currentLong , "limit" : "20" , "page" : pageInt ] as [String : Any]
                self.viewModelObject.getParamForBookingList(param: dict)
            }
        }
    }
}

extension HOmeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayHomeArtistList.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! homeTableCell
        cell.VIEWOUTERCONTAINER.addShadowWithCornerRadius(viewObject: cell.VIEWOUTERCONTAINER)
        let dataItem = arrayHomeArtistList[indexPath.row]
        cell.nameLbl_out.text = "\(dataItem.name ?? "")"
        cell.descriptionLbl_out.text = "\(dataItem.artistDescription ?? "")"
        if dataItem.category?.count ?? 0 == 0{
            cell.RolePlayLbl_out.text = ""
        }else{
            cell.RolePlayLbl_out.text = "\(dataItem.category?.map({$0}) ?? [] )"
        }
        
        if dataItem.ratingValue == "<null>"{
            cell.cosmoView.rating = 0.0
        }else{
            cell.cosmoView.rating = Double("\(dataItem.rating ?? 0)") ?? 0.0
        }
        
        
        
        
        let urlSting : String = "\(Api.imageURLArtist)\(dataItem.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        let urlImage = URL(string: urlStringaa)!
        cell.bannerImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.bannerImage.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        cell.bookBtn_out.tag = indexPath.row
        cell.bookBtn_out.addTarget(self, action: #selector(btnBookAction), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userArtistID = arrayHomeArtistList[indexPath.row].id ?? 0
        
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: "ViewProfileVC")
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        upperAnimatedView.scrollviewMethod?.scrollViewDidScroll(scrollView)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        upperAnimatedView.scrollviewMethod?.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        upperAnimatedView.scrollviewMethod?.scrollViewDidEndDecelerating(scrollView)
    }
    
    func getProfileData(profile :GetProfileModel? )  {
        print("the user image is \(Api.imageURL)\(profile?.image ?? "")")
        self.imgUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgUserProfile.sd_setImage(with: URL(string: "\(Api.imageURL)\(profile?.image ?? "")"), placeholderImage: UIImage(named: "user (1)"))
        
    }
    
}

class homeTableCell: UITableViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var PlayPauseImage: UIImageView!
    @IBOutlet weak var nameLbl_out: UILabel!
    @IBOutlet weak var descriptionLbl_out: UILabel!
    @IBOutlet weak var RolePlayLbl_out: UILabel!
    @IBOutlet weak var ratingView_out: UIView!
    
    
    @IBOutlet weak var cosmoView: CosmosView!
    @IBOutlet weak var VIEWOUTERCONTAINER: UIView!
    @IBOutlet weak var bookBtn_out: UIButton!
    @IBOutlet weak var viewContainer: UIView!
}


extension HOmeViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ScheduleBookingVC)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
}


//Error handling Get Profile Api Here:-
extension HOmeViewController: HomeViewModelProtocol ,ProfileViewModelProtocol{
    
    func bookingListApiResponse(message: String, response: [GetArtistListHomeModel], isError: Bool) {
        LoaderClass.shared.stopAnimating()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            print("the page number is \(self.pageInt)")
            if self.pageInt == 1{
                self.arrayHomeArtistList.removeAll()
                arrayHomeArtistList = response.map({$0})
                
            }else{
                self.arrayHomeArtistListLoadMore.removeAll()
                arrayHomeArtistListLoadMore = response.map({$0})
                arrayHomeArtistList = arrayHomeArtistList + self.arrayHomeArtistListLoadMore
                
                if arrayHomeArtistListLoadMore.count == 0{
                    isLoadMore = true
                }
                
                print("the page number is arrayHomeArtistListLoadMore\(arrayHomeArtistListLoadMore )")
                
            }
            
            if arrayHomeArtistList.count == 0{
                self.tableView_out.isHidden = true
                self.noDataFound.isHidden = false
                
            }else{
                self.tableView_out.isHidden = false
                self.noDataFound.isHidden = true
            }
            
            self.tableView_out.reloadData()
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimating()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
    func logoutResponse(isError: Bool, errorMessage: String){
        LoaderClass.shared.stopAnimating()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: errorMessage, btnOkTitle: "Done") {
            }
        }else{
            UserDefaults.standard.set(nil, forKey: UserdefaultKeys.token)
            UserDefaults.standard.removeObject(forKey: UserdefaultKeys.token)
            UserDefaults.standard.set(false, forKey: UserdefaultKeys.isLogin)
            LoaderClass.shared.stopAnimation()
            self.goToLogin()
        }
        
    }
    
    func getUpdateProfileApiResponse(message: String , isError : Bool){
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            objectViewModel.getParamForGetProfile(param: [:])
        }
    }
    
    func getProfileApiResponse(message: String, response: GetProfileModel?, isError: Bool) {
        LoaderClass.shared.stopAnimating()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            self.getProfileData(profile: response)
        }
    }
    
    func getProfileApiResponse(message: String, response: [String : Any], isError: Bool) {
    }
}



extension HOmeViewController : CLLocationManagerDelegate{
    
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
                            self.locationTf.text = results[0]["formatted_address"] as? String
                            currentAddress = self.locationTf.text!
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
